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

module "jenkins" {
  source                    = "./jenkins"
  ami_id                    = var.ec2_ami_id
  max_price                 = 0.021
  instance_type             = "t2.medium"
  tag_name                  = "Jenkins:Ubuntu Linux EC2 Spot Instance"
  public_key                = var.public_key
  subnet_id                 = tolist(module.networking.my_public_subnet_ids)[0]
  sg_for_jenkins            = [module.security_group.EC2_SG_ssh_http_id, module.security_group.EC2_Jenkins_port_8080_id]
  associate_public_ip_address  = true
  user_data_install_jenkins = templatefile("./jenkins-runner-script/jenkins-installer.sh", {})
}