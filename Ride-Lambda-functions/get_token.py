from urllib.parse import unquote
import json
import base64
import boto3

# Initialize Cognito client

# replace to your region

cognito = boto3.client('cognito-idp', region_name='eu-north-1')


def lambda_handler(event, context):
    event = json.loads(event["body"])

    # Extract username and password from the request body
    username = event.get('username')
    password = event.get('password')

    params = {
        'AuthFlow': 'USER_PASSWORD_AUTH',
        'ClientId': 'mc7k0ngag4ftstchvnocn162f',
        'AuthParameters': {
            'USERNAME': username,
            'PASSWORD': password
        }
    }

    try:
        response = cognito.initiate_auth(**params)
        print("Authentication successful")

        id_token = response['AuthenticationResult']['IdToken']
        user_data = parse_jwt(id_token)

        print("User data:", user_data)

        return {
            'statusCode': 200,
            'body': json.dumps({
                'userData': user_data,
                'idToken': id_token,  # Include the id token in the response
                'message': "Authentication successful"
            })
        }

    except Exception as error:
        print('Error authenticating:', error)

        return {
            'statusCode': 400,
            'body': json.dumps({
                'message': "Authentication failed",
                'error': str(error)
            })
        }


def parse_jwt(token):

    _, payload, _ = token.split('.')

    padded_payload = payload + '=' * (4 - len(payload) % 4)

    decoded_payload = base64.urlsafe_b64decode(padded_payload)

    return json.loads(decoded_payload)


# Usage example

# id_token = AuthenticationResult['IdToken']  # Your ID token here

# user_data = parse_jwt(id_token)

# print(user_data['name'])  # Or any other attribute, e.g., email, etc.
