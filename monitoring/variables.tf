variable "cloudwatch_log_group_name" {
  description = "The name of the CloudWatch log group for ECS service logs."
  type        = string
  default     = "ecs-service-logs"
}

variable "cloudwatch_log_retention_days" {
  description = "The number of days to retain CloudWatch logs."
  type        = number
  default     = 30
}

variable "sms_alert_lambda_function_name" {
  description = "The name of the Lambda function for SMS alerts."
  type        = string
  default     = "sms-alerts-function"
}

variable "eventbridge_schedule_expression" {
  description = "The schedule expression for EventBridge to trigger the Lambda function."
  type        = string
  default     = "rate(1 hour)"
}

variable "sns_topic_name" {
  description = "The name of the SNS topic for SMS alerts."
  type        = string
  default     = "sms-alerts-topic"
}
