terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "3.47.0"
    }
  }
  cloud {
    organization = "anils_test_repo"

    workspaces {
      name = "GHA_WS"
    }
  }
}
provider "aws" {
  profile = "deafult"
  region  = "ap-northeast-1"
}
resource "aws_instance" "sample_server" {
  ami                    = "ami-088da9557aae42f39"
  instance_type          = "t2.micro"
  key_name               = "sys"
  vpc_security_group_ids = ["sg-0068d68db6ff4b5a6"]
  tags = {
    Name = "sample_server"
  }
  user_data = <<-EOF
  #!/bin/bash
  hostnamectl set-hostname sample_server
  apt-get update
  apt install -y nginx
  echo "Hello World" > /var/www/html/index.html
  service nginx restart
  EOF
}
output "public_ip_docker" {
  value       = aws_instance.sample_server.public_ip
  description = "this is sample server public ip"
}
