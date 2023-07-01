# State

output "state_bucket_arn" {
  value       = module.terraform_state_backend.s3_bucket_arn
  description = "state_bucket_arn"
}

output "state_dynamodb_table_arn" {
  value       = module.terraform_state_backend.dynamodb_table_arn
  description = "state_dynamodb_table_arn"
}

output "terraform_backend_config" {
  value       = module.terraform_state_backend.terraform_backend_config
  description = "terraform_backend_config"
}


# S3 & Transfer

output "client_data_bucket_arn" {
  value       = module.client_data_bucket.s3_bucket_arn
  description = "client_data_bucket_arn"
}

output "transfer_endpoint" {
  value       = aws_transfer_server.client_sftp_server.endpoint
  description = "transfer_endpoint"
}

output "transfer_server_id" {
  value       = aws_transfer_server.client_sftp_server.id
  description = "transfer_server_id"
}

output "transfer_server_arn" {
  value       = aws_transfer_server.client_sftp_server.arn
  description = "transfer_server_arn"
}


# DynamoDB

output "client_cars_dynamodb_table_arn" {
  value       = module.client_cars_dynamodb_table.dynamodb_table_arn
  description = "client_cars_dynamodb_table_arn"
}


# Lambda

output "lambda_function_arn" {
  value       = module.lambda_s3_to_dynamodb.lambda_function_arn
  description = "lambda_function_arn"
}

output "lambda_function_url" {
  value       = module.lambda_s3_to_dynamodb.lambda_function_url
  description = "lambda_function_url"
}

output "lambda_role_arn" {
  value       = module.lambda_s3_to_dynamodb.lambda_role_arn
  description = "lambda_role_arn"
}

output "lambda_cloudwatch_log_group_arn" {
  value       = module.lambda_s3_to_dynamodb.lambda_cloudwatch_log_group_arn
  description = "lambda_cloudwatch_log_group_arn"
}


