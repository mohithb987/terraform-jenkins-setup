module "networking" {
  source   = "./networking"
  vpc_cidr = var.vpc_cidr
  vpc_name = var.vpc_name
  public_subnet_cidr   = var.public_subnet_cidr
  us_availability_zone = var.us_availability_zone
  private_subnet_cidr  = var.private_subnet_cidr
}


module "security_group" {
  source              = "./security-groups"
  ec2_sg_name         = "SG for EC2 to enable port 22 (SSH), port 443 (HTTPS) and port 80 (HTTP)"
  vpc_id              = module.networking.my_vpc_us_east_1_id
  ec2_jenkins_sg_name = "Enable port 8080 (HTTP) to access Jenkins"
}