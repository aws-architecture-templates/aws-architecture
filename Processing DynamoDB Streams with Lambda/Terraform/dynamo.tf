resource "aws_dynamodb_table" "dynamodb_table" {
  name             = var.dynamo_table_name
  billing_mode     = "PAY_PER_REQUEST"
  stream_enabled   = true
  stream_view_type = "NEW_AND_OLD_IMAGES"
  hash_key         = "ItemId"

  attribute {
    name = "ItemId"
    type = "S"
  }
}