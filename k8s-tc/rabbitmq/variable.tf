############## EKS ################
variable "aws_eks_cluster_name" {
  default = "example-k8s"
  type    = string
}

############## RrabitMQ ################
variable "aws_instance_type_rabbitmq" {
  default = "t3.medium"
  type    = string
}

variable "disk_size_rabbitmq" {
  default = 60
}
############## IAM ################
variable "eks_node_role" {
  default = "AmazonEKSNodeRole"
  type = string
}

############## VPC Subnet ################
variable "k8s_subnet_public1_eu_west_1a" {
  default = "AmazonEKSNodeRole"
  type = string
}

############## Terraform Cloud  ################
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