resource "aws_eks_node_group" "rabbitmq" {
  cluster_name    = data.aws_eks_cluster.example.name
  node_group_name = "rabbitmq"
  disk_size = var.disk_size_rabbitmq
  ami_type = "AL2_x86_64"
  instance_types = [var.aws_instance_type_rabbitmq]
  node_role_arn   = data.aws_iam_role.eks_node_role.arn
  subnet_ids      = [data.aws_subnet.k8s_subnet_public1]
  scaling_config {
    desired_size = 1
    max_size     = 1
    min_size     = 1
  }

  update_config {
    max_unavailable = 1
  }
}