import json
import boto3
from boto3.dynamodb.conditions import Key, Attr
from decimal import Decimal
from datetime import datetime


def format_value(obj):
    if isinstance(obj, Decimal):
        return str(obj)
    raise TypeError("Type not serializable")


def expire_events(table):
    # Get only non-expired events
    events = table.scan(
        FilterExpression=Attr('expired').eq(False)
    )['Items']

    for event in events:
        # Check if the end_date_time has passed
        end_date_time = datetime.strptime(
            event['end_date_time'], '%Y-%m-%dT%H:%M:%S')
        if end_date_time < datetime.now():
            # If the end_date_time has passed, set the expired attribute to True
            table.update_item(
                Key={'event_id': event['event_id']},
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
        event_id = event.get("event_id")
        owner_id = event.get("owner_id")

        if list_type not in ["all", "specific", "available", "by_owner"]:
            raise ValueError(
                "Incorrect list_type. Should be 'all', 'specific', 'available', or 'by_owner'.")

        dynamodb = boto3.resource('dynamodb')
        table_name = 'event'
        table = dynamodb.Table(table_name)
        picture_table = dynamodb.Table("event_picture")

        if list_type == "all":
            events = table.scan()['Items']

            if not events:
                return {
                    'statusCode': 404,
                    'body': json.dumps({'message': 'No events found.'})
                }

        elif list_type == "specific":
            if not event_id:
                raise ValueError("Missing event_id in event body.")
            events = table.query(
                KeyConditionExpression=Key('event_id').eq(event_id)
            )['Items']

            if not events:
                return {
                    'statusCode': 404,
                    'body': json.dumps({'message': 'Event not found with the provided id'})
                }

        elif list_type == "by_owner":
            if not owner_id:
                raise ValueError("Missing owner_id in event body.")
            events = table.scan(
                FilterExpression=Attr('owner_id').eq(owner_id)
            )['Items']

            if not events:
                return {
                    'statusCode': 404,
                    'body': json.dumps({'message': 'No events found for the provided owner id'})
                }

        else:  # "available"
            # Call the function to expire events before querying the available events
            expire_events(table)

            events = table.scan(
                FilterExpression=Attr('expired').eq(False)
            )['Items']

            if not events:
                return {
                    'statusCode': 404,
                    'body': json.dumps({'message': 'No available events found.'})
                }

        # fetch pictures' URLs and attach to events
        for event in events:
            event_pictures = picture_table.scan(
                FilterExpression=Attr('pic_id').begins_with(event['event_id'])
            )['Items']
            event['pictures'] = [pic['url'] for pic in event_pictures]

        return {
            'statusCode': 200,
            'body': json.dumps({'events': events}, default=format_value)
        }

    except Exception as e:
        print(f"Error: {str(e)}")
        return {
            'statusCode': 500,
            'body': json.dumps({'error': str(e)})
        }
