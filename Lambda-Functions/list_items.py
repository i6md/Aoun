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

# def lambda_handler(event, context):
#     try:
#         if event["body"] is not None:
#             event = json.loads(event["body"])
#         else:
#             event = {}
#         # Create a DynamoDB client
#         dynamodb = boto3.resource('dynamodb')

#         # Specify the DynamoDB table name
#         table_name = 'item'

#         # Get a reference to the DynamoDB table
#         table = dynamodb.Table(table_name)

#         # Specify the filter expression to get items where "taken" is False
#         filter_expression = Key('expired').eq(False)

#         # Scan the table with the filter expression
#         response = table.scan(FilterExpression=filter_expression)

#         items = response.get('Items', [])

#         # Convert Decimal to float or string before serializing to JSON for each item
#         queried_item = [{key: float(value) if isinstance(
#             value, Decimal) else value for key, value in item.items()} for item in items]

#         # Return a message if the items list is empty
#         if not queried_item:
#             return {
#                 'statusCode': 204,
#                 'body': json.dumps({'message': 'No items found.'})
#             }

#         # You can return a response if needed
#         return {
#             'statusCode': 200,
#             'body': json.dumps({'message': 'Lambda function executed successfully!', 'item': queried_item})
#         }

#     except Exception as e:
#         # Log the exception or print it for debugging
#         print(f"Error: {str(e)}")
#         return {
#             'statusCode': 500,
#             'body': json.dumps({'error': str(e)})
#         }


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

        if list_type not in ["all", "specific", "available"]:
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
