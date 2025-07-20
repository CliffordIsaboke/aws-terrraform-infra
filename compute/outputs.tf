output "ecs_service_name" {
  value = aws_ecs_service.fintech_api.name
}

output "public_alb_dns" {
  value = aws_lb.fintech_api_alb.dns_name
}
