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
        # Create a DynamoDB client
        dynamodb = boto3.resource('dynamodb')

        # Get a reference to the tech_report table
        tech_report_table = dynamodb.Table('tech_report')

        # Scan the table to get all tech reports
        response = tech_report_table.scan()

        # Extract the tech reports from the response
        tech_reports = response['Items']

        return {
            'statusCode': 200,
            'body': json.dumps({'tech_reports': tech_reports}, default=format_value)
        }

    except Exception as e:
        # Log the exception or print it for debugging
        print(f"Error: {str(e)}")
        return {
            'statusCode': 500,
            'body': json.dumps({'error': str(e)})
        }
