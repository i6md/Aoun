import json
import boto3
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
        # Create a DynamoDB client
        dynamodb = boto3.resource('dynamodb')
        # Specify the DynamoDB table name
        ride_table_name = 'ride'
        passenger_table_name = 'passenger'
        # Get a reference to the DynamoDB table
        ride_table = dynamodb.Table(ride_table_name)
        passenger_table = dynamodb.Table(passenger_table_name)
        # Extract parameters from the event
        ride_id = event.get('ride_id')
        client_id = user_data.get('email')
        match = re.search('s(\d+)@', client_id)
        if match:
            client_id = match.group(1)
        else:
            client_id = None
        # Get the ride to check using the ride_id
        response = ride_table.get_item(Key={'ride_id': ride_id})
        ride_item = response.get('Item', None)
        if not ride_item or ride_item['expired']:
            return {
                'statusCode': 404,
                'body': json.dumps({'error': 'Ride not found with the provided id or ride is expired'})
            }

        # Check if the client is the owner of the ride
        if ride_item['owner_id'] == client_id:
            return {
                'statusCode': 400,
                'body': json.dumps({'error': 'Owner cannot join their own ride'})
            }

        # Check if the ride is full
        if Decimal(ride_item['joined']) >= Decimal(ride_item['available_seats']):
            return {
                'statusCode': 400,
                'body': json.dumps({'error': 'Ride is full'})
            }
        # Generate a unique order ID
        order_id = f"{ride_id}_{client_id}"
        # Check if the order_id already exists in the passenger_table
        response = passenger_table.get_item(Key={'order_id': order_id})
        existing_order = response.get('Item', None)
        if existing_order:
            return {
                'statusCode': 400,
                'body': json.dumps({'error': 'Order already exists'})
            }
        # Get the current datetime
        current_datetime = datetime.utcnow().isoformat()

        # Extract the client's name and phone number
        client_name = user_data.get('name')
        client_phone_number = user_data.get('phone_number')

        # Create a new item in the passenger_table
        passenger_table.put_item(
            Item={
                'order_id': order_id,
                'ride_id': ride_id,
                'client_id': client_id,
                'client_name': client_name,
                'client_phone_number': client_phone_number,
                'ordered_at': current_datetime,
            }
        )
        # Increment the 'joined' attribute of the ride
        ride_table.update_item(
            Key={'ride_id': ride_id},
            UpdateExpression="set joined = joined + :inc",
            ExpressionAttributeValues={':inc': 1},
            ReturnValues="UPDATED_NEW",
        )
        # Serialize the response with the custom encoder
        serialized_response = json.dumps(
            {'message': 'Ride joined successfully'}, default=default_encoder)
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
