terraform {
  required_version = ">=1.2.0, <2.0.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}


module "asg" {
  source             = "../../../cluster/asg-rolling-deploy"
  cluster_name       = "hello-world-${var.environment}"
  enable_autoscaling = var.enable_autoscaling
  ami                = var.ami
  instance_type      = var.instance_type
  user_data          = templatefile("${path.module}/user-data.sh", {
    server_port = var.server_port
    db_address  = var.db_address
    db_port     = var.db_port
    greeting    = var.greeting
  })
  server_port       = var.server_port
  max_size          = var.max_size
  min_size          = var.min_size
  subnet_ids        = data.aws_subnets.default.ids
  target_group_arns = [aws_lb_target_group.lb.arn]
  health_check_type = "ELB"
  custom_tags       = var.custom_tags
}

module "alb" {
  source = "../../../networking/alb"
  alb_name = "hello-world-${var.environment}"
  subnet_ids = data.aws_subnets.default.ids
}

resource "aws_lb_target_group" "lb" {
  name     = "hello-world-${var.environment}"
  port     = var.server_port
  protocol = "HTTP"
  vpc_id   = data.aws_vpc.default.id

  health_check {
    healthy_threshold   = 2
    interval            = 15
    path                = "/"
    matcher             = "200"
    port                = var.server_port
    protocol            = "HTTP"
    timeout             = 3
    unhealthy_threshold = 2
  }
}

resource "aws_alb_listener_rule" "lb" {
  listener_arn = module.alb.alb_http_listener_arn
  priority     = 100
  condition {
    path_pattern {
      values = ["*"]
    }
  }
  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.lb.arn
  }
}