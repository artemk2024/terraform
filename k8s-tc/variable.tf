variable "region" {
  default     = "eu-west-1"
  type        = string
  description = "Region where create EKS"
}

variable "instance_types_ng" {
  default = "t3.medium"
  type    = string
}

variable "disk_size_ng" {
  default = 20
}

variable "vpc_name" {
  default = "k8s-vpc"
  type    = string
}

variable "aws_eks_cluster_name" {
  default = "example-k8s"
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

############## Enclave ################
variable "aws_instance_type_enaclve" {
  default = "m5.4xlarge"
  type    = string
}

variable "aws_ami_enaclve" {
  default = "ami-0781386be1d49672a123"
  type    = string
}

variable "disk_size_enaclve" {
  default = 100
}

############## RrabitMQ ################
variable "aws_instance_type_rabbitmq" {
  default = "t3.medium"
  type    = string
}

variable "disk_size_rabbitmq" {
  default = 60
}

############## Whisper ################
variable "aws_instance_type_whisper" {
  default = "c4a.16xlarge"
  type    = string
}

variable "disk_size_whisper" {
  default = 120
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