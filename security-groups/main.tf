variable "ec2_sg_name" {}
variable "vpc_id" {}
variable "ec2_jenkins_sg_name" {}

resource "aws_security_group" "EC2_SG_ssh_http" {
  name        = var.ec2_sg_name
  description = "SG for EC2 to enable port 22 (SSH) and port 80 (HTTP)"
  vpc_id      = var.vpc_id

  # Incoming Requests for EC2 instance:
  ingress {
    description = "Allow remote SSH from anywhere"
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
  }

  ingress {
    description = "Allow HTTP request from anywhere"
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
  }

  ingress {
    description = "Allow HTTP request from anywhere"
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
  }

  # Outgoing Requests:
  egress {
    description = "Allow all outgoing requests from EC2 instance"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "SG for EC2 to enable enable SSH, HTTP for EC2 instance"
  }
}

resource "aws_security_group" "EC2_Jenkins_port_8080" {
  name        = var.ec2_jenkins_sg_name
  description = "SG to Enable HTTP for Jenkins"
  vpc_id      = var.vpc_id

  # ssh for terraform remote exec
  ingress {
    description = "Allow 8080 port to access Jenkins"
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
  }

  tags = {
    Name = "SG to allow HTTP (8080) for Jenkins"
  }
}