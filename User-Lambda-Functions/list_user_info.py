import boto3
import json


def lambda_handler(event, context):
    try:
        if "body" not in event or not event["body"]:
            raise ValueError("Missing body in event")
        try:
            # Make header keys case-insensitive
            headers = {k.lower(): v for k, v in event['headers'].items()}
            if 'authorization' in headers:
                id_token = headers['authorization'][7:]
                event = json.loads(event["body"])
            else:
                raise ValueError("Missing Authorization header")
        except json.JSONDecodeError:
            raise ValueError("Invalid JSON in body")

        user_id = event.get('user_id')
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
