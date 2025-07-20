output "security_group_ids" {
  value = aws_security_group.ecs_security_group.id
}

output "rds_security_group_id" {
  value = aws_security_group.rds_security_group.id
}

output "redis_security_group_id" {
  value = aws_security_group.redis_security_group.id
}

output "ecs_task_role_arn" {
  value = aws_iam_role.ecs_task_role.arn
}

output "lambda_execution_role_arn" {
  value = aws_iam_role.lambda_execution_role.arn
}
