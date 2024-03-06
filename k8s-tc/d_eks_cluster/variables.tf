variable "cluster_name" {
  description = "The name of the EKS cluster"
  type        = string
}

variable "vpc_name" {
  description = "The name of the VPC for the cluster"
  type        = string
  default     = "cs-vpc"
}

variable "primary_azs" {
  type        = list(string)
  description = "List of availability zones for the node group"
  default     = []
}

variable "primary_node_group_name" {
  description = "The name of the primary node group for the cluster"
  type        = string
  default     = "primary-ng"
}

variable "primary_instance_types" {
  type        = list(string)
  description = "List of instance types for the node group"
  default     = ["t3.xlarge"]
}

variable "aws_region" {
  description = "The AWS region to deploy resources into"
  type        = string
}

variable "aws_account_id" {
  description = "The AWS account ID to deploy resources into"
  type        = string
}

variable "cluster_autoscaler_enabled" {
  description = "Whether to enable the cluster autoscaler"
  type        = bool
  default     = true
}

variable "AWS_DEFAULT_REGION" {
  description = "The AWS region to deploy resources into"
  type        = string
  default     = "" # This is set in Terraform Cloud - No need to set it here
}

variable "AWS_ACCESS_KEY_ID" {
  description = "The AWS access key ID"
  type        = string
  default     = "" # This is set in Terraform Cloud - No need to set it here
}

variable "AWS_SECRET_ACCESS_KEY" {
  description = "The AWS secret access key"
  type        = string
  default     = "" # This is set in Terraform Cloud - No need to set it here
}
