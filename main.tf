terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.0.1"
    }
  }
  required_version = "~> 1.0"

  backend "remote" {
    organization = "Jithin-org"

    workspaces {
      name = "jithin-github-actions"
    }
  }
}


provider "aws" {
  region = "us-east-1"
}



resource "random_pet" "sg" {}

resource "aws_instance" "web" {
  ami                    = "ami-09e67e426f25ce0d7"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.web-sg.id]
  subnet_id              = subnet-018603bb07e03fb6e
  user_data              = <<-EOF
              #!/bin/bash
              echo "Hello, World, its me jithin using github actions" > index.html
              nohup busybox httpd -f -p 8080 &
              EOF
}

resource "aws_security_group" "web-sg" {
  name   = "${random_pet.sg.id}-sg"
  vpc_id = vpc-02678517a75935aa7
  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

output "web-address" {
  value = "${aws_instance.web.public_dns}:8080"
}
