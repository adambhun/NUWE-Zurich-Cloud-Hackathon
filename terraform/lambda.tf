module "lambda_s3_to_dynamodb" {
  source        = "terraform-aws-modules/lambda/aws"
  version       = "5.0.0"
  runtime       = "python3.9"
  function_name = "s3-to-dynamodb"
  handler       = "s3_to_dynamodb.lamdbda_handler"
  source_path = [{
    path             = "../lambda",
    pip_requirements = true,

  }]
  create_package = true
  publish        = true

  /* role_path   = "/tf-managed/"
  policy_path = "/tf-managed/" */

  /* attach_dead_letter_policy = true
  dead_letter_target_arn    = aws_sqs_queue.dlq.arn */

  allowed_triggers = {
    AllowExcutionFromS3Bucket = {
      service    = "s3"
      source_arn = module.client_data_bucket.s3_bucket_arn
    }
  }

  attach_cloudwatch_logs_policy = true
  attach_policy_statements      = true
  policy_statements = {
    dynamodb = {
      effect    = "Allow",
      actions   = ["dynamodb:PutItem"],
      resources = [module.client_cars_dynamodb_table.dynamodb_table_arn]
    },
    s3_read = {
      effect    = "Allow",
      actions   = ["s3:HeadObject", "s3:GetObject"],
      resources = ["${module.client_data_bucket.s3_bucket_arn}/*"]
    }
  }
}

##################
# Adding S3 bucket as trigger to my lambda and giving the permissions
##################
resource "aws_s3_bucket_notification" "aws_lambda_trigger" {
  depends_on = [module.lambda_s3_to_dynamodb]
  bucket     = module.client_data_bucket.s3_bucket_id
  lambda_function {
    lambda_function_arn = module.lambda_s3_to_dynamodb.lambda_function_arn
    events              = ["s3:ObjectCreated:*"]
  }
}

# Provide permission to invoke lambda function when file is uploaded to S3 bucket
resource "aws_lambda_permission" "file_lambda_permission" {
  statement_id  = "AllowS3Invoke"
  action        = "lambda:InvokeFunction"
  function_name = module.lambda_s3_to_dynamodb.lambda_function_name
  principal     = "s3.amazonaws.com"
  source_arn    = module.client_data_bucket.s3_bucket_arn
}
