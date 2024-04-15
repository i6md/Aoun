import json
import boto3
from boto3.dynamodb.conditions import Key, Attr


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
        table_name = 'item'

        # Get a reference to the DynamoDB table
        table = dynamodb.Table(table_name)

        # Get item details
        item_id = event.get('item_id')

        # Get the item to update using the item_id
        response = table.scan(
            FilterExpression=Key('item_id').eq(
                item_id) & Attr('expired').eq(False)
        )
        items = response.get('Items', [])

        if not items:
            return {
                'statusCode': 404,
                'body': json.dumps({'error': 'Item not found with the provided id or item is expired'})
            }

        # Update the item's expired attribute to True
        response = table.update_item(
            Key={"item_id": item_id},
            UpdateExpression="set expired = :e",
            ExpressionAttributeValues={":e": True},
            ReturnValues="ALL_NEW",
        )

        return {
            'statusCode': 200,
            'body': json.dumps({'message': 'Item deleted successfully', 'item': response['Attributes']})
        }

    except Exception as e:
        print(f"Error: {str(e)}")
        return {
            'statusCode': 500,
            'body': json.dumps({'error': str(e)})
        }
