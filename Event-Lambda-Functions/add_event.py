import base64
import io
import json
import boto3
from decimal import Decimal
from datetime import datetime
import uuid


def format_value(obj):
    if isinstance(obj, Decimal):
        return str(obj)  # Convert Decimal to string
    if isinstance(obj, datetime):
        return obj.isoformat()
    raise TypeError("Type not serializable")


def lambda_handler(event, context):
    try:
        event = json.loads(event["body"])
        # Create a DynamoDB client
        dynamodb = boto3.resource('dynamodb')

        # Specify the DynamoDB table name
        table_name = 'event'

        # Get a reference to the DynamoDB table
        table = dynamodb.Table(table_name)

        # Extract attributes from the event

        # item_id = int(event.get('item_id'))

        # # Check if an item with the same ID already exists
        # existing_item = table.get_item(Key={'item_id': item_id}).get('Item')
        # if existing_item:
        #     raise ValueError(f"Item with ID {item_id} already exists")

        service_identifier = "e"
        desired_length = 10
        generated_id = f"{service_identifier}_{str(uuid.uuid4())[:desired_length]}"

        created_at = datetime.utcnow()  # Set created_at to the current datetime
        owner_id = event.get('owner_id')
        title = event.get('title')
        description = event.get('description')
        start_date_time = event.get('start_date_time')
        end_date_time = event.get('end_date_time')
        building = event.get('building')
        room = event.get('room')
        participants_number = event.get('participants_number')

        # Create a new item with the specified attributes
        new_item = {
            'event_id': generated_id,
            'created_at': format_value(created_at),
            'owner_id': owner_id,
            'title': title,
            'description': description,
            'start_date_time': start_date_time,
            'end_date_time': end_date_time,
            'building': building,
            'room': room,
            'participants_number': participants_number,
            'joined': 0,  # Set the 'joined' attribute to 0
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
                file_obj, "aoun-event-pictures", filename)  # Upload to S3
            # Generate URL
            pic_url = f"https://aoun-event-pictures.s3.eu-north-1.amazonaws.com/{filename}"
            # Add picture information to DynamoDB
            dynamodb.Table("event_picture").put_item(Item={
                "pic_id": pic_id,
                "item_id": generated_id,
                "url": pic_url
            })
            pic_number += 1

        # Put the new item into DynamoDB
        table.put_item(Item=new_item)

        return {
            'statusCode': 200,
            'body': json.dumps({'message': 'event created successfully', 'event': new_item}, default=format_value)
        }

    except Exception as e:
        # Log the exception or print it for debugging
        print(f"Error: {str(e)}")
        return {
            'statusCode': 500,
            'body': json.dumps({'error': str(e)})
        }
