import json
import boto3
from decimal import Decimal
from datetime import datetime
import uuid
import base64
import io
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
    if isinstance(obj, Decimal):
        return str(obj)  # Convert Decimal to string
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

        # Specify the DynamoDB table name
        table_name = 'item'

        # Get a reference to the DynamoDB table
        table = dynamodb.Table(table_name)

        service_identifier = "i"
        desired_length = 10
        generated_id = f"{service_identifier}_{str(uuid.uuid4())[:desired_length]}"

        created_at = datetime.utcnow()  # Set created_at to the current datetime
        owner_id = user_data.get('email')
        match = re.search('s(\d+)@', owner_id)
        if match:
            owner_id = match.group(1)
        else:
            owner_id = None
        title = event.get('title')
        description = event.get('description')

        # Create a new item with the specified attributes
        new_item = {
            'item_id': generated_id,
            'created_at': format_value(created_at),
            'owner_id': owner_id,
            'title': title,
            'description': description,
            'item_type': "offer",
            'expired': False

        }

        pictures = [event.get(f"picture_{i+1}")
                    for i in range(4) if event.get(f"picture_{i+1}")]

        s3_client = boto3.client("s3")
        pic_number = 1
        for pic_data in pictures:
            pic_id = f"{generated_id}_{pic_number}"
            pic_file = base64.b64decode(pic_data["content"])
            file_obj = io.BytesIO(pic_file)

            # Include the extension in the filename
            filename = f"{pic_id}.{pic_data['extension']}"

            s3_client.upload_fileobj(
                file_obj, "aoun-item-pictures", filename)  # Upload to S3
            # Generate URL
            pic_url = f"https://aoun-item-pictures.s3.eu-north-1.amazonaws.com/{filename}"
            # Add picture information to DynamoDB
            dynamodb.Table("picture").put_item(Item={
                "pic_id": pic_id,
                "item_id": generated_id,
                "url": pic_url
            })
            pic_number += 1

        # Put the new item into DynamoDB
        table.put_item(Item=new_item)

        return {
            'statusCode': 200,
            'body': json.dumps({'message': 'Item created successfully', 'item': new_item}, default=format_value)
        }

    except Exception as e:
        # Log the exception or print it for debugging
        print(f"Error: {str(e)}")
        return {
            'statusCode': 500,
            'body': json.dumps({'error': str(e)})
        }
