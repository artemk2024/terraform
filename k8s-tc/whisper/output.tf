output "node_group_name_whisper" {
  value = aws_eks_node_group.whisper.node_group_name
}

output "node_group_id_whisper" {
  value = aws_eks_node_group.whisper.id
}

output "node_group_claster_name_whisper" {
  value = aws_eks_node_group.whisper.cluster_name
}

output "node_group_subnet_ids_whisper" {
  value = aws_eks_node_group.whisper.subnet_ids
}