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
  source                       = "./jenkins"
  ami_id                       = var.ec2_ami_id
  max_price                    = 0.021
  instance_type                = "t2.medium"
  tag_name                     = "Jenkins:Ubuntu Linux EC2 Spot Instance"
  public_key                   = var.public_key
  subnet_id                    = tolist(module.networking.my_public_subnet_ids)[0]
  sg_for_jenkins               = [module.security_group.EC2_SG_ssh_http_id, module.security_group.EC2_Jenkins_port_8080_id]
  associate_public_ip_address  = true
  user_data_install_jenkins    = templatefile("./jenkins-runner-script/jenkins-installer.sh", {})
}


module "load_bal_tgt_group" {
  source                      = "./load-balancer-target-group"
  lb_tgt_grp_name_JENKINS     = "jenkins-lb-target-group"
  lb_tgt_grp_name_FALLBACK    = "fallback-lb-target-group"
  lb_tgt_grp_port_JENKINS     = "8080"
  lb_tgt_grp_port_FALLBACK    = "80"
  lb_tgt_grp_protocol         = "HTTP"
  sec_groups                  = [module.security_group.EC2_SG_ssh_http_id, module.security_group.EC2_Jenkins_port_8080_id]
  vpc_id                      = module.networking.my_vpc_us_east_1_id
  ec2_instance_id             = module.jenkins.jenkins_ec2_instance_id  # assign master EC2 instance to the target group
  fallback_instance_subnet_id = tolist(module.networking.my_public_subnet_ids)[1]
  jenkins_instance_public_ip = module.jenkins.jenkins_instance_public_ip
}

module "application_load_bal" {
  source                    = "./load-balancer"
  lb_name                   = "appl-load-balancer"
  is_internal               = false
  lb_type                    = "application"   # being deployed on EC2 instances
  sec_group                 = module.security_group.alb_sg_id
  subnet_ids                 = tolist(module.networking.my_public_subnet_ids)
  lb_target_group_jenkins_arn = module.load_bal_tgt_group.lb_tgt_grp_JENKINS_arn
  lb_target_group_fallback_arn = module.load_bal_tgt_group.lb_tgt_grp_FALLBACK_arn
  
  # listener
  lb_listener_port           = "80"
  lb_listener_protocol       = "HTTP"
}