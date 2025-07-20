module "networking" {
  source = "./networking"
  vpc_cidr = var.vpc_cidr
  public_subnet_cidrs = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  availability_zones = var.availability_zones
}

module "compute" {
  source = "./compute"
  cluster_name = var.cluster_name
  service_name = var.service_name
  desired_task_count = var.desired_task_count
  vpc_id = module.networking.vpc_id
  public_subnet_ids = module.networking.public_subnet_ids
  private_subnet_ids = module.networking.private_subnet_ids
}

module "database" {
  source = "./database"
  db_instance_type = var.db_instance_type
  db_name = var.db_name
  db_username = var.db_username
  db_password = var.db_password
  dynamodb_table_name = var.dynamodb_table_name
  elasticache_node_type = var.elasticache_node_type
  vpc_id = module.networking.vpc_id
  subnet_group_ids = module.networking.elasticache_subnet_group_ids
}

module "security" {
  source = "./security"
  vpc_id = module.networking.vpc_id
  ecs_task_role_name = var.ecs_task_role_name
  lambda_execution_role_name = var.lambda_execution_role_name
}

module "cicd" {
  source = "./cicd"
  s3_bucket_name = var.s3_bucket_name
  github_repo = var.github_repo
}

module "monitoring" {
  source = "./monitoring"
  vpc_id = module.networking.vpc_id
}

