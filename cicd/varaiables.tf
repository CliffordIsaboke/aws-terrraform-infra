variable "s3_bucket_name" {
  description = "The name of the S3 bucket for Terraform state"
  type        = string
}

variable "github_repo" {
  description = "The GitHub repository for the source code"
  type        = string
}

variable "github_branch" {
  description = "The branch of the GitHub repository to use"
  type        = string
  default     = "main"
}

variable "codebuild_project_name" {
  description = "The name of the CodeBuild project"
  type        = string
}

variable "codepipeline_name" {
  description = "The name of the CodePipeline"
  type        = string
}
