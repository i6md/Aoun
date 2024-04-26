import datetime
import json
import boto3
from boto3.dynamodb.conditions import Key  # Import the Key module
from decimal import Decimal


def format_value(obj):
    if isinstance(obj, Decimal):
        return str(obj)  # Convert Decimal to string
    if isinstance(obj, datetime):
        return obj.isoformat()  # Convert datetime to ISO 8601 string
    raise TypeError("Type not serializable")


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
        owner_id = event.get("owner_id")  # Get owner_id from event body

        if list_type not in ["all", "specific", "available", "by_owner"]:
            raise ValueError(
                "Incorrect list_type. Should be 'all', 'specific', or 'available'.")

        dynamodb = boto3.resource('dynamodb')

        table_name = 'item'
        table = dynamodb.Table(table_name)
        picture_table = dynamodb.Table("picture")

        if list_type == "all":
            items = table.scan()['Items']

            if not items:
                return {
                    'statusCode': 404,
                    'body': json.dumps({'message': 'No items found.'})
                }

        elif list_type == "specific":
            if not item_id:
                raise ValueError("Missing item_id in event body.")
            items = table.query(
                KeyConditionExpression=boto3.dynamodb.conditions.Key(
                    'item_id').eq(item_id)
            )['Items']

            if not items:
                return {
                    'statusCode': 404,
                    'body': json.dumps({'message': 'Item not found with the provided id'})
                }

        elif list_type == "by_owner":  # Add a new condition for "by_owner"
            if not owner_id:
                raise ValueError("Missing owner_id in event body.")
            items = table.scan(
                FilterExpression=boto3.dynamodb.conditions.Attr(
                    'owner_id').eq(owner_id)
            )['Items']

            if not items:
                return {
                    'statusCode': 404,
                    'body': json.dumps({'message': 'No items found for the provided owner id'})
                }

        else:  # "available"
            items = table.scan(
                FilterExpression=boto3.dynamodb.conditions.Attr(
                    'expired').eq(False)
            )['Items']

            if not items:
                return {
                    'statusCode': 404,
                    'body': json.dumps({'message': 'No available items found.'})
                }

        # fetch pictures' URLs and attach to items
        for item in items:
            item_pictures = picture_table.scan(
                FilterExpression=boto3.dynamodb.conditions.Attr(
                    'pic_id').begins_with(item['item_id'])
            )['Items']
            item['pictures'] = [pic['url'] for pic in item_pictures]

        return {
            'statusCode': 200,
            'body': json.dumps({'items': items}, default=format_value)
        }

    except Exception as e:
        print(f"Error: {str(e)}")
        return {
            'statusCode': 500,
            'body': json.dumps({'error': str(e)})
        }
