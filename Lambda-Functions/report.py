import json
import boto3
from datetime import datetime
import uuid


def format_value(obj):
    if isinstance(obj, datetime):
        return obj.isoformat()
    raise TypeError("Type not serializable")


def lambda_handler(event, context):
    try:
        if "body" not in event or not event["body"]:
            raise ValueError("Missing body in event")
        try:
            event = json.loads(event["body"])
        except json.JSONDecodeError:
            raise ValueError("Invalid JSON in body")

        # Create a DynamoDB client
        dynamodb = boto3.resource('dynamodb')

        object_id = event.get('object_id')
        if not object_id:
            raise ValueError("Missing object_id in event body")

        reported_by = event.get('reported_by')
        if not reported_by:
            raise ValueError("Missing reported_by in event body")

        description = event.get('description')

        # Determine the table to query and the corresponding id name based on the first letter of object_id
        object_type = object_id[0]
        if object_type == 'i':
            table_name = 'item'
            id_name = 'item_id'
        elif object_type == 'e':
            table_name = 'event'
            id_name = 'event_id'
        elif object_type == 'r':
            table_name = 'ride'
            id_name = 'ride_id'
        else:
            raise ValueError("Invalid object_id")

        # Get a reference to the DynamoDB table
        table = dynamodb.Table(table_name)

        # Check if the object exists in the table
        response = table.get_item(Key={id_name: object_id})
        if 'Item' not in response:
            raise ValueError(
                f"{table_name.capitalize()} with id {object_id} does not exist")

        # Get the owner_id from the object
        owner_id = response['Item']['owner_id']

        # Get a reference to the report table
        report_table = dynamodb.Table('report')

        service_identifier = "#"
        desired_length = 10
        # Generate a unique report_id starting with "#"
        generated_id = f"{service_identifier}_{str(uuid.uuid4())[:desired_length]}"
        created_at = datetime.utcnow()  # Set created_at to the current datetime

        # Create a new report item with the specified attributes
        new_report = {
            'report_id': generated_id,
            'created_at': format_value(created_at),
            'object_id': object_id,
            'owner_id': owner_id,
            'reported_by': reported_by,
            'description': description
        }

        # Put the new report into DynamoDB
        report_table.put_item(Item=new_report)

        return {
            'statusCode': 200,
            'body': json.dumps({'message': 'Report created successfully', 'report': new_report}, default=format_value)
        }

    except Exception as e:
        # Log the exception or print it for debugging
        print(f"Error: {str(e)}")
        return {
            'statusCode': 500,
            'body': json.dumps({'error': str(e)})
        }
