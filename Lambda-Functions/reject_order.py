import json
import boto3
from boto3.dynamodb.conditions import Key, Attr
from decimal import Decimal
from datetime import datetime


def default_encoder(obj):
    if isinstance(obj, Decimal):
        return str(obj)  # Convert Decimal to string
    raise TypeError("Type not serializable")


def lambda_handler(event, context):
    try:
        event = json.loads(event["body"])
        # Create a DynamoDB client
        dynamodb = boto3.resource('dynamodb')

        # Specify the DynamoDB table name
        order_table_name = 'item_order'

        # Get a reference to the DynamoDB table
        order_table = dynamodb.Table(order_table_name)

        # Extract parameters from the event
        item_id = event.get('item_id')
        client_id = event.get('client_id')

        # Generate a unique order ID
        order_id = f"{item_id}_{client_id}"

        # Check if the order_id already exists in the order_table
        response = order_table.get_item(Key={'order_id': order_id})
        existing_order = response.get('Item', None)

        if not existing_order:
            return {
                'statusCode': 400,
                'body': json.dumps({'error': 'No order exists with the client ID'})
            }

        # Update the order table
        order_table.update_item(
            Key={'order_id': order_id},
            UpdateExpression='SET #status = :val1',
            ExpressionAttributeNames={'#status': 'status'},
            ExpressionAttributeValues={':val1': 'rejected'}
        )

        return {
            'statusCode': 200,
            'body': json.dumps({'message': 'order has been rejected successfully'}, default=default_encoder)
        }

    except Exception as e:
        return {
            'statusCode': 500,
            'body': json.dumps({'error': str(e)})
        }
