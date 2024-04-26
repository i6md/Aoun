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

        # Get the item to check using the item_id
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

        if existing_order:
            return {
                'statusCode': 400,
                'body': json.dumps({'error': 'Order already exists'})
            }

        # Get the current datetime
        current_datetime = datetime.utcnow().isoformat()

        # Create a new item in the order_table
        order_table.put_item(
            Item={
                'order_id': order_id,
                'item_id': item_id,
                'client_id': client_id,
                'ordered_at': current_datetime,
                'status': 'waiting',
                'accepted_at': ''
            }
        )

        # # Assuming there is only one item with the given id, retrieve it
        # item_to_update = items[0]

        # # Update the item attributes
        # update_expression = "SET expired = :expired, client_id = :client_id, ordered_at = :ordered_at"
        # expression_attribute_values = {
        #     ':expired': True,
        #     ':client_id': client_id,
        #     ':ordered_at': datetime.utcnow().isoformat()
        # }

        # # Update the item in DynamoDB
        # updated_item = table.update_item(
        #     Key={'item_id': item_id},
        #     UpdateExpression=update_expression,
        #     ExpressionAttributeValues=expression_attribute_values,
        #     ReturnValues='ALL_NEW'  # This option returns all the attributes of the updated item
        # ).get('Attributes', {})

        # Serialize the response with the custom encoder
        serialized_response = json.dumps(
            {'message': 'Item ordered successfully'}, default=default_encoder)

        return {
            'statusCode': 200,
            'body': serialized_response
        }

    except Exception as e:
        # Log the exception or print it for debugging
        print(f"Error: {str(e)}")
        return {
            'statusCode': 500,
            'body': json.dumps({'error': str(e)})
        }
