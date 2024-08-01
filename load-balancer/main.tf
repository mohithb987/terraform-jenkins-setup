variable "lb_name" {}
variable "lb_type" {}
variable "is_internal" { default = false }
variable "sec_group" {}
variable "subnet_ids" {}
variable "lb_target_group_jenkins_arn" {}
variable "lb_target_group_fallback_arn" {}
variable "lb_listener_port" {}

variable "lb_listener_protocol" {}

output "aws_lb_dns_name" {
  value = aws_lb.appl-load-balancer.dns_name
}

output "aws_lb_zone_id" {
  value = aws_lb.appl-load-balancer.zone_id
}


resource "aws_lb" "appl-load-balancer" {
  name               = var.lb_name
  internal           = var.is_internal
  load_balancer_type = var.lb_type
  security_groups    = [var.sec_group]
  subnets            = var.subnet_ids
  ip_address_type    = "ipv4"
  enable_deletion_protection = false
}

resource "aws_lb_listener" "lb_listener" {
  load_balancer_arn = aws_lb.appl-load-balancer.arn
  port              = var.lb_listener_port
  protocol          = var.lb_listener_protocol
  default_action {
    type             = "forward"
    target_group_arn = var.lb_target_group_jenkins_arn
    }
}


resource "aws_lb_listener_rule" "forward_to_fallback" {
  listener_arn = aws_lb_listener.lb_listener.arn
   priority     = 1

  action {
    type             = "forward"
    target_group_arn = var.lb_target_group_fallback_arn
  }

  condition {
    path_pattern {
      values = ["/"]
    }
  }
}