variable "vpc_cidr" {}
variable "vpc_name" {}
variable "public_subnet_cidr" {}
variable "private_subnet_cidr" {}
variable "us_availability_zone" {}

# Setup VPC
resource "aws_vpc" "my_vpc_us_east_1" {
  cidr_block = var.vpc_cidr
  tags = {
    Name = var.vpc_name
  }
}


# public subnet setup
resource "aws_subnet" "my_public_subnets" {
  count             = length(var.public_subnet_cidr)
  vpc_id            = aws_vpc.my_vpc_us_east_1.id
  cidr_block        = element(var.public_subnet_cidr, count.index)
  availability_zone = element(var.us_availability_zone, count.index)

  tags = {
    Name = "my-public-subnet-${count.index + 1}"
  }
}

# private subnet setup
resource "aws_subnet" "my_private_subnets" {
  count             = length(var.private_subnet_cidr)
  vpc_id            = aws_vpc.my_vpc_us_east_1.id
  cidr_block        = element(var.private_subnet_cidr, count.index)
  availability_zone = element(var.us_availability_zone, count.index)

  tags = {
    Name = "my-private-subnet-${count.index + 1}"
  }
}