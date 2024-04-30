import json
import boto3
from boto3.dynamodb.conditions import Key, Attr
from decimal import Decimal
from datetime import datetime


def format_value(obj):
    if isinstance(obj, Decimal):
        return str(obj)
    raise TypeError("Type not serializable")


def expire_rides(table):
    # Get only non-expired rides
    rides = table.scan(
        FilterExpression=Attr('expired').eq(False)
    )['Items']

    for ride in rides:
        # Check if the start_date_time has passed
        start_date_time = datetime.strptime(
            ride['start_date_time'], '%Y-%m-%dT%H:%M:%S')
        if start_date_time < datetime.now():
            # If the start_date_time has passed, set the expired attribute to True
            table.update_item(
                Key={'ride_id': ride['ride_id']},
                UpdateExpression="set expired = :e",
                ExpressionAttributeValues={
                    ':e': True
                },
                ReturnValues="UPDATED_NEW"
            )


def lambda_handler(event, context):
    try:
        if "body" not in event or not event["body"]:
            raise ValueError("Missing body in event")
        try:
            event = json.loads(event["body"])
        except json.JSONDecodeError:
            raise ValueError("Invalid JSON in body")

        list_type = event.get("list_type")
        ride_id = event.get("ride_id")
        owner_id = event.get("owner_id")

        if list_type not in ["all", "specific", "available", "by_owner"]:
            raise ValueError(
                "Incorrect list_type. Should be 'all', 'specific', 'available', or 'by_owner'.")

        dynamodb = boto3.resource('dynamodb')
        table_name = 'ride'
        table = dynamodb.Table(table_name)

        if list_type == "all":
            rides = table.scan()['Items']

            if not rides:
                return {
                    'statusCode': 404,
                    'body': json.dumps({'message': 'No rides found.'})
                }

        elif list_type == "specific":
            if not ride_id:
                raise ValueError("Missing ride_id in event body.")
            rides = table.query(
                KeyConditionExpression=Key('ride_id').eq(ride_id)
            )['Items']

            if not rides:
                return {
                    'statusCode': 404,
                    'body': json.dumps({'message': 'Ride not found with the provided id'})
                }

        elif list_type == "by_owner":
            if not owner_id:
                raise ValueError("Missing owner_id in event body.")
            rides = table.scan(
                FilterExpression=Attr('owner_id').eq(owner_id)
            )['Items']

            if not rides:
                return {
                    'statusCode': 404,
                    'body': json.dumps({'message': 'No rides found for the provided owner id'})
                }

        else:  # "available"
            # Call the function to expire rides before querying the available rides
            expire_rides(table)

            rides = table.scan(
                FilterExpression=Attr('expired').eq(False)
            )['Items']

            if not rides:
                return {
                    'statusCode': 404,
                    'body': json.dumps({'message': 'No available rides found.'})
                }

        return {
            'statusCode': 200,
            'body': json.dumps({'rides': rides}, default=format_value)
        }

    except Exception as e:
        print(f"Error: {str(e)}")
        return {
            'statusCode': 500,
            'body': json.dumps({'error': str(e)})
        }
