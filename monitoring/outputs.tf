output "cloudwatch_log_group_name" {
  value = aws_cloudwatch_log_group.fintech_api_logs.name
}

output "cloudwatch_log_group_arn" {
  value = aws_cloudwatch_log_group.fintech_api_logs.arn
}

output "cloudwatch_log_stream_name" {
  value = aws_cloudwatch_log_stream.fintech_api_log_stream.name
}
