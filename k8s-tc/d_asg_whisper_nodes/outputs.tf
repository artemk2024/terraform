output "whisper_ecr_repository_url" {
  value = data.terraform_remote_state.cluster.outputs.repository_url
}
# output "whisper_node_group_disk_size" {
#   value = aws_eks_node_group.whisper.disk_size
# }

# output "public_key" {
#   value = file("${path.module}/pk.pub")
# }

# # Last call overrides previous, hence know if keypair was created or not.
# # output "keypair_action_taken" {
# #   value = data.external.generate_ssh_key.result["keypair_action_taken"]
# # }

# ###
# # DEBUGGING SSH FUNCTIONALITY ITSELF.
# # WILL REMOVE ONCE DEBUGGING IS COMPLETE.
# ###
# output "private_key" {
#   value = file("${path.module}/pk.pem")
# }

output "eks_optimized_ami" {
  value = data.aws_ssm_parameter.eks_ami.value
}

output "ec2_instance_id_of_whisper_custom_ami_generating_node" {
  value = aws_instance.whisper_custom_ami_generating_instance.id
}

output "whisper_node_group_desired_capacity" {
  value = var.whisper_node_group_desired_capacity
}

output "whisper_node_group_min_capacity" {
  value = var.whisper_node_group_min_capacity
}

output "whisper_node_group_max_capacity" {
  value = var.whisper_node_group_max_capacity
}

output "whisper_image_tag_for_optimized_ami" {
  value = var.whisper_image_tag_for_optimized_ami
}
