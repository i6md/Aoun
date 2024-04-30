import json
import boto3
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
        ride_table_name = 'ride'
        passenger_table_name = 'passenger'
        # Get a reference to the DynamoDB table
        ride_table = dynamodb.Table(ride_table_name)
        passenger_table = dynamodb.Table(passenger_table_name)
        # Extract parameters from the event
        ride_id = event.get('ride_id')
        client_id = event.get('client_id')
        # Get the ride to check using the ride_id
        response = ride_table.get_item(Key={'ride_id': ride_id})
        ride_item = response.get('Item', None)
        if not ride_item or ride_item['expired']:
            return {
                'statusCode': 404,
                'body': json.dumps({'error': 'Ride not found with the provided id or ride is expired'})
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
        # Create a new item in the passenger_table
        passenger_table.put_item(
            Item={
                'order_id': order_id,
                'ride_id': ride_id,
                'client_id': client_id,
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
