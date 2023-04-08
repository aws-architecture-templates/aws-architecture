terraform {
  required_version = "1.4.4"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.61.0"
    }
  }
}
provider "aws" {
  region  = "us-east-1"
  profile = "tf04"
}
#criando s3 para armazenar os dados do firehouse
resource "aws_s3_bucket" "bucket" {
  bucket = "firehose-bucket-mercadobitcoin"
}
#criando policie para que o firehouse consiga acessar o S3
resource "aws_iam_policy" "firehose_policy" {
  name = "firehose_policy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:AbortMultipartUpload",
          "s3:GetBucketLocation",
          "s3:GetObject",
          "s3:ListBucket",
          "s3:ListBucketMultipartUploads",
          "s3:PutObject"
        ]
        Resource = [
          aws_s3_bucket.bucket.arn,
          "${aws_s3_bucket.bucket.arn}/*"
        ]
      }
    ]
  })
}
#criando uma role para que o firehouse consiga acessar esta policie
resource "aws_iam_role" "firehose_role" {
  name = "firehose_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "firehose.amazonaws.com"
        }
      }
    ]
  })

  # Anexe a política criada acima ao role IAM
  inline_policy {
    name   = aws_iam_policy.firehose_policy.name
    policy = aws_iam_policy.firehose_policy.policy
  }
}
#por fim criando o kinesis firehouse
resource "aws_kinesis_firehose_delivery_stream" "firehose" {
  name = "mercado-bitcoin-delivery-stream"

  destination = "s3"

  s3_configuration {
    role_arn          = aws_iam_role.firehose_role.arn
    bucket_arn        = aws_s3_bucket.bucket.arn
    prefix            = "firehose/"
    error_output_prefix = "firehose-errors/"
    compression_format = "UNCOMPRESSED"
  }
}

