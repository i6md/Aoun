import json
import boto3
import base64
import io
from boto3.dynamodb.conditions import Key, Attr
from decimal import Decimal
from datetime import datetime
import uuid
import os


def format_value(obj):
    if isinstance(obj, Decimal):
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
        table_name = 'item'

        # Get a reference to the DynamoDB table
        table = dynamodb.Table(table_name)

        # Get item details
        item_id = event.get('item_id')
        owner_id = event.get('owner_id')
        title = event.get('title')
        description = event.get('description')

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

        # Find old pics in the DB
        pic_table = dynamodb.Table("picture")
        old_pics = pic_table.scan(
            FilterExpression=boto3.dynamodb.conditions.Attr(
                'item_id').eq(item_id)
        )['Items']

        s3_client = boto3.client('s3')

        # Delete old pics from the S3 Bucket and DB
        for old_pic in old_pics:
            s3_client.delete_object(
                Bucket="aoun-item-pictures", Key=old_pic['pic_id'] + '.' + old_pic['url'].rsplit('.', 1)[-1])
            pic_table.delete_item(
                Key={'pic_id': old_pic['pic_id']})

        # Upload and add the new Pictures
        pictures = [event.get(f"picture_{i+1}")
                    for i in range(4) if event.get(f"picture_{i+1}")]
        for pic_number, pic_data in enumerate(pictures, start=1):
            pic_id = f"{item_id}_{pic_number}"
            pic_file = base64.b64decode(pic_data["content"])
            file_obj = io.BytesIO(pic_file)
            filename = f"{pic_id}.{pic_data['extension']}"

            s3_client.upload_fileobj(file_obj, "aoun-item-pictures", filename)

            pic_url = f"https://aoun-item-pictures.s3.eu-north-1.amazonaws.com/{filename}"
            pic_table.put_item(
                Item={"pic_id": pic_id, "item_id": item_id, "url": pic_url})

        response = table.update_item(
            Key={"item_id": item_id},
            UpdateExpression="set owner_id = :o, title = :t, description = :d",
            ExpressionAttributeValues={
                ":o": owner_id, ":t": title, ":d": description},
            ReturnValues="ALL_NEW",
        )

        return {
            'statusCode': 200,
            'body': json.dumps({'message': 'Item updated successfully', 'item': response['Attributes']}, default=format_value)
        }

    except Exception as e:
        print(f"Error: {str(e)}")
        return {
            'statusCode': 500,
            'body': json.dumps({'error': str(e)})
        }
