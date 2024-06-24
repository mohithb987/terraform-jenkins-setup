variable "lb_tgt_grp_name" {}
variable "lb_tgt_grp_port" {}
variable "lb_tgt_grp_protocol" {}
variable "vpc_id" {}
variable "ec2_instance_id" {}

output "lb_tgt_group_arn" {
  value = aws_lb_target_group.lb_tgt_grp.arn
}

resource "aws_lb_target_group" "lb_tgt_grp" {
  name     = var.lb_tgt_grp_name
  port     = var.lb_tgt_grp_port
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

resource "aws_lb_target_group_attachment" "lb_tgt_group_attachment" {
  target_group_arn = aws_lb_target_group.lb_tgt_grp.arn
  target_id        = var.ec2_instance_id
  port             = 8080
}