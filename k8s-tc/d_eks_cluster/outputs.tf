output "cluster_name" {
  value = aws_eks_cluster.cluster.name
}

output "cluster_id" {
  value = aws_eks_cluster.cluster.id
}

output "cluster_version" {
  value = aws_eks_cluster.cluster.version
}

output "vpc_id" {
  value = module.vpc.vpc_id
}

output "vpc_subnets" {
  value = module.vpc.private_subnets
}

output "vpc_public_subnets" {
  value = module.vpc.public_subnets
}

output "aws_region" {
  value = var.aws_region
}

output "aws_account_id" {
  value = var.aws_account_id
}

output "cluster_autoscaler_enabled" {
  value = var.cluster_autoscaler_enabled
}

output "oidc_provider_arn" {
  value = aws_iam_openid_connect_provider.oidc_provider.arn
}

output "oidc_provider_url" {
  value = aws_iam_openid_connect_provider.oidc_provider.url
}

output "iam_role_cluster_autoscaler_arn" {
  description = "IAM role ARN for the cluster autoscaler"
  value       = aws_iam_role.cluster_autoscaler.arn
}

output "iam_role_cluster_autoscaler_name" {
  description = "IAM role name for the cluster autoscaler"
  value       = aws_iam_role.cluster_autoscaler.name
}

output "route_table_id" {
  value = module.vpc.private_route_table_ids[0]
}

output "internet_gateway_id" {
  description = "The ID of the Internet Gateway associated with the VPC"
  value       = module.vpc.igw_id
}

output "repository_url" {
  value = aws_ecr_repository.whisper.repository_url
}
