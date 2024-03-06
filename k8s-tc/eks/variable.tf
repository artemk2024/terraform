############## VPC ################
variable "vpc_name" {
  default = "k8s-vpc"
  type    = string
}


variable "availability_zone_a" {
  default = "eu-west-2a"
  type    = string
}

variable "availability_zone_b" {
  default = "eu-west-2b"
  type    = string
}

variable "availability_zone_b" {
  default = "eu-west-2c"
  type    = string
}

############## EKS ################
variable "instance_types_ng" {
  default = "t3.medium"
  type    = string
}

variable "disk_size_ng" {
  default = 20
}

variable "aws_eks_cluster_name" {
  default = "example-k8s"
  type    = string
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