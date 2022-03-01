terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "4.3.0"
    }
  }
}

variable "ami" {}
variable "instance_type" {}

provider "aws" {
  profile = "default"
  region  = "us-east-1"
}

resource "aws_instance" "instance" {
  ami           = var.ami
  instance_type = var.instance_type
  vpc_security_group_ids = [aws_security_group.securityGroup.id]

  tags = {
    Name = "Sample"
  }
}

resource "aws_security_group" "securityGroup" {
  name        = "sample_allow_all"
  description = "Allow all traffic"

  ingress {
    description      = "TLS from VPC"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = []
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "allow_tls"
  }
}
output "instanceip" {
  value = aws_instance.instance.private_ip

}