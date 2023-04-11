resource "aws_iam_role" "iam_for_lambda" {
  name = "iam_for_lambda"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "dynamodb_lambda_policy" {
  name   = "lambda-dynamodb-policy"
  role   = aws_iam_role.iam_for_lambda.id
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
        "Sid": "AllowLambdaFunctionToCreateLogs",
        "Action": [ 
            "logs:*" 
        ],
        "Effect": "Allow",
        "Resource": [ 
            "arn:aws:logs:*:*:*" 
        ]
    },
    {
        "Sid": "AllowLambdaFunctionInvocation",
        "Effect": "Allow",
        "Action": [
            "lambda:InvokeFunction"
        ],
        "Resource": [
            "${aws_dynamodb_table.dynamodb_table.arn}/stream/*"
        ]
    },
    {
        "Sid": "APIAccessForDynamoDBStreams",
        "Effect": "Allow",
        "Action": [
            "dynamodb:GetRecords",
            "dynamodb:GetShardIterator",
            "dynamodb:DescribeStream",
            "dynamodb:ListStreams"
        ],
        "Resource": "${aws_dynamodb_table.dynamodb_table.arn}/stream/*"
    },
    {
        "Sid": "S3BucketPermissions",
        "Effect": "Allow",
        "Action": [
            "s3:PutObject"
        ],
        "Resource": [
            "arn:aws:s3:::${var.bucket_name}/*"
        ]
    }
  ]
}
EOF
}