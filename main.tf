terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
  cloud {
    organization = "anils_test_repo"

    workspaces {
      name = "SYSM"
    }
  }
}
provider "aws" {
  profile = "deafult"
  region  = "us-east-1"
}
resource "aws_instance" "sample_server" {
  ami                    = "ami-052efd3df9dad4825"
  instance_type          = "t2.micro"
  key_name               = "anils-us-east-key1"
  vpc_security_group_ids = ["sg-0cc2a704d5e54eca8"]
  tags = {
    Name = "sample_server"
  }
  user_data = <<-EOF
  #!/bin/bash
  hostnamectl set-hostname sample_server
  apt-get update
  apt install -y nginx
  echo "Hello World DEmo1........" > /var/www/html/index.html
  service nginx restart
  EOF
}
output "public_ip_docker" {
  value       = aws_instance.sample_server.public_ip
  description = "this is sample server public ip"
}
