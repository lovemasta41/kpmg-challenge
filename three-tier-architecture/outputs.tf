output "primary_rds_endpoint" {
  value = aws_db_instance.primary_instance.endpoint
}
