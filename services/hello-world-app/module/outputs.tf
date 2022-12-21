output "dns_name" {
  value       = module.alb.alb_dns_name
  description = "DNS name of the application load balancer"
}

output "security_group_id" {
  value       = module.asg.instance_security_group_id
  description = "Security group ID of the EC2 instances"
}

output "asg_name" {
  value       = module.asg.asg_name
  description = "Name of the autoscaling group"
}
