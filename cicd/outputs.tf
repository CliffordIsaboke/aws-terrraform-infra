output "s3_bucket_name" {
  value = aws_s3_bucket.terraform_state.bucket
}

output "codepipeline_arn" {
  value = aws_codepipeline.ci_cd_pipeline.arn
}
