terraform {
  required_version = ">= 1.0.0"

  backend "s3" {
    region         = "eu-west-1"
    bucket         = "tfstatebackend-state"
    key            = "terraform.tfstate"
    dynamodb_table = "tfstatebackend-state-lock"
    profile        = ""
    role_arn       = ""
    encrypt        = "true"
  }
}
