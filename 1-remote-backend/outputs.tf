output "backend" {
  description = "Copy/Paste this values into your terraform backend"
  value = {
    key            = "<key>/terraform.tfstate"
    region         = var.region
    encrypt        = "true"
    bucket         = aws_s3_bucket.bucket.id
    dynamodb_table = aws_dynamodb_table.table.id
  }
}

output "pipeline_role_arn" {
  description = "Use this role for github actions"
  value       = aws_iam_role.pipeline.arn
}