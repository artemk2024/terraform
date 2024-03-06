resource "aws_db_instance" "pg_only" {
  identifier                 = var.aws_rds_name
  allocated_storage          = 100
  db_name                    = var.aws_rds_database_name
  engine                     = "postgres"
  engine_version             = "16.1"
  instance_class             = "db.m5d.large"
  username                   = var.aws_rds_master_username
  password                   = var.aws_rds_master_password
  port                       = 5432
  multi_az                   = false
  storage_type               = "gp2"
  storage_encrypted          = false
  skip_final_snapshot        = true
  vpc_security_group_ids     = [aws_security_group.k8s-db-sg.id]
  db_subnet_group_name       = data.aws_db_subnet_group.subnet_db.id
  publicly_accessible        = true
}