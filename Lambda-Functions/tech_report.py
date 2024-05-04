import json
import boto3
from datetime import datetime
import uuid
from urllib.parse import unquote
import base64
import re


def parse_jwt(token):
    base64_url = token.split('.')[1]  # Get the payload part of the token
    base64_String = base64_url.replace('-', '+').replace('_', '/')
    json_payload = unquote(base64.b64decode(
        base64_String + "==").decode('utf-8'))
    return json.loads(json_payload)


def format_value(obj):
    if isinstance(obj, datetime):
        return obj.isoformat()
    raise TypeError("Type not serializable")


def lambda_handler(event, context):
    try:
        if "body" not in event or not event["body"]:
            raise ValueError("Missing body in event")
        try:
            # Make header keys case-insensitive
            headers = {k.lower(): v for k, v in event['headers'].items()}
            if 'authorization' in headers:
                id_token = headers['authorization'][7:]
                event = json.loads(event["body"])
            else:
                raise ValueError("Missing Authorization header")
        except json.JSONDecodeError:
            raise ValueError("Invalid JSON in body")

        user_data = parse_jwt(id_token)

        # Create a DynamoDB client
        dynamodb = boto3.resource('dynamodb')

        reported_by = user_data.get('email')
        match = re.search('s(\d+)@', reported_by)
        if match:
            reported_by = match.group(1)
        else:
            reported_by = None

        description = event.get('description')

        # Get a reference to the tech_report table
        tech_report_table = dynamodb.Table('tech_report')

        service_identifier = "#"
        desired_length = 10
        # Generate a unique report_id starting with "#"
        generated_id = f"{service_identifier}_{str(uuid.uuid4())[:desired_length]}"
        reported_at = datetime.utcnow()  # Set reported_at to the current datetime

        # Create a new tech report item with the specified attributes
        new_tech_report = {
            'report_id': generated_id,
            'reported_at': format_value(reported_at),
            'reported_by': reported_by,
            'description': description
        }

        # Put the new tech report into DynamoDB
        tech_report_table.put_item(Item=new_tech_report)

        return {
            'statusCode': 200,
            'body': json.dumps({'message': 'Tech report created successfully', 'tech_report': new_tech_report}, default=format_value)
        }

    except Exception as e:
        # Log the exception or print it for debugging
        print(f"Error: {str(e)}")
        return {
            'statusCode': 500,
            'body': json.dumps({'error': str(e)})
        }
