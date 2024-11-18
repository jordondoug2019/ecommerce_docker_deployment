output "rds_endpoint" {
  description = "The endpoint of the RDS database"
  value       = aws_db_instance.main.endpoint
}

output "db_password" {
  value = var.db_password
}
