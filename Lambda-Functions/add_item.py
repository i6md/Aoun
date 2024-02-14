import json
import boto3
from decimal import Decimal
from datetime import datetime
import uuid


def format_value(obj):
    if isinstance(obj, Decimal):
        return str(obj)  # Convert Decimal to string
    if isinstance(obj, datetime):
        return obj.isoformat()
    raise TypeError("Type not serializable")


def lambda_handler(event, context):
    try:
        event = json.loads(event["body"])
        # Create a DynamoDB client
        dynamodb = boto3.resource('dynamodb')

        # Specify the DynamoDB table name
        table_name = 'item'

        # Get a reference to the DynamoDB table
        table = dynamodb.Table(table_name)

        # Extract attributes from the event

        # item_id = int(event.get('item_id'))

        # # Check if an item with the same ID already exists
        # existing_item = table.get_item(Key={'item_id': item_id}).get('Item')
        # if existing_item:
        #     raise ValueError(f"Item with ID {item_id} already exists")

        desired_length = 10
        generated_id = str(uuid.uuid4())[:desired_length]

        created_at = datetime.utcnow()  # Set created_at to the current datetime
        owner_id = event.get('owner_id')
        contact_number = event.get('contact_number')
        title = event.get('title')
        description = event.get('description')

        # Create a new item with the specified attributes
        new_item = {
            'item_id': generated_id,
            'created_at': format_value(created_at),
            'owner_id': owner_id,
            'contact_number': contact_number,
            'title': title,
            'description': description,
            'expired': False,
            'requester_id': '',
            'requested_at': ''
        }

        # Put the new item into DynamoDB
        table.put_item(Item=new_item)

        return {
            'statusCode': 200,
            'body': json.dumps({'message': 'Item created successfully', 'item': new_item}, default=format_value)
        }

    except Exception as e:
        # Log the exception or print it for debugging
        print(f"Error: {str(e)}")
        return {
            'statusCode': 500,
            'body': json.dumps({'error': str(e)})
        }
