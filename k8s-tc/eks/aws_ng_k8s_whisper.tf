# resource "aws_eks_node_group" "whisper" {
#   cluster_name    = aws_eks_cluster.example.name
#   node_group_name = "whisper"
#   disk_size = var.disk_size_whisper
#   ami_type = "AL2_x86_64"
#   instance_types = [var.aws_instance_type_whisper]
#   node_role_arn   = aws_iam_role.eks_node_role.arn 
#   subnet_ids      = [aws_subnet.k8s_subnet_public1_eu_west_1a.id]
#   scaling_config {
#     desired_size = 2
#     max_size     = 2
#     min_size     = 2
#   }

#   update_config {
#     max_unavailable = 1
#   }
# }