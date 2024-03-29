data "aws_eks_cluster" "example" {
  name = var.aws_eks_cluster_name
}

data "aws_iam_role" "eks_node_role" {
  name = var.eks_node_role
}

data "aws_subnet" "k8s_subnet_public1" {
  id = var.k8s_subnet_public1
}