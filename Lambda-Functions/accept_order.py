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
        item_table_name = 'item'
        order_table_name = 'item_order'

        # Get a reference to the DynamoDB table
        item_table = dynamodb.Table(item_table_name)
        order_table = dynamodb.Table(order_table_name)

        # Extract parameters from the event
        item_id = event.get('item_id')
        client_id = event.get('client_id')

        # Get the item to update using the item_id
        response = item_table.scan(
            FilterExpression=Key('item_id').eq(
                item_id) & Attr('expired').eq(False)
        )
        items = response.get('Items', [])

        if not items:
            return {
                'statusCode': 404,
                'body': json.dumps({'error': 'Item not found with the provided id or item is expired'})
            }

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

        # Get the current datetime
        # current_datetime = datetime.utcnow().isoformat()

        # Update the item table
        item_table.update_item(
            Key={'item_id': item_id},
            UpdateExpression='SET #exp = :val',
            ExpressionAttributeNames={'#exp': 'expired'},
            ExpressionAttributeValues={':val': True}
        )

        # Update the order table
        order_table.update_item(
            Key={'order_id': order_id},
            UpdateExpression='SET #acc = :val1, #acc_at = :val2',
            ExpressionAttributeNames={
                '#acc': 'accepted', '#acc_at': 'accepted_at'},
            ExpressionAttributeValues={':val1': True,
                                       ':val2': datetime.utcnow().isoformat()}
        )

        return {
            'statusCode': 200,
            'body': json.dumps({'message': 'order has been accepted successfully'}, default=default_encoder)
        }

    except Exception as e:
        return {
            'statusCode': 500,
            'body': json.dumps({'error': str(e)})
        }
