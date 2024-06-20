module "networking" {
  source   = "./networking"
  vpc_cidr = var.vpc_cidr
  vpc_name = var.vpc_name
}