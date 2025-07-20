resource "aws_ecs_cluster" "fintech_cluster" {
  name = var.cluster_name
}

resource "aws_ecs_task_definition" "fintech_api" {
  family                   = "fintech-api"
  requires_compatibilities = ["FARGATE"]
  network_mode            = "awsvpc"
  cpu                     = "256"
  memory                  = "512"

  container_definitions = jsonencode([
    {
      name      = "fintech-api"
      image     = var.container_image
      essential = true
      portMappings = [
        {
          containerPort = 80
          hostPort      = 80
          protocol      = "tcp"
        }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = aws_cloudwatch_log_group.fintech_api_logs.name
          "awslogs-region"       = var.region
          "awslogs-stream-prefix" = "ecs"
        }
      }
    }
  ])
}

resource "aws_cloudwatch_log_group" "fintech_api_logs" {
  name              = "/ecs/fintech-api"
  retention_in_days = 30
}

resource "aws_ecs_service" "fintech_api_service" {
  name            = var.service_name
  cluster         = aws_ecs_cluster.fintech_cluster.id
  task_definition = aws_ecs_task_definition.fintech_api.arn
  desired_count   = var.desired_count
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = var.private_subnet_ids
    security_groups  = [aws_security_group.ecs_security_group.id]
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.fintech_api_target_group.arn
    container_name   = "fintech-api"
    container_port   = 80
  }

  depends_on = [aws_lb_listener.fintech_api_listener]
}

resource "aws_autoscaling_policy" "fintech_api_scale_up" {
  name                   = "scale-up"
  adjustment_type        = "ChangeInCapacity"
  scaling_adjustment      = 1
  cooldown               = 60
  autoscaling_group_name = aws_autoscaling_group.fintech_api_asg.name
}

resource "aws_autoscaling_policy" "fintech_api_scale_down" {
  name                   = "scale-down"
  adjustment_type        = "ChangeInCapacity"
  scaling_adjustment      = -1
  cooldown               = 60
  autoscaling_group_name = aws_autoscaling_group.fintech_api_asg.name
}

resource "aws_cloudwatch_metric_alarm" "fintech_api_cpu_high" {
  alarm_name          = "fintech-api-cpu-high"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name        = "CPUUtilization"
  namespace          = "AWS/ECS"
  period             = 60
  statistic          = "Average"
  threshold          = 70

  dimensions = {
    ClusterName = aws_ecs_cluster.fintech_cluster.name
    ServiceName = aws_ecs_service.fintech_api_service.name
  }

  alarm_actions = [aws_autoscaling_policy.fintech_api_scale_up.arn]
}

resource "aws_cloudwatch_metric_alarm" "fintech_api_cpu_low" {
  alarm_name          = "fintech-api-cpu-low"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = 2
  metric_name        = "CPUUtilization"
  namespace          = "AWS/ECS"
  period             = 60
  statistic          = "Average"
  threshold          = 20

  dimensions = {
    ClusterName = aws_ecs_cluster.fintech_cluster.name
    ServiceName = aws_ecs_service.fintech_api_service.name
  }

  alarm_actions = [aws_autoscaling_policy.fintech_api_scale_down.arn]
}
