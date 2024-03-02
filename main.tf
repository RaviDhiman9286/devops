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
  region     = "us-east-1"
  access_key = "AKIAUEFISRKI7OPYN4HC"
  secret_key = "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"
}

# Create a AWS instance
resource "aws_instance" "demo-server" {
  ami                    = "ami-0440d3b780d96b29d"
  instance_type          = "t2.micro"
  #key_name               = "rkaws1"  # Make sure to replace with your actual key pair name
  vpc_security_group_ids = [aws_security_group.demo-sg.id]  # Use security group ID instead of name
  subnet_id              = aws_subnet.demo-subnet-public-01.id  # Use subnet ID

  tags = {
    Name = "my-first-server"
  }
}

# Create Security group
resource "aws_security_group" "demo-sg" {
  name        = "demo-sg"
  description = "Allow SSH access"
  vpc_id      = aws_vpc.demo-vpc.id

  ingress {
    description = "SSH Access"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "SSH Access"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  tags = {
    Name = "my-first-server-sg-allow-ssh"
  }
}

resource "aws_vpc" "demo-vpc" {
  cidr_block = "10.1.0.0/16"

  tags = {
    Name = "my-first-server-vpc"
  }
}

resource "aws_subnet" "demo-subnet-public-01" {
  vpc_id                  = aws_vpc.demo-vpc.id
  cidr_block              = "10.1.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "us-east-1a"
  tags = {
    Name = "my-public-subnet-1"
  }
}

resource "aws_subnet" "demo-subnet-public-02" {
  vpc_id                  = aws_vpc.demo-vpc.id
  cidr_block              = "10.1.2.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "us-east-1b"
  tags = {
    Name = "my-public-subnet-2"
  }
}

resource "aws_internet_gateway" "myigw" {
  vpc_id = aws_vpc.demo-vpc.id
  tags = {
    Name = "my-first-server-vpc-igw"
  }
}

resource "aws_route_table" "my-public-rt" {
  vpc_id = aws_vpc.demo-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.myigw.id
  }
  
}
  
resource "aws_route_table_association" "my-first-vpc-public-subnet-rta-01" {
  subnet_id       = aws_subnet.demo-subnet-public-01.id
  route_table_id  = aws_route_table.my-public-rt.id
}

resource "aws_route_table_association" "my-first-vpc-public-subnet-rta-02" {
  subnet_id       = aws_subnet.demo-subnet-public-02.id
  route_table_id  = aws_route_table.my-public-rt.id
}
