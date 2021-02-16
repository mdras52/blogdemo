resource "aws_rds_cluster" "blog_db" {
  cluster_identifier      = "blog2"
  engine                  = "aurora-mysql"
  engine_version          = "5.7.mysql_aurora.2.07.1"
  database_name           = "blogdb"
  master_username         = var.rds_master_username
  master_password         = var.rds_master_password
  engine_mode             = "serverless"
  vpc_security_group_ids  = [aws_security_group.blog_db_sec_group.id]
  db_subnet_group_name    = aws_db_subnet_group.blog_db_subnet_group.name
  skip_final_snapshot     = true
  backup_retention_period = 1
  apply_immediately       = true

  scaling_configuration {
    auto_pause               = true
    min_capacity             = 2 # this is set to have enough connections for ghost to install
    seconds_until_auto_pause = 300
    timeout_action           = "ForceApplyCapacityChange"
  }
}
