import json
import traceback
import boto3
import datetime


def get_data(table_name, client):
    """    Get data from DynamoDB    """

    results = []
    last_evaluated_key = None
    while True:
        if last_evaluated_key:
            response = client.scan(TableName=table_name,
                                   ExclusiveStartKey=last_evaluated_key)
        else:
            response = client.scan(TableName=table_name)
        last_evaluated_key = response.get('LastEvaluatedKey')

        results.extend(response['Items'])

        if not last_evaluated_key:
            break
    return results


def lambda_handler(event, context):
    """    Export Dynamodb to s3 (JSON)    """

    statusCode = 200
    statusMessage = 'Success'


    # parse the payload

    tableName = event['tableName']
    s3_bucket = event['s3_bucket']
    s3_object = event['s3_object']
    filename = event['filename']

    # scan the dynamodb

    dynamodb = boto3.resource('dynamodb')
    table = dynamodb.Table(tableName)

    client = boto3.client('dynamodb')
    data = get_data(tableName, client)

    # export JSON to s3 bucket

    s3 = boto3.resource('s3')
    s3.Object(s3_bucket, s3_object+ filename+  datetime.datetime.now().strftime('%Y%m%d%H%M%S')).put(Body=json.dumps(data))

    return {'statusCode': statusCode, 'status': statusMessage}
