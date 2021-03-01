import boto3
import json
from decimal import Decimal

def lambda_handler(event, context):
    client = boto3.resource('dynamodb')
    table = client.Table('Datastore')

    input = json.loads(event["body"], parse_float=Decimal)
    table.put_item(Item=input)

    response = {
        'statusCode': 200,
        'headers': {'Content-Type': 'application/json'},
        'body': json.dumps({
            'message': 'Execution successfully!'})  
    }

    return response

