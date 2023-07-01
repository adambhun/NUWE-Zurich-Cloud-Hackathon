module "client_cars_dynamodb_table" {
  source                         = "terraform-aws-modules/dynamodb-table/aws"
  version                        = "3.3.0"
  name                           = "client-cars"
  server_side_encryption_enabled = true
  hash_key                       = "id"
  attributes = [{
    name = "id"
    type = "S"
  }]
}
