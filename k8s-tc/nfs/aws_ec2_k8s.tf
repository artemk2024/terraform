resource "aws_network_interface" "eth0_k8s_nfs1" {
  subnet_id   = aws_subnet.k8s_subnet_public1_eu_west_1a.id
  security_groups = [ aws_security_group.k8s-nfs-sg.id ]

  tags = {
    Project = "K8s"
    Name = "primary_network_interface"
  }
}


resource "aws_network_interface" "eth0_k8s_nfs2" {
  subnet_id   = aws_subnet.k8s_subnet_public1_eu_west_1a.id
  security_groups = [ aws_security_group.k8s-nfs-sg.id ]

  tags = {
    Project = "K8s"
    Name = "primary_network_interface"
  }
}


resource "aws_network_interface" "eth0_k8s_nfs3" {
  subnet_id   = aws_subnet.k8s_subnet_public1_eu_west_1a.id
  security_groups = [ aws_security_group.k8s-nfs-sg.id ]

  tags = {
    Project = "K8s"
    Name = "primary_network_interface"
  }
}


resource "aws_network_interface" "eth0_k8s_enclave" {
  subnet_id   = aws_subnet.k8s_subnet_public1_eu_west_1a.id
  security_groups = [ aws_security_group.k8s-nfs-sg.id ]

  tags = {
    Project = "K8s"
    Name = "primary_network_interface"
  }
}



resource "aws_instance" "k8s_nfs1" {
    ami                   = "ami-0781386be1d49672a"
    instance_type         = "t3.micro"
network_interface {
    network_interface_id = aws_network_interface.eth0_k8s_nfs1.id
    device_index         = 0
}
lifecycle {
#  privent_destroy = true //can not destroy resource
  create_before_destroy = true //  create a new instance and then remove old
}
    tags = {
      Name = "k8s-nfs1"
      OS = "RHEL8"
      Project = "k8s"
    }
}

resource "aws_instance" "k8s_nfs2" {
    ami                   = "ami-0781386be1d49672a"
    instance_type         = "t3.micro"
network_interface {
    network_interface_id = aws_network_interface.eth0_k8s_nfs2.id
    device_index         = 0
}
lifecycle {
#  privent_destroy = true //can not destroy resource
  create_before_destroy = true //  create a new instance and then remove old
}
    tags = {
      Name = "k8s-nfs2"
      OS = "RHEL8"
      Project = "k8s"
    }
}

resource "aws_instance" "k8s_nfs3" {
    ami                   = "ami-0781386be1d49672a"
    instance_type         = "t3.micro"
network_interface {
    network_interface_id = aws_network_interface.eth0_k8s_nfs3.id
    device_index         = 0
}
lifecycle {
#  privent_destroy = true //can not destroy resource
  create_before_destroy = true //  create a new instance and then remove old
}
    tags = {
      Name = "k8s-nfs3"
      OS = "RHEL8"
      Project = "k8s"
    }
}



resource "aws_instance" "enclave_server" {
  ami           = var.aws_ami_enaclve
  instance_type = var.aws_instance_type_enaclve
network_interface {
    network_interface_id = aws_network_interface.eth0_k8s_enclave.id
    device_index         = 0
}

  enclave_options {
    enabled = true
  }

lifecycle {
#  privent_destroy = true //can not destroy resource
  create_before_destroy = true //  create a new instance and then remove old
}

  tags = {
    Name = "ExampleInstance"
    OS = "RHEL8"
    Project = "k8s"
  }
}