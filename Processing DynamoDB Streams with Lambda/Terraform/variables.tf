variable "bucket_name" {
  type        = string
  default     = "s3-files-dynamo-stream"
}

variable "function_name" {
  type        = string
  default = "my-function-lambda"
}

variable "dynamo_table_name" {
  type        = string
  default = "table-dynamo"
}