output "public_alb_dns" {
  value = module.compute.alb_dns
}

output "ecs_service_name" {
  value = module.compute.service_name
}

output "rds_endpoint" {
  value = module.database.rds_endpoint
}

output "redis_endpoint" {
  value = module.database.redis_endpoint
}
