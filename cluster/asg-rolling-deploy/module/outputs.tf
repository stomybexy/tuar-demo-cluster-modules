output "asg_name" {
  value       = aws_autoscaling_group.web.name
  description = "The name of the autoscaling group"
}

output "instance_security_group_id" {
  value       = aws_security_group.web.id
  description = "The ID of the EC2 instances security group"
}
