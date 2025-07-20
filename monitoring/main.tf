resource "aws_cloudwatch_log_group" "ecs_log_group" {
  name              = "/ecs/fintech-api"
  retention_in_days = 30
}

resource "aws_cloudwatch_log_stream" "ecs_log_stream" {
  name           = "ecs-log-stream"
  log_group_name = aws_cloudwatch_log_group.ecs_log_group.name
}

resource "aws_cloudwatch_metric_alarm" "cpu_utilization_alarm" {
  alarm_name          = "cpu-utilization-alarm"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "1"
  metric_name        = "CPUUtilization"
  namespace          = "AWS/ECS"
  period             = "60"
  statistic          = "Average"
  threshold          = "80"
  alarm_description  = "This alarm triggers when CPU utilization exceeds 80%."
  dimensions = {
    ClusterName = aws_ecs_cluster.fintech_cluster.name
    ServiceName = aws_ecs_service.fintech_service.name
  }

  alarm_actions = [aws_sns_topic.alerts.arn]
}

resource "aws_sns_topic" "alerts" {
  name = "fintech-alerts"
}

resource "aws_cloudwatch_event_rule" "schedule" {
  name                = "sms-alert-schedule"
  schedule_expression = "rate(1 hour)"
}

resource "aws_cloudwatch_event_target" "sms_alert_target" {
  rule      = aws_cloudwatch_event_rule.schedule.name
  arn       = aws_lambda_function.sms_alert_function.arn
  input     = jsonencode({ "message" = "Transaction alert!" })
}

resource "aws_lambda_function" "sms_alert_function" {
  function_name = "sms_alert_function"
  handler       = "sms_alert.handler"
  runtime       = "python3.8"
  role          = aws_iam_role.lambda_execution_role.arn
  source_code_hash = filebase64sha256("path/to/your/lambda.zip")

  environment {
    SNS_TOPIC_ARN = aws_sns_topic.alerts.arn
  }
}

resource "aws_iam_role" "lambda_execution_role" {
  name = "lambda_execution_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action    = "sts:AssumeRole"
        Effect    = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_policy_attachment" "lambda_policy_attachment" {
  name       = "lambda_policy_attachment"
  roles      = [aws_iam_role.lambda_execution_role.name]
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}
