variable "vpc_cidr" {}
variable "vpc_name" {}
variable "public_subnet_cidr" {}
variable "private_subnet_cidr" {}
variable "us_availability_zone" {}


output "my_vpc_us_east_1_id" {
  value = aws_vpc.my_vpc_us_east_1.id
}

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

# Internet Gateway
resource "aws_internet_gateway" "public_internet_gateway" {
  vpc_id = aws_vpc.my_vpc_us_east_1.id
  tags = {
    Name = "public_igw"
  }
}


# Route Tables for Public and Private Subnets:

# Public Route Table
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.my_vpc_us_east_1.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.public_internet_gateway.id
  }
  tags = {
    Name = "public-route"
  }
}

# Associating Public Route Table to Public Subnet:
resource "aws_route_table_association" "public_rt_subnet_association" {
  count          = length(aws_subnet.my_public_subnets)
  subnet_id      = aws_subnet.my_public_subnets[count.index].id
  route_table_id = aws_route_table.public_route_table.id
}

# Private Route Table
resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.my_vpc_us_east_1.id
  tags = {
    Name = "private-route"
  }
}

# Associating Private Route Table to Private Subnet:
resource "aws_route_table_association" "private_rt_subnet_association" {
  count          = length(aws_subnet.my_private_subnets)
  subnet_id      = aws_subnet.my_private_subnets[count.index].id
  route_table_id = aws_route_table.private_route_table.id
}