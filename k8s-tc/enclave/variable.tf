

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