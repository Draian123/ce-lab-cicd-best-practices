output "s3_bucket_name" {
  description = "Artifacts S3 bucket name"
  value       = aws_s3_bucket.artifacts.id
}

output "s3_bucket_arn" {
  description = "Artifacts S3 bucket ARN"
  value       = aws_s3_bucket.artifacts.arn
}

output "dynamodb_table_name" {
  description = "Application state DynamoDB table name"
  value       = aws_dynamodb_table.app_state.name
}

output "dynamodb_table_arn" {
  description = "Application state DynamoDB table ARN"
  value       = aws_dynamodb_table.app_state.arn
}
