module "client_data_bucket" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "3.14.0"

  bucket = "client-data-bucket2"

  force_destroy = true
  versioning = {
    enabled = false
  }

  server_side_encryption_configuration = {
    rule = {
      apply_server_side_encryption_by_default = {
        sse_algorithm = "AES256"
      }
    }
  }
}

resource "aws_transfer_server" "client_sftp_server" {
  tags                   = { name = "client_to_s3_sftp_server" }
  identity_provider_type = "SERVICE_MANAGED"
  endpoint_type          = "PUBLIC"
}

resource "aws_transfer_user" "client_sftp_user" {
  depends_on     = [module.client_data_bucket]
  server_id      = aws_transfer_server.client_sftp_server.id
  user_name      = "client"
  role           = aws_iam_role.client_data_s3_uploader.arn
  home_directory = "/client-data-bucket/"
  # TODO: policy
}

resource "aws_transfer_ssh_key" "client_key" {
  depends_on = [
    aws_transfer_user.client_sftp_user,
    aws_transfer_server.client_sftp_server
  ]
  server_id = aws_transfer_server.client_sftp_server.id
  user_name = "client"
  body      = file("${path.module}/client_key.pub")
}

################################

data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["transfer.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}


resource "aws_iam_role" "client_data_s3_uploader" {
  name               = "client-assume-transfer"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

data "aws_iam_policy_document" "client_data_s3_uploader" {
  statement {
    sid       = "AllowPutObjecttoClientDataS3"
    effect    = "Allow"
    actions   = ["s3:PutObject"]
    resources = ["${module.client_data_bucket.s3_bucket_arn}/*"]
  }
}

resource "aws_iam_role_policy" "client_data_s3_uploader" {
  name   = "client-data-s3-uploader"
  role   = aws_iam_role.client_data_s3_uploader.id
  policy = data.aws_iam_policy_document.client_data_s3_uploader.json
}
