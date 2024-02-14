import json
import boto3
from boto3.dynamodb.conditions import Key
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
        table_name = 'item'

        # Get a reference to the DynamoDB table
        table = dynamodb.Table(table_name)

        # Extract parameters from the event
        item_id = event.get('item_id')
        requester_id = event.get('requester_id')

        # Get the item to update using the item_id
        response = table.query(
            KeyConditionExpression=Key('item_id').eq(item_id))
        items = response.get('Items', [])

        if not items:
            return {
                'statusCode': 404,
                'body': json.dumps({'error': 'Item not found with the provided id'})
            }

        # Assuming there is only one item with the given id, retrieve it
        item_to_update = items[0]

        # Update the item attributes
        update_expression = "SET expired = :expired, requester_id = :requester_id, requested_at = :requested_at"
        expression_attribute_values = {
            ':expired': True,
            ':requester_id': requester_id,
            ':requested_at': datetime.utcnow().isoformat()
        }

        # Update the item in DynamoDB
        updated_item = table.update_item(
            Key={'item_id': item_id},
            UpdateExpression=update_expression,
            ExpressionAttributeValues=expression_attribute_values,
            ReturnValues='ALL_NEW'  # This option returns all the attributes of the updated item
        ).get('Attributes', {})

        # Serialize the response with the custom encoder
        serialized_response = json.dumps({'message': 'Item requested successfully', 'contact_number': updated_item.get(
            'contact_number')}, default=default_encoder)

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
