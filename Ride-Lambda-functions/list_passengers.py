import json
import boto3
from boto3.dynamodb.conditions import Key, Attr
from decimal import Decimal
from datetime import datetime


def format_value(obj):
    if isinstance(obj, Decimal):
        return str(obj)  # Convert Decimal to string
    if isinstance(obj, datetime):
        return obj.isoformat()  # Convert datetime to ISO 8601 string
    raise TypeError("Type not serializable")

# body of the request: {"list_type": "all" | "specific" | "by_client", "ride_id": "ride_id", "client_id": "client_id"}


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
        client_id = event.get("client_id")

        if list_type not in ["all", "specific", "by_client"]:
            raise ValueError(
                "Incorrect list_type. Should be 'all', 'specific', or 'by_client'.")

        if list_type != "by_client":
            if not ride_id:
                raise ValueError("Missing ride_id in event body.")

        dynamodb = boto3.resource('dynamodb')
        table_name = 'passenger'
        table = dynamodb.Table(table_name)

        if list_type == "all":
            passengers = table.scan(
                FilterExpression=Attr('ride_id').eq(ride_id)
            )['Items']
        elif list_type == "specific":
            passengers = table.scan(
                FilterExpression=Attr('ride_id').eq(
                    ride_id) & Attr('client_id').eq(client_id)
            )['Items']
        else:  # "by_client"
            passengers = table.scan(
                FilterExpression=Attr('client_id').eq(client_id)
            )['Items']

        if not passengers:
            return {
                'statusCode': 404,
                'body': json.dumps({'message': 'No passengers found.'})
            }

        return {
            'statusCode': 200,
            'body': json.dumps({'passengers': passengers}, default=format_value)
        }
    except Exception as e:
        print(f"Error: {str(e)}")
        return {
            'statusCode': 500,
            'body': json.dumps({'error': str(e)})
        }
