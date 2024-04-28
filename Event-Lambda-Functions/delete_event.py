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
        table_name = 'event'

        # Get a reference to the DynamoDB table
        table = dynamodb.Table(table_name)

        # Get event details
        event_id = event.get('event_id')

        # Get the event to update using the event_id
        response = table.scan(
            FilterExpression=Key('event_id').eq(
                event_id) & Attr('expired').eq(False)
        )
        events = response.get('Items', [])

        if not events:
            return {
                'statusCode': 404,
                'body': json.dumps({'error': 'Event not found with the provided id or event is expired'})
            }

        # Update the event's expired attribute to True
        response = table.update_item(
            Key={"event_id": event_id},
            UpdateExpression="set expired = :e",
            ExpressionAttributeValues={":e": True},
            ReturnValues="ALL_NEW",
        )

        return {
            'statusCode': 200,
            'body': json.dumps({'message': 'Event deleted successfully', 'event': response['Attributes']})
        }

    except Exception as e:
        print(f"Error: {str(e)}")
        return {
            'statusCode': 500,
            'body': json.dumps({'error': str(e)})
        }
