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
  image_id        = var.ami
  instance_type   = var.instance_type
  security_groups = [aws_security_group.web.id]
  user_data       = var.user_data
  lifecycle {
    create_before_destroy = true # Required when using with autoscaling group
  }
}

resource "aws_autoscaling_group" "web" {
  launch_configuration = aws_launch_configuration.web.name
  vpc_zone_identifier  = var.subnet_ids
  target_group_arns    = var.target_group_arns
  health_check_type    = var.health_check_type
  min_size             = var.min_size
  max_size             = var.max_size
  # use instance refresh to natively rollout new instances
  instance_refresh {
    strategy = "Rolling"
    preferences {
      min_healthy_percentage = 50
    }
  }
  tag {
    key                 = "Name"
    propagate_at_launch = true
    value               = "${var.cluster_name}-asg"
  }
  dynamic "tag" {
    for_each = {
      for k, v in var.custom_tags :
      k => upper(v) if k != "Name"
    }
    content {
      key                 = tag.key
      value               = tag.value
      propagate_at_launch = true
    }
  }
}

resource "aws_autoscaling_schedule" "scale_out" {
  count                  = var.enable_autoscaling ? 1 : 0
  autoscaling_group_name = aws_autoscaling_group.web.name
  scheduled_action_name  = "scale-out-during-business-hours"
  min_size               = 2
  max_size               = 10
  desired_capacity       = 5
  recurrence             = "0 9 * * 1-5"
  time_zone              = "Europe/London"
}

resource "aws_autoscaling_schedule" "scale_in" {
  count                  = var.enable_autoscaling ? 1 : 0
  autoscaling_group_name = aws_autoscaling_group.web.name
  scheduled_action_name  = "scale-in-at-night"
  min_size               = 2
  max_size               = 10
  desired_capacity       = 2
  recurrence             = "0 17 * * 1-5"
  time_zone              = "Europe/London"
}

resource "aws_cloudwatch_metric_alarm" "high_cpu_utilization" {
  alarm_name  = "${var.cluster_name}-high-cpu-utilization"
  namespace   = "AWS/EC2"
  metric_name = "CPUUtilization"

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.web.name
  }

  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  period              = 300
  statistic           = "Average"
  threshold           = 90
  unit                = "Percent"
}

resource "aws_cloudwatch_metric_alarm" "low_cpu_credit_balance" {
  count = format("%.1s", var.instance_type) == "t" ? 1 : 0

  alarm_name  = "${var.cluster_name}-low-cpu-credit-balance"
  namespace   = "AWS/EC2"
  metric_name = "CPUCreditBalance"

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.web.name
  }

  comparison_operator = "LessThanThreshold"
  evaluation_periods  = 1
  period              = 300
  statistic           = "Minimum"
  threshold           = 10
  unit                = "Count"
}