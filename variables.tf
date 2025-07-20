variable "region" {
  description = "The AWS region to deploy resources in."
  type        = string
  default     = "us-east-1"
}

variable "vpc_cidr" {
  description = "The CIDR block for the VPC."
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidrs" {
  description = "The CIDR blocks for the public subnets."
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
}

variable "private_subnet_cidrs" {
  description = "The CIDR blocks for the private subnets."
  type        = list(string)
  default     = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]
}

variable "availability_zones" {
  description = "The availability zones to deploy resources in."
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b", "us-east-1c"]
}

variable "db_instance_class" {
  description = "The instance class for the RDS database."
  type        = string
  default     = "db.t3.micro"
}

variable "db_name" {
  description = "The name of the database."
  type        = string
  default     = "fintechdb"
}

variable "db_username" {
  description = "The username for the database."
  type        = string
  default     = "fintechuser"
}

variable "db_password" {
  description = "The password for the database."
  type        = string
  sensitive   = true
}

variable "dynamodb_table_name" {
  description = "The name of the DynamoDB table."
  type        = string
  default     = "MobileTokenSessions"
}

variable "redis_node_type" {
  description = "The node type for ElastiCache Redis."
  type        = string
  default     = "cache.t3.micro"
}

variable "lambda_function_name" {
  description = "The name of the Lambda function for SMS alerts."
  type        = string
  default     = "smsAlertsFunction"
}

variable "s3_bucket_name" {
  description = "The name of the S3 bucket for Terraform state."
  type        = string
  default     = "terraform-state-bucket"
}

variable "github_repo" {
  description = "The GitHub repository for CI/CD."
  type        = string
  default     = "https://github.com/yourusername/yourrepo.git"
}

variable "environment" {
  description = "The environment for tagging resources."
  type        = string
  default     = "dev"
}

variable "owner" {
  description = "The owner of the resources."
  type        = string
  default     = "yourname"
}

variable "project" {
  description = "The project name for tagging resources."
  type        = string
  default     = "fintech-project"
}
