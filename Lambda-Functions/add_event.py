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
        table_name = 'event'

        # Get a reference to the DynamoDB table
        table = dynamodb.Table(table_name)

        # Extract attributes from the event

        # item_id = int(event.get('item_id'))

        # # Check if an item with the same ID already exists
        # existing_item = table.get_item(Key={'item_id': item_id}).get('Item')
        # if existing_item:
        #     raise ValueError(f"Item with ID {item_id} already exists")

        service_identifier = "e"
        desired_length = 10
        generated_id = f"{service_identifier}_{str(uuid.uuid4())[:desired_length]}"

        created_at = datetime.utcnow()  # Set created_at to the current datetime
        owner_id = event.get('owner_id')
        title = event.get('title')
        description = event.get('description')
        start_date_time = event.get('start_date_time')
        end_date_time = event.get('end_date_time')
        building = event.get('building')
        room = event.get('room')
        participant_number = event.get('participant_number')

        # Create a new item with the specified attributes
        new_item = {
            'item_id': generated_id,
            'created_at': format_value(created_at),
            'owner_id': owner_id,
            'title': title,
            'description': description,
            'start_date_time': start_date_time,
            'end_date_time': end_date_time,
            'building': building,
            'room': room,
            'participant_number': participant_number,
            'expired': False
        }

        # Put the new item into DynamoDB
        table.put_item(Item=new_item)

        return {
            'statusCode': 200,
            'body': json.dumps({'message': 'event created successfully', 'event': new_item}, default=format_value)
        }

    except Exception as e:
        # Log the exception or print it for debugging
        print(f"Error: {str(e)}")
        return {
            'statusCode': 500,
            'body': json.dumps({'error': str(e)})
        }
