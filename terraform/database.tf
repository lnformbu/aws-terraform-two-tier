# RDS MYSQL database
resource "aws_db_instance" "lenon-2-tier-db-1" {
  allocated_storage           = 5
  storage_type                = "gp2"
  engine                      = "mysql"
  engine_version              = "8.0"
  instance_class              = "db.t3.micro"
  db_subnet_group_name        = "lenon-2-tier-db-sub"
  vpc_security_group_ids      = [aws_security_group.lenon-2-tier-db-sg.id]
  parameter_group_name        = "default.mysql8.0"
  db_name                     = "two_tier_db1"
  username                    = "admin"
  password                    = "password"
  allow_major_version_upgrade = true
  auto_minor_version_upgrade  = true
  backup_retention_period     = 35
  backup_window               = "22:00-23:00"
  maintenance_window          = "Sat:00:00-Sat:03:00"
  multi_az                    = false
  skip_final_snapshot         = true

  depends_on = [aws_db_subnet_group.lenon-2-tier-db-sub] # ensure DB subnet group exists first
}