resource "aws_cloudwatch_log_group" "my_log_group" {
  name = "/aws/lambda/${var.function_name}"
}