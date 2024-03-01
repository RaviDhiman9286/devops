terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"
  access_key = "AKIASSGFFARUNEEYYJT6"
  secret_key = "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"
}



# Create a aws instance
resource "aws_instance" "demo-server" {
    ami = "ami-0440d3b780d96b29d"
    instance_type = "t2.micro"
    #key_name = "rkaws1"
    security_groups = ["demo-sg"]

    tags = {
    Name = "my-first-server"
    }
}

# Create Security group
resource "aws_security_group" "demo-sg" {
  name        = "demo-sg"
  description = "Allow SSH access"
  #vpc_id      = aws_vpc.main.id

  ingress {
    description = "SSH Access"
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
   }

  egress {
    description = "SSH Access"
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
   }
  
  tags = {
    Name = "my-first-server-sg-allow-ssh"
  }
}

