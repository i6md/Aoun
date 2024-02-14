import json
import boto3
from boto3.dynamodb.conditions import Key
from decimal import Decimal


class DecimalEncoder(json.JSONEncoder):
    def default(self, obj):
        if isinstance(obj, Decimal):
            return float(obj)
        return super(DecimalEncoder, self).default(obj)


def lambda_handler(event, context):
    try:
        event = json.loads(event["body"])
        # Create a DynamoDB client
        dynamodb = boto3.resource('dynamodb')

        # Specify the DynamoDB table name
        table_name = 'item'

        # Get a reference to the DynamoDB table
        table = dynamodb.Table(table_name)

        # Scan the table to get all items
        response = table.scan()

        items = response.get('Items', [])

        if not items:
            # If no items found in the table, return max id as 0
            return {
                'statusCode': 200,
                'body': json.dumps({'message': 'No items found in the table', 'max_id': 0}, cls=DecimalEncoder)
            }

        # Get the maximum ID from all items
        max_id = max(item.get('item_id', 0) for item in items)

        # You can return a response if needed
        return {
            'statusCode': 200,
            'body': json.dumps({'message': 'Lambda function executed successfully!', 'max_id': max_id}, cls=DecimalEncoder)
        }

    except Exception as e:
        # Log the exception or print it for debugging
        print(f"Error: {str(e)}")
        return {
            'statusCode': 500,
            'body': json.dumps({'error': str(e)})
        }
