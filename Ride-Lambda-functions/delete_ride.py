from datetime import datetime
import decimal
import json
import boto3
from boto3.dynamodb.conditions import Key, Attr


def format_value(obj):
    if isinstance(obj, decimal.Decimal):
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

        # Get the ride to delete using the ride_id
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

        # Update the ride's expired attribute to True
        response = table.update_item(
            Key={"ride_id": ride_id},
            UpdateExpression="set expired = :e",
            ExpressionAttributeValues={":e": True},
            ReturnValues="ALL_NEW",
        )

        return {
            'statusCode': 200,
            'body': json.dumps({'message': 'Ride deleted successfully', 'ride': response['Attributes']}, default=format_value)
        }

    except Exception as e:
        print(f"Error: {str(e)}")
        return {
            'statusCode': 500,
            'body': json.dumps({'error': str(e)})
        }
