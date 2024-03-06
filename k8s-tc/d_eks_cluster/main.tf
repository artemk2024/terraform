
###
# VPC
###

module "vpc" {

  # https://registry.terraform.io/modules/terraform-aws-modules/vpc/aws/latest

  source = "terraform-aws-modules/vpc/aws"

  name = var.vpc_name
  cidr = "10.0.0.0/16" # Up to [10.0.255.255]

  azs             = var.primary_azs
  private_subnets = ["10.0.0.0/20", "10.0.16.0/20"]    # Up to [10.0.15.255] and [10.0.31.255]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24"] # Up to [10.0.101.255] and [10.0.102.255]

  enable_nat_gateway = true
  enable_vpn_gateway = true

  tags = {
    Terraform = "true"
  }
}

###
# EKS cluster, associated detailed information upon its creation (the 'data' components),
# its associated OIDC provider, and the IAM role and EKS policies for the cluster itself
###

resource "aws_eks_cluster" "cluster" {
  name     = var.cluster_name
  role_arn = aws_iam_role.cluster.arn

  vpc_config {
    subnet_ids = module.vpc.private_subnets
  }

  depends_on = [
    aws_iam_role_policy_attachment.cluster,
  ]
}

data "aws_eks_cluster" "cluster" {
  name = var.cluster_name
  depends_on = [
    aws_eks_cluster.cluster,
  ]
}

data "aws_eks_cluster_auth" "cluster" {
  name = var.cluster_name
}

# https://stackoverflow.com/a/64659292/368896
data "tls_certificate" "cluster" {
  url = data.aws_eks_cluster.cluster.identity.0.oidc.0.issuer
}
resource "aws_iam_openid_connect_provider" "oidc_provider" {
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [data.tls_certificate.cluster.certificates.0.sha1_fingerprint]
  url             = data.aws_eks_cluster.cluster.identity.0.oidc.0.issuer
}

resource "aws_iam_role" "cluster" {
  name = "${var.cluster_name}-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "eks.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "cluster" {
  role       = aws_iam_role.cluster.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

###
# Primary node group and its associated IAM role and policies,
# which are standard for EKS node groups
###

resource "aws_eks_node_group" "node_group" {
  cluster_name    = aws_eks_cluster.cluster.name
  node_group_name = var.primary_node_group_name
  node_role_arn   = aws_iam_role.node.arn
  subnet_ids      = module.vpc.private_subnets

  scaling_config {
    desired_size = 3
    max_size     = 3
    min_size     = 3
  }

  instance_types = var.primary_instance_types

  depends_on = [
    aws_eks_cluster.cluster,
  ]
}

resource "aws_iam_role" "node" {
  name = "eks-node-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "eks_worker_node_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.node.name
}

resource "aws_iam_role_policy_attachment" "eks_cni_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.node.name
}

resource "aws_iam_role_policy_attachment" "ecr_read_only" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.node.name
}

# Optional: Attach this policy if your workloads require EBS volumes
resource "aws_iam_role_policy_attachment" "ebs_csi_driver" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
  role       = aws_iam_role.node.name
}

###
# Cluster Autoscaler IAM role and associated policies.
# Though the Cluster Autoscaler is not provisioned by Terraform
# (instead it is created as part of the cluster via Helm),
# it DOES need an IAM role with the proper policies attached;
# this role is associated with the Cluster Autoscaler via
# an annotation provided by the Helm chart for the K8s service account
#
# See
# https://github.com/rhythmictech/terraform-aws-eks-iam-cluster-autoscaler/blob/master/main.tf
# for most of the below,
#
# ...because the autoscaler's trust policy is very, very tricky to get right.
# It needs to trust the OIDC provider for JUST the cluster,
# and obtaining the correct OIDC provider information is super tricky.
#
# And for the actual cluster autoscaler Helm chart itself which USES this role, see:
# https://github.com/kubernetes/autoscaler
# https://github.com/kubernetes/autoscaler/blob/master/cluster-autoscaler/cloudprovider/aws/README.md
#
# For annotations, labels, etc. for the cluster autoscaler at the Helm level, see
# https://archive.eksworkshop.com/beginner/080_scaling/deploy_ca/
# Look at sample output:
# Annotations:         eks.amazonaws.com/role-arn: arn:aws:iam::197520326489:role/eksctl-eksworkshop-eksctl-addon-iamserviceac-Role1-12LNPCGBD6IPZ
###

data "aws_caller_identity" "current" {
}

locals {
  account_id          = data.aws_caller_identity.current.account_id
  issuer_host_path    = trim(aws_iam_openid_connect_provider.oidc_provider.url, "https://")
  provider_arn        = "arn:aws:iam::${local.account_id}:oidc-provider/${local.issuer_host_path}"
  service_account     = "cluster-autoscaler"
  service_account_arn = "system:serviceaccount:kube-system:${local.service_account}"
}

data "aws_iam_policy_document" "oidc_assume" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRoleWithWebIdentity"]

    principals {
      type        = "Federated"
      identifiers = [local.provider_arn]
    }

    condition {
      test     = "StringEquals"
      variable = "${local.issuer_host_path}:sub"
      values   = [local.service_account_arn]
    }
  }
}

data "aws_iam_policy_document" "cluster_autoscaler" {
  statement {
    sid    = "clusterAutoscalerAll"
    effect = "Allow"

    ###
    # The list that follows is a combination of
    # https://github.com/rhythmictech/terraform-aws-eks-iam-cluster-autoscaler/blob/master/main.tf
    # and
    # https://github.com/kubernetes/autoscaler/blob/master/cluster-autoscaler/cloudprovider/aws/README.md
    ###
    actions = [
      "autoscaling:DescribeAutoScalingGroups",
      "autoscaling:DescribeAutoScalingInstances",
      "autoscaling:DescribeLaunchConfigurations",
      "autoscaling:DescribeScalingActivities",
      "autoscaling:DescribeTags",
      "ec2:DescribeInstanceTypes",
      "ec2:DescribeLaunchTemplateVersions",
    ]

    resources = ["*"]
  }

  statement {
    sid    = "clusterAutoscalerOwn"
    effect = "Allow"

    ###
    # Ditto above
    ###
    actions = [
      "autoscaling:SetDesiredCapacity",
      "autoscaling:TerminateInstanceInAutoScalingGroup",
      "ec2:DescribeImages",
      "ec2:GetInstanceTypesFromInstanceRequirements",
      "eks:DescribeNodegroup",
      "autoscaling:UpdateAutoScalingGroup",
    ]

    resources = ["*"]

    # Add comparison to tags for Cluster Autoscaler auto-discovery.
    # Matches the same tags added in any associated module's ASG group settings.
    # Also matches the same in the Helm chart's values.yaml for the cluster autoscaler
    # (to set the "--node-group-auto-discovery" "command" for the cluster autoscaler's spec)
    condition {
      test     = "StringEquals"
      variable = "autoscaling:ResourceTag/kubernetes.io/cluster/${aws_eks_cluster.cluster.name}"
      values   = ["owned"]
    }

    condition {
      test     = "StringEquals"
      variable = "autoscaling:ResourceTag/k8s.io/cluster-autoscaler/enabled"
      values   = ["true"]
    }
  }
}

resource "aws_iam_policy" "cluster_autoscaler" {
  name_prefix = "cluster-autoscaler"
  description = "EKS cluster-autoscaler policy for cluster ${aws_eks_cluster.cluster.name}"
  policy      = data.aws_iam_policy_document.cluster_autoscaler.json
}

resource "aws_iam_role" "cluster_autoscaler" {
  name               = "eks-${aws_eks_cluster.cluster.name}-cluster-autoscaler"
  assume_role_policy = data.aws_iam_policy_document.oidc_assume.json
  path               = "/"
}

resource "aws_iam_role_policy_attachment" "cluster_autoscaler" {
  role       = aws_iam_role.cluster_autoscaler.name
  policy_arn = aws_iam_policy.cluster_autoscaler.arn
}

# resource "aws_iam_role_policy_attachment" "cluster_autoscaler" {
#   role       = aws_iam_role.cluster_autoscaler.name
#   policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterAutoscalerPolicy"
# }

###
# Optimization:
# Move the Whisper ECR repository to the EKS module
# so that the first time the Whisper module is run, the ECR repository exists
# because the Whisper module generates an AMI with a user-data script that expects the ECR repository to exist
###
resource "aws_ecr_repository" "whisper" {
  name                 = "whisper"
  image_tag_mutability = "MUTABLE"
}
