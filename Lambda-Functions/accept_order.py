import json
import boto3
from boto3.dynamodb.conditions import Key, Attr
from decimal import Decimal
from datetime import datetime
from urllib.parse import unquote
import base64
import re


def parse_jwt(token):
    base64_url = token.split('.')[1]  # Get the payload part of the token
    base64_String = base64_url.replace('-', '+').replace('_', '/')
    json_payload = unquote(base64.b64decode(
        base64_String + "==").decode('utf-8'))
    return json.loads(json_payload)


def default_encoder(obj):
    if isinstance(obj, Decimal):
        return str(obj)  # Convert Decimal to string
    raise TypeError("Type not serializable")


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

        user_data = parse_jwt(id_token)

        owner_id = user_data.get('email')
        match = re.search('s(\d+)@', owner_id)
        if match:
            owner_id = match.group(1)
        else:
            owner_id = None
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

        # Fetch the owner_id of the item
        item_owner_id = items[0].get('owner_id')

        # Check if the owner_id from the JWT token matches the owner_id of the item
        if owner_id != item_owner_id:
            return {
                'statusCode': 403,
                'body': json.dumps({'error': 'You are not the owner of this item'})
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
            UpdateExpression='SET #status = :val1, #acc_at = :val2',
            ExpressionAttributeNames={
                '#status': 'status', '#acc_at': 'accepted_at'},
            ExpressionAttributeValues={':val1': 'accepted',
                                       ':val2': datetime.utcnow().isoformat()}
        )

        # Get all other orders for the same item
        other_orders = order_table.scan(
            FilterExpression=Attr('item_id').eq(
                item_id) & Attr('order_id').ne(order_id)
        )['Items']

        # Update all other orders to 'rejected'
        for order in other_orders:
            order_table.update_item(
                Key={'order_id': order['order_id']},
                UpdateExpression='SET #status = :val',
                ExpressionAttributeNames={'#status': 'status'},
                ExpressionAttributeValues={':val': 'rejected'}
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
