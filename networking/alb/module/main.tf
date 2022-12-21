terraform {
  required_version = ">=1.2.0, <2.0.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

resource "aws_security_group" "lb" {
  name = var.alb_name
}

resource "aws_security_group_rule" "lb_ingress" {
  type              = "ingress"
  security_group_id = aws_security_group.lb.id
  from_port         = local.http_port
  protocol          = local.tcp_protocol
  to_port           = local.http_port
  cidr_blocks       = local.all_ips
}

resource "aws_security_group_rule" "lb_egress" {
  type              = "egress"
  security_group_id = aws_security_group.lb.id
  from_port         = local.any_port
  protocol          = local.any_protocol
  to_port           = local.any_port
  cidr_blocks       = local.all_ips
}


resource "aws_lb" "lb" {
  name               = var.alb_name
  load_balancer_type = "application"
  subnets            = var.subnet_ids
  security_groups    = [aws_security_group.lb.id]
}

resource "aws_lb_listener" "lb" {
  load_balancer_arn = aws_lb.lb.arn
  port              = local.http_port
  protocol          = "HTTP"
  default_action {
    type = "fixed-response"
    fixed_response {
      content_type = "text/plain"
      message_body = "404: Not Found"
      status_code  = "404"
    }
  }
}

