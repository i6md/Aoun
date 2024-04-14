import datetime
import json
import boto3
from boto3.dynamodb.conditions import Key, Attr  # Import the Key module
from decimal import Decimal


def format_value(obj):
    if isinstance(obj, Decimal):
        return str(obj)  # Convert Decimal to string
    if isinstance(obj, datetime):
        return obj.isoformat()  # Convert datetime to ISO 8601 string
    raise TypeError("Type not serializable")

# body of the request: {"list_type": "all_orders" | "not_accepted" | "accepted" | "specific", "item_id": "item_id", "client_id": "client_id"}


def lambda_handler(event, context):
    try:
        if "body" not in event or not event["body"]:
            raise ValueError("Missing body in event")
        try:
            event = json.loads(event["body"])
        except json.JSONDecodeError:
            raise ValueError("Invalid JSON in body")

        list_type = event.get("list_type")
        item_id = event.get("item_id")

        if list_type not in ["all", "not_accepted", "accepted", "specific"]:
            raise ValueError(
                "Incorrect list_type. Should be 'all', 'not_accepted', 'accepted', or 'specific'.")

        if not item_id:
            raise ValueError("Missing item_id in event body.")

        dynamodb = boto3.resource('dynamodb')

        table_name = 'item_order'
        table = dynamodb.Table(table_name)

        if list_type == "all":
            orders = table.scan(
                FilterExpression=boto3.dynamodb.conditions.Attr(
                    'item_id').eq(item_id)
            )['Items']

            if not orders:
                return {
                    'statusCode': 404,
                    'body': json.dumps({'message': 'No orders found.'})
                }

        elif list_type == "not_accepted":
            orders = table.scan(
                FilterExpression=boto3.dynamodb.conditions.Attr(
                    'item_id').eq(item_id) & Attr('accepted').eq(False)
            )['Items']

            if not orders:
                return {
                    'statusCode': 404,
                    'body': json.dumps({'message': 'No non accepted orders found.'})
                }

        elif list_type == "accepted":
            orders = table.scan(
                FilterExpression=boto3.dynamodb.conditions.Attr(
                    'item_id').eq(item_id) & Attr('accepted').eq(True)
            )['Items']

            if not orders:
                return {
                    'statusCode': 404,
                    'body': json.dumps({'message': 'No accepted orders found.'})
                }

        else:  # "specific"
            orders = table.scan(
                FilterExpression=Attr('item_id').eq(item_id) & Attr(
                    'client_id').eq(event.get('client_id'))
            )['Items']

        return {
            'statusCode': 200,
            'body': json.dumps({'orders': orders}, default=format_value)
        }

    except Exception as e:
        print(f"Error: {str(e)}")
        return {
            'statusCode': 500,
            'body': json.dumps({'error': str(e)})
        }
