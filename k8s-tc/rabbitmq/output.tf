output "node_group_name_rabbitmq" {
  value = aws_eks_node_group.rabbitmq.node_group_name
}

output "node_group_id_rabbitmq" {
  value = aws_eks_node_group.rabbitmq.id
}

output "node_group_claster_name_rabbitmq" {
  value = aws_eks_node_group.rabbitmq.cluster_name
}

output "node_group_subnet_ids_rabbitmq" {
  value = aws_eks_node_group.rabbitmq.subnet_ids
}