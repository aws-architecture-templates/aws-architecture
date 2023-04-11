# Processing DynamoDB Streams with Lambda

This code creates resources for processing DynamoDB streams using Lambda, including the creation of a DynamoDB table with stream enabled, an AWS Lambda function to handle the stream events, an IAM role and policy for the Lambda function, and an S3 bucket to store artifacts. The code also sets up the necessary permissions for the Lambda function to access the DynamoDB stream and write to CloudWatch Logs, and filters the events to only include inserts and removals.

# AWS Resources Created
This Terraform configuration file creates the following resources in your AWS account:

**aws_dynamodb_table**: This creates a DynamoDB table with name UsersIds and a primary key attribute UserId. The table has PAY_PER_REQUEST billing mode and stream enabled with NEW_AND_OLD_IMAGES view type.

**data_archive_file**: This zips the Python code in index.py file and creates an archive in the files folder.

**aws_lambda_function**: This creates a Lambda function with the name my-function and Python 3.8 runtime environment. The function uses the index.handler method as the entry point. The function is associated with the IAM role iam_for_lambda, which allows it to access the DynamoDB stream.

**aws_lambda_event_source_mapping**: This creates an event source mapping between the DynamoDB table and the Lambda function. The filter criteria ensure that the Lambda function only processes stream events of INSERT and REMOVE operations.

**aws_iam_role**: This creates an IAM role with the name iam_for_lambda and allows AWS Lambda service to assume the role.

**aws_iam_role_policy**: This creates an IAM policy attached to the iam_for_lambda role. This policy provides permissions for the Lambda function to access DynamoDB streams and write logs in CloudWatch.

**aws_s3_bucket**: This creates an S3 bucket with the name s3-files-dynamo-stream.

**aws_cloudwatch_log_group**: This creates a CloudWatch log group with the name /aws/lambda/my-function.

**aws_iam_policy**: This creates an IAM policy for the Lambda function to write logs in CloudWatch.

# Prerequisites

Before using this Terraform configuration file, ensure that you have:

* An AWS account and an IAM user with appropriate permissions to create the resources listed above.
* AWS CLI and Terraform installed on your local machine.

# How to Use

* Clone the repository to your local machine.
* Set the AWS access key and secret key as environment variables: AWS_ACCESS_KEY_ID and AWS_SECRET_ACCESS_KEY.
* Navigate to the cloned directory and run terraform init.
* Run terraform apply to create the resources listed above.
* After the resources have been created, you will see the ARNs of the DynamoDB table and Lambda function in the console output.
* To destroy the resources, run terraform destroy.
* Please note that destroying the resources will also delete all data stored in the DynamoDB table.