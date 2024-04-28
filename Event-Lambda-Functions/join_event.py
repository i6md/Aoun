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
        event_table_name = 'event'
        participant_table_name = 'participant'
        # Get a reference to the DynamoDB table
        event_table = dynamodb.Table(event_table_name)
        participant_table = dynamodb.Table(participant_table_name)
        # Extract parameters from the event
        event_id = event.get('event_id')
        client_id = event.get('client_id')
        # Get the event to check using the event_id
        response = event_table.get_item(Key={'event_id': event_id})
        event_item = response.get('Item', None)
        if not event_item or event_item['expired']:
            return {
                'statusCode': 404,
                'body': json.dumps({'error': 'Event not found with the provided id or event is expired'})
            }
        # Check if the event is full
        if Decimal(event_item['joined']) >= Decimal(event_item['participants_number']):
            return {
                'statusCode': 400,
                'body': json.dumps({'error': 'Event is full'})
            }
        # Generate a unique order ID
        order_id = f"{event_id}_{client_id}"
        # Check if the order_id already exists in the participant_table
        response = participant_table.get_item(Key={'order_id': order_id})
        existing_order = response.get('Item', None)
        if existing_order:
            return {
                'statusCode': 400,
                'body': json.dumps({'error': 'Order already exists'})
            }
        # Get the current datetime
        current_datetime = datetime.utcnow().isoformat()
        # Create a new item in the participant_table
        participant_table.put_item(
            Item={
                'order_id': order_id,
                'event_id': event_id,
                'client_id': client_id,
                'ordered_at': current_datetime,
            }
        )
        # Increment the 'joined' attribute of the event
        event_table.update_item(
            Key={'event_id': event_id},
            UpdateExpression="set joined = joined + :inc",
            ExpressionAttributeValues={':inc': 1},
            ReturnValues="UPDATED_NEW",
        )
        # Serialize the response with the custom encoder
        serialized_response = json.dumps(
            {'message': 'Event joined successfully'}, default=default_encoder)
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
