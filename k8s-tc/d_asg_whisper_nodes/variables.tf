variable "remote_eks_workspace_name" {
  description = "The workspace name that triggers runs on this workspace"
  type        = string
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

variable "whisper_node_group_name" {
  description = "The name of the whisper node group for the cluster"
  type        = string
  default     = "whisper-ng"
}

variable "whisper_instance_types" {
  type        = list(string)
  description = "List of instance types for the Whisper node group"
  default     = ["t3.large"]
}

variable "whisper_node_group_disk_size" {
  description = "The disk size in GB for the whisper node group"
  type        = number
  default     = 200
}

variable "whisper_custom_ami_name" {
  type    = string
  default = "whisper-custom-ami"
}

variable "whisper_custom_ami_generating_instance_ami" {
  type = string
  # aws ssm get-parameter --name /aws/service/eks/optimized-ami/1.29/amazon-linux-2/recommended/image_id --query "Parameter.Value" --output text
  description = "Default EKS-enabled Amazon Linux AMI via AWS CLI call to Systems Manager Parameter Store at /aws/service/eks/optimized-ami/1.29/amazon-linux-2/recommended/image_id - used as the base AMI used to create the custom AMI for the whisper node group that has the ML model files pre-downloaded as part of the AMI for the node group. Cannot use Amazon Linux 2023 because THAT image does not have /etc/eks/bootstrap.sh, which is necessary to install the kubelet to work with the EKS cluster. And cannot use Ubuntu EKS-optimized version without cleaving automated installation in half for a required manual acceptance of a license agreement. The command is 'aws ssm get-parameter --name /aws/service/eks/optimized-ami/1.29/amazon-linux-2/recommended/image_id --query \"Parameter.Value\" --output text'"
  default     = ""
}

variable "whisper_node_group_desired_capacity" {
  description = "The desired capacity for the whisper node group"
  type        = number
  default     = 1
}

variable "whisper_node_group_min_capacity" {
  description = "The min capacity for the whisper node group"
  type        = number
  default     = 1
}

variable "whisper_node_group_max_capacity" {
  description = "The max capacity for the whisper node group"
  type        = number
  default     = 3
}

variable "whisper_image_tag_for_optimized_ami" {
  description = "The tag for the whisper image used to create the optimized AMI"
  type        = string
  default     = "latest"
}

variable "whisper_node_boot_device_path" {
  type    = string
  default = "/dev/xvda"
}

variable "whisper_node_boot_device_type" {
  type    = string
  default = "io2"
}

variable "whisper_node_boot_device_iops" {
  type    = number
  default = 10000
}
