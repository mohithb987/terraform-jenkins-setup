variable "lb_tgt_grp_name_JENKINS" {}
variable "lb_tgt_grp_name_FALLBACK" {}
variable "lb_tgt_grp_port_JENKINS" {}
variable "lb_tgt_grp_port_FALLBACK" {}
variable "lb_tgt_grp_protocol" {}
variable "vpc_id" {}
variable "ec2_instance_id" {}
variable "sec_groups" {}
variable "fallback_instance_subnet_id" {}

output "lb_tgt_grp_JENKINS_arn" {
  value = aws_lb_target_group.lb_tgt_grp_JENKINS.arn
}
output "lb_tgt_grp_FALLBACK_arn" {
  value = aws_lb_target_group.lb_tgt_grp_FALLBACK.arn
}

resource "aws_lb_target_group" "lb_tgt_grp_JENKINS" {
  name     = var.lb_tgt_grp_name_JENKINS
  port     = var.lb_tgt_grp_port_JENKINS
  protocol = var.lb_tgt_grp_protocol
  vpc_id   = var.vpc_id
  health_check {
    path = "/login"
    port = 8080                 # jenkins port
    healthy_threshold = 6
    unhealthy_threshold = 2
    timeout = 2
    interval = 5
    matcher = "200"             # healthy if HTTP response is 200
  }
}

resource "aws_lb_target_group" "lb_tgt_grp_FALLBACK" {
  name     = var.lb_tgt_grp_name_FALLBACK
  port     = var.lb_tgt_grp_port_FALLBACK
  protocol = var.lb_tgt_grp_protocol
  vpc_id   = var.vpc_id
  health_check {
    path                = "/"
    port                = 80    
    protocol            = "HTTP"
    healthy_threshold   = 2     
    unhealthy_threshold = 2    
    timeout             = 3     
    interval            = 30    
    matcher             = "200"
  }
}

resource "aws_lb_target_group_attachment" "lb_tgt_group_attachment" {
  target_group_arn = aws_lb_target_group.lb_tgt_grp_JENKINS.arn
  target_id        = var.ec2_instance_id
  port             = 8080
}


resource "aws_instance" "fallback_instance" {
  ami = "ami-04b70fa74e45c3917"
  instance_type = "t2.micro"
  vpc_security_group_ids = var.sec_groups
  subnet_id = var.fallback_instance_subnet_id
  user_data = base64encode(file("load-balancer-target-group/fallback_instance_script.sh"))
  associate_public_ip_address = true
  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "required"
  }
  key_name        = "aws_ec2_terraform"
}

resource "aws_lb_target_group_attachment" "alb_target_group_attachment2" {
  target_group_arn = aws_lb_target_group.lb_tgt_grp_FALLBACK.arn
  target_id        = aws_instance.fallback_instance.id
  port             = 80
}
