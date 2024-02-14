import json
import boto3
from boto3.dynamodb.conditions import Key  # Import the Key module
from decimal import Decimal


def lambda_handler(event, context):
    try:
        if event["body"] is not None:
            event = json.loads(event["body"])
        else:
            event = {}
        # Create a DynamoDB client
        dynamodb = boto3.resource('dynamodb')

        # Specify the DynamoDB table name
        table_name = 'item'

        # Get a reference to the DynamoDB table
        table = dynamodb.Table(table_name)

        # Specify the filter expression to get items where "taken" is False
        filter_expression = Key('expired').eq(False)

        # Scan the table with the filter expression
        response = table.scan(FilterExpression=filter_expression)

        items = response.get('Items', [])

        # Convert Decimal to float or string before serializing to JSON for each item
        queried_item = [{key: float(value) if isinstance(
            value, Decimal) else value for key, value in item.items()} for item in items]

        # Return a message if the items list is empty
        if not queried_item:
            return {
                'statusCode': 204,
                'body': json.dumps({'message': 'No items found.'})
            }

        # You can return a response if needed
        return {
            'statusCode': 200,
            'body': json.dumps({'message': 'Lambda function executed successfully!', 'item': queried_item})
        }

    except Exception as e:
        # Log the exception or print it for debugging
        print(f"Error: {str(e)}")
        return {
            'statusCode': 500,
            'body': json.dumps({'error': str(e)})
        }
