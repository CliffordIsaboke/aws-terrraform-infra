variable "security_group_rules" {
  description = "List of security group rules for the application."
  type        = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks  = list(string)
  }))
}

variable "ecs_task_role_name" {
  description = "The name of the IAM role for ECS tasks."
  type        = string
}

variable "lambda_execution_role_name" {
  description = "The name of the IAM role for Lambda execution."
  type        = string
}

variable "waf_web_acl_name" {
  description = "The name of the WAF Web ACL."
  type        = string
}

variable "rds_security_group_name" {
  description = "The name of the security group for RDS."
  type        = string
}

variable "redis_security_group_name" {
  description = "The name of the security group for Redis."
  type        = string
}
