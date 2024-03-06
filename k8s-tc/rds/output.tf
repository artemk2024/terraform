output "rds_db_name" {
  value = aws_db_instance.pg_only.db_name
}

output "rds_db_address" {
  value = aws_db_instance.pg_only.address
}

output "rds_db_id" {
  value = aws_db_instance.pg_only.id
}

output "rds_db_security_group" {
  value = aws_db_instance.pg_only.security_group_names
}
output "rds_db_domain" {
  value = aws_db_instance.pg_only.domain
}