#!/usr/bin/env python3

import boto3
import json
from rich import print


print("Loading function")

s3 = boto3.client("s3")
dynamodb = boto3.resource("dynamodb")
table = dynamodb.Table("client-cars")

# TODO: error handling

def lamdbda_handler(event, context):
    # TODO: DOCS
    # TODO: RICH
    print("Received event: " + json.dumps(event, indent=2))

    bucket = event["Records"][0]["s3"]["bucket"]["name"]
    key = event['Records'][0]['s3']['object']['key']
    response = s3.get_object(Bucket=bucket, Key=key)
    body = response['Body'].read().decode('utf-8')
    client_list = create_client_list(body)
    for client in client_list:
        put_client_data_to_dynamodb(client)


def create_client_list(body):
    # TODO: DOCS
    file_content = json.loads(body)
    client_list = [obj for i, obj in enumerate(file_content)]
    return client_list


def put_client_data_to_dynamodb(client):
    # TODO: DOCS
    table.put_item(Item=client)
    print('Successfully uploaded data for a client.')
