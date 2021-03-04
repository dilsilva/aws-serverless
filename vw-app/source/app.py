import boto3
import json
import botocore
import logging
from decimal import Decimal

def lambda_handler(event, context):
    try:    
        client = boto3.resource('dynamodb')
        table = client.Table('Datastore')

        input = json.loads(event["body"], parse_float=Decimal)
        table.put_item(Item=input)

        return {
            'statusCode': 200,
            'body': json.dumps({
                'message': 'Execution successfully!'})  
        }

    except botocore.exceptions.ClientError as error:
            raise error

