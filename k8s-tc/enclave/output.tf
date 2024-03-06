output "node_group_name_nitroenclave" {
  value = aws_eks_node_group.nitroenclave.node_group_name
}

output "node_group_id_nitroenclave" {
  value = aws_eks_node_group.nitroenclave.id
}

output "node_group_claster_name_nitroenclave" {
  value = aws_eks_node_group.nitroenclave.cluster_name
}

output "node_group_subnet_ids_nitroenclave" {
  value = aws_eks_node_group.nitroenclave.subnet_ids
}