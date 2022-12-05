output "alb_dns_name" {
  value       = aws_lb.lb.dns_name
  description = "The URL of the server"
}

output "asg_name" {
  description = "The name of the ASG"
  value       = aws_autoscaling_group.web.name
}

output "alb_security_group_id" {
  description = "The ID of the ALB security group"
  value       = aws_security_group.lb.id
}
