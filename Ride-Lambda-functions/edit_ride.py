import json
import boto3
from boto3.dynamodb.conditions import Key, Attr
from decimal import Decimal
from datetime import datetime
import uuid
import os


def format_value(obj):
    if isinstance(obj, Decimal):
        return str(obj)
    if isinstance(obj, datetime):
        return obj.isoformat()
    raise TypeError('Type not serializable')


def lambda_handler(event, context):
    try:
        if 'body' not in event or not event['body']:
            raise ValueError('Missing body in event')
        try:
            event = json.loads(event['body'])
        except json.JSONDecodeError:
            raise ValueError('Invalid JSON in body')

        # Create a DynamoDB client
        dynamodb = boto3.resource('dynamodb')

        # Specify the DynamoDB table name
        table_name = 'ride'

        # Get a reference to the DynamoDB table
        table = dynamodb.Table(table_name)

        # Get ride details
        ride_id = event.get('ride_id')
        owner_id = event.get('owner_id')
        title = event.get('title')
        description = event.get('description')
        start_location = event.get('start_location')
        end_location = event.get('end_location')
        start_date_time = event.get('start_date_time')
        available_seats = event.get('available_seats')

        # Get the ride to update using the ride_id
        response = table.scan(
            FilterExpression=Key('ride_id').eq(
                ride_id) & Attr('expired').eq(False)
        )
        rides = response.get('Items', [])

        if not rides:
            return {
                'statusCode': 404,
                'body': json.dumps({'error': 'Ride not found with the provided id or ride is expired'})
            }

        # Get the current ride
        current_ride = rides[0]

        # Check if the new available_seats is less than the current number of joined
        if 'joined' in current_ride and Decimal(available_seats) < Decimal(current_ride['joined']):
            return {
                'statusCode': 400,
                'body': json.dumps({'error': 'New available seats number cannot be less than the current number of joined'})
            }

        response = table.update_item(
            Key={"ride_id": ride_id},
            UpdateExpression="set owner_id = :o, title = :t, description = :d, start_location = :s, end_location = :e, start_date_time = :st, available_seats = :a",
            ExpressionAttributeValues={
                ":o": owner_id, ":t": title, ":d": description, ":s": start_location, ":e": end_location, ":st": start_date_time, ":a": available_seats},
            ReturnValues="ALL_NEW",
        )

        return {
            'statusCode': 200,
            'body': json.dumps({'message': 'Ride updated successfully', 'ride': response['Attributes']}, default=format_value)
        }

    except Exception as e:
        print(f"Error: {str(e)}")
        return {
            'statusCode': 500,
            'body': json.dumps({'error': str(e)})
        }
