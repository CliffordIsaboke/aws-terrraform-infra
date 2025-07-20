resource "aws_security_group" "ecs_sg" {
  name        = "ecs_security_group"
  description = "Allow traffic from ECS tasks"
  vpc_id     = var.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "rds_sg" {
  name        = "rds_security_group"
  description = "Allow traffic from ECS tasks to RDS"
  vpc_id     = var.vpc_id

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    security_groups = [aws_security_group.ecs_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "redis_sg" {
  name        = "redis_security_group"
  description = "Allow traffic from ECS tasks to ElastiCache"
  vpc_id     = var.vpc_id

  ingress {
    from_port   = 6379
    to_port     = 6379
    protocol    = "tcp"
    security_groups = [aws_security_group.ecs_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_iam_role" "ecs_task_role" {
  name = "ecs_task_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action    = "sts:AssumeRole"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
        Effect    = "Allow"
        Sid       = ""
      },
    ]
  })
}

resource "aws_iam_role_policy" "ecs_task_policy" {
  name   = "ecs_task_policy"
  role   = aws_iam_role.ecs_task_role.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "logs:CreateLogStream",
          "logs:PutLogEvents",
          "rds:DescribeDBInstances",
          "elasticache:DescribeCacheClusters"
        ]
        Resource = "*"
      },
    ]
  })
}

resource "aws_wafv2_web_acl" "ecs_waf" {
  name        = "ecs_waf"
  description = "WAF for ECS ALB"
  scope       = "REGIONAL"

  default_action {
    allow {}
  }

  rules {
    name     = "RateLimitRule"
    priority = 1

    statement {
      rate_based_statement {
        limit              = 1000
        aggregate_key_type = "IP"
        scope_down_statement {
          byte_match_statement {
            search_string = "BadBot"
            field_to_match {
              uri_path {}
            }
            text_transformations {
              priority = 0
              type     = "NONE"
            }
            positional_constraint = "CONTAINS"
          }
        }
      }
    }

    action {
      block {}
    }

    visibility_config {
      sampled_requests_enabled = true
      cloud_watch_metrics_enabled = true
      metric_name              = "RateLimitRule"
    }
  }

  visibility_config {
    cloud_watch_metrics_enabled = true
    metric_name              = "ecs_waf"
    sampled_requests_enabled  = true
  }
}

resource "aws_config_configuration_recorder" "config_recorder" {
  name     = "config_recorder"
  role_arn = aws_iam_role.ecs_task_role.arn

  recording_group {
    all_supported = true
    include_global_resource_types = true
  }
}

resource "aws_config_delivery_channel" "config_channel" {
  name           = "config_channel"
  s3_bucket_name = var.s3_bucket_name
}

resource "aws_securityhub_account" "security_hub" {}

resource "aws_cloudtrail" "cloud_trail" {
  name                          = "cloud_trail"
  s3_bucket_name                = var.s3_bucket_name
  is_multi_region_trail         = true
  enable_log_file_validation     = true
  include_global_service_events  = true
}

resource "aws_kms_key" "kms_key" {
  description = "KMS key for encryption"
  key_usage   = "ENCRYPT_DECRYPT"
}

resource "aws_kms_alias" "kms_alias" {
  name          = "alias/my_kms_key"
  target_key_id = aws_kms_key.kms_key.id
}
