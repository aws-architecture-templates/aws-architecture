output "dynamodb_table_arn" {
  value       = aws_dynamodb_table.dynamodb_table.arn
}

output "lambda_processing_arn" {
  value       = aws_lambda_function.lambda_dynamodb_stream_handler.arn
  description = "The ARN of the Lambda function processing the DynamoDB stream"
}