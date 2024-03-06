############## VPC ################
variable "vpc_name" {
  default = "k8s-vpc"
  type    = string
}


############## AWS RDS ################
variable "aws_rds_name" {
  default = "postgres-server-demo"
  type    = string
}

variable "aws_rds_database_name" {
  default = "mydb"
  type    = string
}

variable "aws_rds_master_username" {
  default = "root"
  type    = string
}

variable "aws_rds_master_password" {
  default = "passwd3344556677"
  type    = string
}

############## Terraform Cloud ################

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