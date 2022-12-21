output "alb_dns_name" {
  value       = aws_lb.lb.dns_name
  description = "The DNS name of the load balancer"
}

output "alb_http_listener_arn" {
  value       = aws_lb_listener.lb.arn
  description = "The ARN of the HTTP listener"
}

output "alb_security_group_id" {
  value       = aws_security_group.lb.id
  description = "The security group ID of the load balancer"
}
