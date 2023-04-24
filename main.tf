terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}
provider "aws" {
  region = "us-east-1"
}

resource "aws_vpc" "my_vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "my-vpc"
  }
}

resource "aws_subnet" "my_subnet" {
  cidr_block = "10.0.1.0/24"
  vpc_id     = aws_vpc.my_vpc.id

  tags = {
    Name = "my-subnet"
resource "aws_security_group" "my_security_group" {
  name_prefix = "my-security-group"
  vpc_id      = aws_vpc.my_vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

tags = {
    Name = "my-security-group"
  }
}

resource "aws_key_pair" "my_blog_key" {
  key_name = "my_tf_key"
  public_key = file("/home/ubuntu/my-key.pub")
}
resource "aws_instance" "my_instance" {
  ami           = "ami-007855ac798b5175e"
  instance_type = "t2.micro"
  subnet_id = aws_subnet.my_subnet.id
  key_name = aws_key_pair.my_blog_key.key_name
  vpc_security_group_ids = ["my-security-group"]



  provisioner "remote-exec" {
    inline = [
      "sudo apt update",
      "sudo apt install -y nginx",
      "sudo systemctl start nginx",
      "sudo systemctl enable nginx"
    ]
  }
}
