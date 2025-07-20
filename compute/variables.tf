variable "cluster_name" {
  description = "The name of the ECS cluster"
  type        = string
}

variable "service_name" {
  description = "The name of the ECS service"
  type        = string
}

variable "desired_task_count" {
  description = "The desired number of tasks for the ECS service"
  type        = number
  default     = 1
}

variable "cpu" {
  description = "The amount of CPU to allocate for the ECS task"
  type        = string
  default     = "256"
}

variable "memory" {
  description = "The amount of memory to allocate for the ECS task"
  type        = string
  default     = "512"
}

variable "container_port" {
  description = "The port on which the container listens"
  type        = number
  default     = 8080
}

variable "log_group_name" {
  description = "The name of the CloudWatch Logs group"
  type        = string
}

variable "environment" {
  description = "The environment for the ECS service (e.g., dev, prod)"
  type        = string
}
