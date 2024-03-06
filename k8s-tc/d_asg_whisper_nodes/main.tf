data "terraform_remote_state" "cluster" {
  backend = "remote"

  config = {
    organization = "Clearspeed-Orchestration"
    workspaces = {
      name = var.remote_eks_workspace_name
    }
  }
}

# data "external" "generate_ssh_key" {
#   program = ["bash", "-c", "chmod +x ${path.module}/generate_ssh_key.sh && ${path.module}/generate_ssh_key.sh"]
# }

# Generate SSH key pair for EC2 instance authentication.
# This approach is chosen for operational efficiency and is deemed acceptable due to:
# 1. No sensitive data or operations are involved in the EC2 instance's lifecycle.
# 2. The need to streamline the process without assigning key management responsibilities.
# 3. Fulfilling AWS authentication requirements without introducing unnecessary bureaucracy.
#
# Also, will be auto-deleted by Terraform when a new configuration is applied over the existing one.
# resource "aws_key_pair" "deployer" {
#   # key_name = "${var.remote_eks_workspace_name}-whisper-deployer-key--${replace(timestamp(), ":", "")}"
#   key_name = "${var.remote_eks_workspace_name}-whisper-deployer-key--testing-only"
#   # public_key = file(data.external.generate_ssh_key.result["public_key_path"])
#   public_key = file("${path.module}/pk.pub")
# }

###
# Access to the Build AMI EC2 instance.
# From https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-instance-connect-prerequisites.html
###
# resource "aws_internet_gateway" "igw" {
#   vpc_id = data.terraform_remote_state.cluster.outputs.vpc_id
# }

data "aws_ssm_parameter" "eks_ami" {
  name = "/aws/service/eks/optimized-ami/${data.terraform_remote_state.cluster.outputs.cluster_version}/amazon-linux-2/recommended/image_id"
}

resource "aws_iam_role" "whisper_custom_ami_generating_node" {
  name = "whisper_custom_ami_generating_node"

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

resource "aws_iam_policy" "s3_read_access" {
  name        = "s3ReadAccess"
  description = "Policy to allow read access to a specific S3 bucket"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "s3:GetObject"
        Effect = "Allow"
        Resource = [
          "${aws_s3_bucket.whisper_bucket.arn}/*", # Grants access to all objects in the bucket
        ]
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "s3_read_access_attachment" {
  policy_arn = aws_iam_policy.s3_read_access.arn
  role       = aws_iam_role.whisper_custom_ami_generating_node.name
}

resource "aws_iam_instance_profile" "whisper_custom_ami_generating_node_profile" {
  name = "whisper_custom_ami_generating_node_profile"
  role = aws_iam_role.whisper_custom_ami_generating_node.name
}

resource "aws_iam_role_policy_attachment" "ami_cni_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.whisper_custom_ami_generating_node.name
}

resource "aws_iam_role_policy_attachment" "ami_read_only" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.whisper_custom_ami_generating_node.name
}

resource "aws_instance" "whisper_custom_ami_generating_instance" {
  # Search for this Ubuntu 22.04 Server AMI via the AWS EC2
  # "Launch Instance" wizard, click on the Ubuntu 22.04 Server
  # and view the AMI.
  # ami                  = data.aws_ssm_parameter.eks_ami.value
  ami                  = var.whisper_custom_ami_generating_instance_ami
  instance_type        = "t3.large"
  iam_instance_profile = aws_iam_instance_profile.whisper_custom_ami_generating_node_profile.name
  #   key_name                    = aws_key_pair.deployer.key_name
  #   vpc_security_group_ids      = [aws_security_group.allow_ssh.id]
  #   subnet_id                   = aws_subnet.whisper_ami_access_subnet.id
  #   associate_public_ip_address = true

  root_block_device {
    volume_size = 50
  }

  user_data = <<-EOF
    #!/bin/bash

    # No-op `user-data` change to test `user_data_replace_on_change` flag
    echo "NO-OP - 007"

    echo ""
    echo "**************************************************"
    echo "Starting user-data script execution"
    echo "**************************************************"
    echo ""

    echo ""
    echo "**************************************************"
    echo "Issuing call:"
    echo "echo 'export AWS_REGION=${data.terraform_remote_state.cluster.outputs.aws_region}' >> /etc/profile.d/whisper_variables.sh"
    echo "**************************************************"
    echo ""
    echo 'export AWS_REGION=${data.terraform_remote_state.cluster.outputs.aws_region}' >> /etc/profile.d//whisper_variables.sh

    echo ""
    echo "**************************************************"
    echo "Issuing call:"
    echo "echo 'export IMAGE_TAG=${var.whisper_image_tag_for_optimized_ami}' >> /etc/profile.d//whisper_variables.sh"
    echo "**************************************************"
    echo ""
    echo 'export IMAGE_TAG=${var.whisper_image_tag_for_optimized_ami}' >> /etc/profile.d//whisper_variables.sh

    echo ""
    echo "**************************************************"
    echo "Issuing call:"
    echo "echo 'export ECR_REPO=${data.terraform_remote_state.cluster.outputs.repository_url}' >> /etc/profile.d//whisper_variables.sh"
    echo "**************************************************"
    echo ""
    echo 'export ECR_REPO=${data.terraform_remote_state.cluster.outputs.repository_url}' >> /etc/profile.d//whisper_variables.sh

    echo ""
    echo "**************************************************"
    echo "Issuing call:"
    echo "export AWS_REGION=${data.terraform_remote_state.cluster.outputs.aws_region}"
    echo "**************************************************"
    echo ""
    export AWS_REGION=${data.terraform_remote_state.cluster.outputs.aws_region}

    echo ""
    echo "**************************************************"
    echo "Issuing call:"
    echo "export IMAGE_TAG=${var.whisper_image_tag_for_optimized_ami}"
    echo "**************************************************"
    echo ""
    export IMAGE_TAG=${var.whisper_image_tag_for_optimized_ami}

    echo ""
    echo "**************************************************"
    echo "Issuing call:"
    echo "export ECR_REPO=${data.terraform_remote_state.cluster.outputs.repository_url}"
    echo "**************************************************"
    echo ""
    export ECR_REPO=${data.terraform_remote_state.cluster.outputs.repository_url}

    echo ""
    echo "**************************************************"
    echo "Issuing call:"
    echo "sudo mkdir -p /data/HF_HOME"
    echo "**************************************************"
    echo ""
    sudo mkdir -p /data/HF_HOME

    echo ""
    echo "**************************************************"
    echo "Issuing call:"
    echo "sudo chown -R ec2-user:ec2-user /data"
    echo "**************************************************"
    echo ""
    sudo chown -R ec2-user:ec2-user /data

    echo ""
    echo "**************************************************"
    echo "Issuing call:"
    echo "aws s3 cp s3://${aws_s3_bucket.whisper_bucket.bucket}/download_whisper_data_al2.py /data/download_whisper_data_al2.py"
    echo "**************************************************"
    echo ""
    aws s3 cp s3://${aws_s3_bucket.whisper_bucket.bucket}/download_whisper_data_al2.py /data/download_whisper_data_al2.py

    echo ""
    echo "**************************************************"
    echo "Issuing call:"
    echo "aws s3 cp s3://${aws_s3_bucket.whisper_bucket.bucket}/configure_whisper_ami_al2.sh /data/configure_whisper_ami_al2.sh"
    echo "**************************************************"
    echo ""
    aws s3 cp s3://${aws_s3_bucket.whisper_bucket.bucket}/configure_whisper_ami_al2.sh /data/configure_whisper_ami_al2.sh

    echo ""
    echo "**************************************************"
    echo "Issuing call:"
    echo "sudo chmod +x /data/configure_whisper_ami_al2.sh"
    echo "**************************************************"
    echo ""
    sudo chmod +x /data/configure_whisper_ami_al2.sh

    echo ""
    echo "**************************************************"
    echo "Issuing call:"
    echo "cd /data"
    echo "**************************************************"
    echo ""
    cd /data

    echo ""
    echo "**************************************************"
    echo "Issuing call:"
    echo "./configure_whisper_ami_al2.sh"
    echo "**************************************************"
    echo ""
    ./configure_whisper_ami_al2.sh

    echo ""
    echo "**************************************************"
    echo "Issuing call:"
    echo "ls -l /etc/eks"
    echo "**************************************************"
    echo ""
    ls -l /etc/eks

    echo ""
    echo "**************************************************"
    echo "User-data script execution completed"
    echo "**************************************************"
    echo ""

  EOF

  # https://github.com/hashicorp/terraform-provider-aws/issues/23315
  # https://github.com/hashicorp/terraform-provider-aws/pull/23604
  # https://stackoverflow.com/questions/71264519/terraform-ec2-user-data-changes-not-replacing-the-ec2
  user_data_replace_on_change = true

  lifecycle {
    create_before_destroy = true
  }
}

resource "random_id" "randomizer" {
  byte_length = 8
}

resource "null_resource" "wait_for_cloud_init_completion" {
  depends_on = [aws_instance.whisper_custom_ami_generating_instance]

  triggers = {
    instance_id = aws_instance.whisper_custom_ami_generating_instance.id
  }
  provisioner "local-exec" {
    command = "sleep 1800"
  }
}

resource "aws_ami_from_instance" "custom_ami" {
  name               = var.whisper_custom_ami_name
  source_instance_id = aws_instance.whisper_custom_ami_generating_instance.id

  depends_on = [null_resource.wait_for_cloud_init_completion]
}

resource "aws_s3_bucket" "whisper_bucket" {
  bucket = "ami-${data.terraform_remote_state.cluster.outputs.aws_account_id}-${data.terraform_remote_state.cluster.outputs.cluster_name}"
}

resource "aws_s3_object" "download_whisper_data_script" {
  bucket = aws_s3_bucket.whisper_bucket.bucket
  key    = "download_whisper_data_al2.py"
  source = "${path.module}/download_whisper_data_al2.py"
  acl    = "private"
  etag   = filebase64sha256("${path.module}/download_whisper_data_al2.py")
}

resource "aws_s3_object" "configure_whisper_ami_script" {
  bucket = aws_s3_bucket.whisper_bucket.bucket
  key    = "configure_whisper_ami_al2.sh"
  source = "${path.module}/configure_whisper_ami_al2.sh"
  acl    = "private"
  etag   = filebase64sha256("${path.module}/configure_whisper_ami_al2.sh")
}

resource "aws_launch_template" "whisper_lt" {
  name_prefix   = "whisper-lt-"
  image_id      = aws_ami_from_instance.custom_ami.id
  instance_type = var.whisper_instance_types[0]
  #   key_name      = aws_key_pair.deployer.key_name
  block_device_mappings {
    device_name = var.whisper_node_boot_device_path

    ebs {
      volume_size = var.whisper_node_group_disk_size
      volume_type = var.whisper_node_boot_device_type
      iops        = var.whisper_node_boot_device_iops
    }
  }
  # Add tags for Cluster Autoscaler auto-discovery.
  # Matches the same in the EKS module's IAM Role creation-related resources.
  # Also matches the same in the Helm chart's values.yaml for the cluster autoscaler
  # (to set the "--node-group-auto-discovery" "command" for the cluster autoscaler's spec)
  tags = {
    "k8s.io/cluster-autoscaler/${data.terraform_remote_state.cluster.outputs.cluster_name}" = "true"
    "k8s.io/cluster-autoscaler/enabled"                                                     = "true"
  }

  user_data = base64encode(<<-EOF
    #!/bin/bash

    # No-op `user-data` change to test `user_data_replace_on_change` flag
    echo "NO-OP - 001"

    echo ""
    echo "************************************************"
    echo "Starting user-data script execution ON EKS NODE"
    echo "************************************************"
    echo ""

    echo ""
    echo "************************************************"
    echo "Issuing call ON EKS NODE:"
    echo "/etc/eks/bootstrap.sh ${data.terraform_remote_state.cluster.outputs.cluster_name}"
    echo "************************************************"
    echo ""

    # Include the call to bootstrap.sh with necessary arguments for your EKS cluster
    /etc/eks/bootstrap.sh ${data.terraform_remote_state.cluster.outputs.cluster_name}

    echo ""
    echo "************************************************"
    echo "User-data script execution completed ON EKS NODE"
    echo "************************************************"
    echo ""
    EOF
  )

  depends_on = [aws_ami_from_instance.custom_ami]
}

resource "aws_eks_node_group" "whisper" {
  cluster_name    = data.terraform_remote_state.cluster.outputs.cluster_name
  node_group_name = var.whisper_node_group_name
  node_role_arn   = aws_iam_role.node.arn
  subnet_ids      = data.terraform_remote_state.cluster.outputs.vpc_subnets

  scaling_config {
    desired_size = var.whisper_node_group_desired_capacity
    min_size     = var.whisper_node_group_min_capacity
    max_size     = var.whisper_node_group_max_capacity
  }

  launch_template {
    id      = aws_launch_template.whisper_lt.id
    version = aws_launch_template.whisper_lt.latest_version
  }

  labels = {
    workload_type = "whisper"
  }

  taint {
    key    = "whisper-node"
    value  = "true"
    effect = "NO_SCHEDULE"
  }

  # Add tags for Cluster Autoscaler auto-discovery.
  # Matches the same in the EKS module's IAM Role creation-related resources.
  # Also matches the same in the Helm chart's values.yaml for the cluster autoscaler
  # (to set the "--node-group-auto-discovery" "command" for the cluster autoscaler's spec)
  #   tags = {
  #     "k8s.io/cluster-autoscaler/${data.terraform_remote_state.cluster.outputs.cluster_name}" = "true"
  #     "k8s.io/cluster-autoscaler/enabled"                                                     = "true"
  #   }

  depends_on = [aws_launch_template.whisper_lt]
}

resource "aws_iam_role" "node" {
  name = "whisper-node-role"

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
