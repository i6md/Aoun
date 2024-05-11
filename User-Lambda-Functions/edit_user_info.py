import boto3
import json
import base64
import io
import re
from urllib.parse import unquote


def parse_jwt(token):
    base64_url = token.split('.')[1]  # Get the payload part of the token
    base64_String = base64_url.replace('-', '+').replace('_', '/')
    json_payload = unquote(base64.b64decode(
        base64_String + "==").decode('utf-8'))
    return json.loads(json_payload)


def lambda_handler(event, context):
    try:
        if "body" not in event or not event["body"]:
            raise ValueError("Missing body in event")
        try:
            headers = {k.lower(): v for k, v in event['headers'].items()}
            if 'authorization' in headers:
                id_token = headers['authorization'][7:]
                event = json.loads(event["body"])
            else:
                raise ValueError("Missing Authorization header")
        except json.JSONDecodeError:
            raise ValueError("Invalid JSON in body")

        user_data = parse_jwt(id_token)
        dynamodb = boto3.resource('dynamodb')
        table_name = 'user'
        table = dynamodb.Table(table_name)
        user_id = user_data.get('email')
        match = re.search('s(\d+)@', user_id)
        if match:
            user_id = match.group(1)
        else:
            user_id = None

        s3_client = boto3.client("s3")

        # Check if the user is already in the database
        response = table.get_item(Key={"user_id": user_id})
        if "Item" not in response:
            raise ValueError("User not found in the database")

        # Extract the old picture URL
        old_pic_url = response["Item"].get("pic")

        # Delete the old picture from the S3 bucket
        if old_pic_url:
            old_pic_key = old_pic_url.split('/')[-1]
            s3_client.delete_object(
                Bucket="aoun-user-pictures", Key=old_pic_key)

        building = event.get('building')
        room = event.get('room')
        pic_url = old_pic_url
        pic_data = event.get("pic")

        if pic_data:
            pic_file = base64.b64decode(pic_data["content"])
            file_obj = io.BytesIO(pic_file)
            filename = f"{user_id}.{pic_data['extension']}"
            s3_client.upload_fileobj(file_obj, "aoun-user-pictures", filename)
            pic_url = f"https://aoun-user-pictures.s3.eu-north-1.amazonaws.com/{filename}"

        response = table.update_item(
            Key={"user_id": user_id},
            UpdateExpression="set building = :b, room = :r, pic = :p",
            ExpressionAttributeValues={
                ":b": building, ":r": room, ":p": pic_url},
            ReturnValues="ALL_NEW",
        )

        return {
            'statusCode': 200,
            'body': json.dumps({'message': 'User updated successfully', 'user': response['Attributes']})
        }

    except Exception as e:
        print(f"Error: {str(e)}")
        return {
            'statusCode': 500,
            'body': json.dumps({'error': str(e)})
        }
