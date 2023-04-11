data "archive_file" "lambda_zip_file" {
  type        = "zip"
  source_file = "${path.module}/src/index.py"
  output_path = "files/lambda.zip"
}

resource "aws_lambda_function" "lambda_dynamodb_stream_handler" {
  function_name = var.function_name
  handler       = "index.handler"
  role          = aws_iam_role.iam_for_lambda.arn
  runtime       = "python3.8"

  filename         = data.archive_file.lambda_zip_file.output_path
  source_code_hash = data.archive_file.lambda_zip_file.output_base64sha256

  environment {
    variables = {
      BUCKET_NAME = local.bucket_name
    }
  }
}

resource "aws_lambda_event_source_mapping" "lambda_dynamodb" {
  event_source_arn  = aws_dynamodb_table.dynamodb_table.stream_arn
  function_name     = aws_lambda_function.lambda_dynamodb_stream_handler.arn
  starting_position = "LATEST"

  filter_criteria {
    filter {
      pattern = jsonencode({
        "eventName" : ["INSERT", "REMOVE"]
      })
    }
  }
}