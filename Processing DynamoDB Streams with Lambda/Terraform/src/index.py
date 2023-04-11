import boto3
import json
import os

s3_client = boto3.client('s3')

def handler(event, context):
    for record in event['Records']:
            if record['eventName'] == 'INSERT':
                payload = json.dumps(record['dynamodb']['NewImage'])
                bucket_name = os.environ['BUCKET_NAME'] # Substitua pelo nome do seu bucket S3
                object_key = record['dynamodb']['Keys']['UserId']['S'] + '.json'
                s3_client.put_object(Body=payload, Bucket=bucket_name, Key=object_key)

