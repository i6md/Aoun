import boto3
import json
from urllib.parse import unquote
import base64
import re


def parse_jwt(token):
    base64_url = token.split('.')[1]  # Get the payload part of the token
    base64_String = base64_url.replace('-', '+').replace('_', '/')
    json_payload = unquote(base64.b64decode(
        base64_String + "==").decode('utf-8'))
    return json.loads(json_payload)


def lambda_handler(event, context):
    try:
        try:
            # Make header keys case-insensitive
            headers = {k.lower(): v for k, v in event['headers'].items()}
            if 'authorization' in headers:
                id_token = headers['authorization'][7:]
            else:
                raise ValueError("Missing Authorization header")
        except json.JSONDecodeError:
            raise ValueError("Invalid JSON in body")

        user_data = parse_jwt(id_token)

        user_id = user_data.get('email')
        match = re.search('s(\d+)@', user_id)
        if match:
            user_id = match.group(1)
        else:
            user_id = None
        dynamodb = boto3.resource('dynamodb')
        table_name = 'user'
        table = dynamodb.Table(table_name)

        response = table.get_item(Key={'user_id': user_id})

        if 'Item' in response:
            return {
                'statusCode': 200,
                'body': json.dumps({'message': 'User retrieved successfully', 'user': response['Item']})
            }
        else:
            return {
                'statusCode': 404,
                'body': json.dumps({'message': 'User not found'})
            }

    except Exception as e:
        print(f"Error: {str(e)}")
        return {
            'statusCode': 500,
            'body': json.dumps({'error': str(e)})
        }
