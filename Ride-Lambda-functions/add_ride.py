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
        table_name = 'ride'

        # Get a reference to the DynamoDB table
        table = dynamodb.Table(table_name)

        service_identifier = "r"
        desired_length = 10
        generated_id = f"{service_identifier}_{str(uuid.uuid4())[:desired_length]}"

        created_at = datetime.utcnow()  # Set created_at to the current datetime
        owner_id = event.get('owner_id')
        title = event.get('title')
        description = event.get('description')
        start_location = event.get('start_location')
        end_location = event.get('end_location')
        start_date_time = event.get('start_date_time')
        available_seats = event.get('available_seats')

        # Create a new item with the specified attributes
        new_item = {
            'ride_id': generated_id,
            'created_at': format_value(created_at),
            'owner_id': owner_id,
            'title': title,
            'description': description,
            'start_location': start_location,
            'end_location': end_location,
            'start_date_time': start_date_time,
            'available_seats': available_seats,
            'joined': 0,  # Set the 'joined' attribute to 0
            'expired': False
        }

        # Put the new item into DynamoDB
        table.put_item(Item=new_item)

        return {
            'statusCode': 200,
            'body': json.dumps({'message': 'ride created successfully', 'ride': new_item}, default=format_value)
        }

    except Exception as e:
        # Log the exception or print it for debugging
        print(f"Error: {str(e)}")
        return {
            'statusCode': 500,
            'body': json.dumps({'error': str(e)})
        }
