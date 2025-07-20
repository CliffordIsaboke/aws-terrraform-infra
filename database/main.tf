resource "aws_db_instance" "postgres" {
  identifier              = var.rds_instance_identifier
  engine                 = "postgres"
  engine_version         = "13.3"
  instance_class         = var.rds_instance_class
  allocated_storage       = var.rds_allocated_storage
  storage_type           = "gp2"
  multi_az               = true
  username               = var.rds_username
  password               = var.rds_password
  db_name                = var.rds_db_name
  backup_retention_period = 7
  iam_database_authentication_enabled = true
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  tags = {
    Name = "PostgresDB"
    Env  = var.environment
  }
}

resource "aws_dynamodb_table" "mobile_tokens" {
  name         = var.dynamodb_table_name
  billing_mode = "PAY_PER_REQUEST"

  attribute {
    name = "token_id"
    type = "S"
  }

  hash_key = "token_id"

  tags = {
    Name = "MobileTokens"
    Env  = var.environment
  }
}

resource "aws_elasticache_cluster" "redis" {
  cluster_id           = var.redis_cluster_id
  engine              = "redis"
  node_type           = var.redis_node_type
  number_cache_nodes  = var.redis_node_count
  parameter_group_name = "default.redis3.2"
  subnet_group_name    = aws_elasticache_subnet_group.redis_subnet_group.name
  tags = {
    Name = "RedisCache"
    Env  = var.environment
  }
}

resource "aws_elasticache_subnet_group" "redis_subnet_group" {
  name       = "${var.redis_cluster_id}-subnet-group"
  subnet_ids = var.private_subnet_ids

  tags = {
    Name = "RedisSubnetGroup"
    Env  = var.environment
  }
}
