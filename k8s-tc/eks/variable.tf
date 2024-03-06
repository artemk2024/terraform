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

variable "availability_zone_c" {
  default = "eu-west-2c"
  type    = string
}

############## Asterisk ################
variable "aws_instance_type_asterisk" {
  default = "t3.medium"
  type    = string
}

variable "disk_size_asterisk" {
  default = 60
}


############## Enclave ################
variable "aws_instance_type_enaclve" {
#  default = "m5.4xlarge"
  default = "t3.medium"
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