variable "vpc_cidr" {
  type        = string
  description = "My us-east-1 VPC CIDR block"
}

variable "vpc_name" {
  type        = string
  description = "My us-east-1 VPC"
}

variable "public_subnet_cidr" {
  type        = list(string)
  description = "Public Subnet CIDR block"
}

variable "private_subnet_cidr" {
  type        = list(string)
  description = "Private Subnet CIDR block"
}

variable "us_availability_zone" {
  type        = list(string)
  description = "Availability Zones"
}

variable "ec2_ami_id" {
  type        = string
  description = "AMI ID for Ubuntu EC2 instance"
}

variable "public_key" {
  type        = string
  description = "Public Key to SSH into EC2 instance"
}