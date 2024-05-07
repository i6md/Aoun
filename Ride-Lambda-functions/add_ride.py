import json
import boto3
from decimal import Decimal
from datetime import datetime
import uuid
from urllib.parse import unquote
import base64
import re


def parse_jwt(token):
    base64_url = token.split('.')[1]  # Get the payload part of the token
    base64_String = base64_url.replace('-', '+').replace('_', '/')
    json_payload = unquote(base64.b64decode(
        base64_String + "==").decode('utf-8'))
    return json.loads(json_payload)


def format_value(obj):
    if isinstance(obj, Decimal):
        return str(obj)  # Convert Decimal to string
    if isinstance(obj, datetime):
        return obj.isoformat()
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
        owner_id = user_data.get('email')
        match = re.search('s(\d+)@', owner_id)
        if match:
            owner_id = match.group(1)
        else:
            owner_id = None
        title = event.get('title')
        description = event.get('description')
        category = event.get('category')
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
            'category': category,
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
