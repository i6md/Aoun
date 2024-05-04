import base64
import io
import json
import boto3
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
        email = user_data.get('email')
        name = user_data.get('name')
        phone_number = user_data.get('phone_number')
        building = event.get('building')
        room = event.get('room')

        pic_data = event.get("pic")
        s3_client = boto3.client("s3")
        pic_file = base64.b64decode(pic_data["content"])
        file_obj = io.BytesIO(pic_file)
        filename = f"{user_id}.{pic_data['extension']}"
        s3_client.upload_fileobj(file_obj, "aoun-user-pictures", filename)
        pic_url = f"https://aoun-user-pictures.s3.eu-north-1.amazonaws.com/{filename}"

        new_item = {
            'user_id': user_id,
            'email': email,
            'name': name,
            'phone_number': phone_number,
            'building': building,
            'room': room,
            'pic': pic_url
        }

        table.put_item(Item=new_item)

        return {
            'statusCode': 200,
            'body': json.dumps({'message': 'User created successfully', 'user': new_item})
        }

    except Exception as e:
        print(f"Error: {str(e)}")
        return {
            'statusCode': 500,
            'body': json.dumps({'error': str(e)})
        }
