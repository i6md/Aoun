import datetime
import json
import boto3
from boto3.dynamodb.conditions import Key
from decimal import Decimal


def format_value(obj):
    if isinstance(obj, Decimal):
        return str(obj)
    if isinstance(obj, datetime.datetime):
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
        list_type = event.get("list_type")
        report_id = event.get("report_id")
        reported_by = event.get("reported_by")
        object_id = event.get("object_id")
        owner_id = event.get("owner_id")
        if list_type not in ["all", "specific", "by_user", "by_object", "by_owner"]:
            raise ValueError(
                "Incorrect list_type. Should be 'all', 'specific', 'by_user', 'by_object', or 'by_owner'.")
        dynamodb = boto3.resource('dynamodb')
        table_name = 'report'
        table = dynamodb.Table(table_name)
        if list_type == "all":
            reports = table.scan()['Items']
            if not reports:
                return {
                    'statusCode': 404,
                    'body': json.dumps({'message': 'No reports found.'})
                }
        elif list_type == "specific":
            if not report_id:
                raise ValueError("Missing report_id in event body.")
            reports = table.query(
                KeyConditionExpression=Key('report_id').eq(report_id)
            )['Items']
            if not reports:
                return {
                    'statusCode': 404,
                    'body': json.dumps({'message': 'Report not found with the provided id'})
                }
        elif list_type == "by_user":
            if not reported_by:
                raise ValueError("Missing reported_by in event body.")
            reports = table.scan(
                FilterExpression=Key('reported_by').eq(reported_by)
            )['Items']
            if not reports:
                return {
                    'statusCode': 404,
                    'body': json.dumps({'message': 'No reports found by the provided user.'})
                }
        elif list_type == "by_object":
            if not object_id:
                raise ValueError("Missing object_id in event body.")
            reports = table.scan(
                FilterExpression=Key('object_id').eq(object_id)
            )['Items']
            if not reports:
                return {
                    'statusCode': 404,
                    'body': json.dumps({'message': 'No reports found for the provided object.'})
                }
        else:  # "by_owner"
            if not owner_id:
                raise ValueError("Missing owner_id in event body.")
            reports = table.scan(
                FilterExpression=Key('owner_id').eq(owner_id)
            )['Items']
            if not reports:
                return {
                    'statusCode': 404,
                    'body': json.dumps({'message': 'No reports found for the provided owner.'})
                }
        return {
            'statusCode': 200,
            'body': json.dumps({'reports': reports}, default=format_value)
        }
    except Exception as e:
        print(f"Error: {str(e)}")
        return {
            'statusCode': 500,
            'body': json.dumps({'error': str(e)})
        }
