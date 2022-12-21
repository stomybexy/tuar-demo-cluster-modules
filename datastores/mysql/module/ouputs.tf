output "db_address" {
  description = "The address of the RDS instance"
  value       = aws_db_instance.db.address
}

output "db_port" {
  description = "The port the RDS instance is listening on"
  value       = aws_db_instance.db.port
}

output "db_arn" {
  value = aws_db_instance.db.arn
  description = "The ARN of the RDS instance"
}