variable "vpc_cidr" {}
variable "vpc_name" {}

# Setup VPC
resource "aws_vpc" "my_vpc_us_east_1" {
  cidr_block = var.vpc_cidr
  tags = {
    Name = var.vpc_name
  }
}