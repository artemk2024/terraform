data "aws_vpc" "k8s" {
  name = var.vpc_name
}

data "aws_db_subnet_group" "subnet_db" {
  
}