module "networking" {
  source   = "./networking"
  vpc_cidr = var.vpc_cidr
  vpc_name = var.vpc_name
  public_subnet_cidr   = var.public_subnet_cidr
  us_availability_zone = var.us_availability_zone
  private_subnet_cidr  = var.private_subnet_cidr
}