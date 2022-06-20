resource "aws_kms_key" "db" {
  description             = "db"
  deletion_window_in_days = 10
}

resource "aws_kms_alias" "db" {
  name          = "alias/tf_db_key"
  target_key_id = aws_kms_key.db.key_id
}

resource "aws_db_subnet_group" "database" {
  name       = "my-test-database-subnet-group"
  subnet_ids = var.db_subnets
}

resource "aws_db_parameter_group" "database" {
  name   = "database"
  family = local.family
}

resource "aws_db_instance" "primary_db" {
  identifier = var.db_name
  db_name    = var.db_name
  port       = var.db_port

  engine                = local.engine
  engine_version        = local.engine_version
  instance_class        = local.instance_class
  allocated_storage     = 5
  max_allocated_storage = 10

  username = var.db_user
  password = var.db_pass

  db_subnet_group_name   = aws_db_subnet_group.database.id
  parameter_group_name   = aws_db_parameter_group.database.name
  vpc_security_group_ids = [aws_security_group.rds.id]

  # Backups are required in order to create a replica
  maintenance_window      = "Mon:00:00-Mon:03:00"
  backup_window           = "03:00-06:00"
  backup_retention_period = 5

  storage_encrypted               = true
  kms_key_id                      = aws_kms_key.db.arn
  performance_insights_enabled    = true
  performance_insights_kms_key_id = aws_kms_key.db.arn

  skip_final_snapshot = true
  apply_immediately   = true
}

resource "aws_db_instance" "read_replica" {
  count = length(var.db_subnets)

  identifier          = "${local.replica_name}-${count.index}"
  replicate_source_db = aws_db_instance.primary_db.identifier
  port                = var.db_port

  instance_class        = local.instance_class
  allocated_storage     = 5
  max_allocated_storage = 10

  vpc_security_group_ids = [aws_security_group.rds.id]

  # Read Replicas don't backup
  backup_retention_period = 0

  storage_encrypted               = true
  kms_key_id                      = aws_kms_key.db.arn
  performance_insights_enabled    = true
  performance_insights_kms_key_id = aws_kms_key.db.arn

  skip_final_snapshot = true
  apply_immediately   = true
}


