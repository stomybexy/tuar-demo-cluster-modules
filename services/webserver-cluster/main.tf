terraform {
  required_version = ">=1.2.0, <2.0.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

resource "aws_security_group" "web" {
  name = "${var.cluster_name}-web-sg"
}

resource "aws_security_group_rule" "web_ingress" {
  type              = "ingress"
  security_group_id = aws_security_group.web.id
  from_port         = var.server_port
  protocol          = local.tcp_protocol
  to_port           = var.server_port
  cidr_blocks       = local.all_ips
}

resource "aws_launch_configuration" "web" {
  image_id        = "ami-0b24feb030d5e3f22"
  instance_type   = var.instance_type
  security_groups = [aws_security_group.web.id]
  user_data = templatefile("${path.module}/user-data.sh", {
    server_port = var.server_port
    db_address  = var.db_address
    db_port     = var.db_port
  })
  lifecycle {
    create_before_destroy = true # Required when using with autoscaling group
  }
}

resource "aws_autoscaling_group" "web" {
  launch_configuration = aws_launch_configuration.web.name
  vpc_zone_identifier  = data.aws_subnets.default.ids
  target_group_arns    = [aws_lb_target_group.lb.arn]
  health_check_type    = "ELB"
  min_size             = var.min_size
  max_size             = var.max_size
  tag {
    key                 = "Name"
    propagate_at_launch = true
    value               = "${var.cluster_name}-asg"
  }
}


resource "aws_security_group" "lb" {
  name = "${var.cluster_name}-lb-sg"
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
  name               = "${var.cluster_name}-lb"
  load_balancer_type = "application"
  subnets            = data.aws_subnets.default.ids
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

resource "aws_lb_target_group" "lb" {
  name     = "${var.cluster_name}-tg"
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
  listener_arn = aws_lb_listener.lb.arn
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
