variable "rds_instance_type" {
  description = "The instance type for the RDS PostgreSQL database."
  type        = string
  default     = "db.t3.micro"
}

variable "rds_allocated_storage" {
  description = "The allocated storage for the RDS instance in GB."
  type        = number
  default     = 20
}

variable "rds_username" {
  description = "The username for the RDS database."
  type        = string
}

variable "rds_password" {
  description = "The password for the RDS database."
  type        = string
  sensitive   = true
}

variable "rds_db_name" {
  description = "The name of the RDS database."
  type        = string
}

variable "dynamodb_table_name" {
  description = "The name of the DynamoDB table for mobile token/session tracking."
  type        = string
  default     = "MobileTokenSessions"
}

variable "elasticache_node_type" {
  description = "The node type for the ElastiCache Redis cluster."
  type        = string
  default     = "cache.t3.micro"
}

variable "elasticache_replication_group_size" {
  description = "The number of nodes in the ElastiCache Redis replication group."
  type        = number
  default     = 2
}

variable "elasticache_subnet_group_name" {
  description = "The name of the ElastiCache subnet group."
  type        = string
}
