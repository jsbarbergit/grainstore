import boto3
import json
import unicodedata
from botocore.client import Config

REGION='${aws_region}'
BUCKET="${bucket_name}"
PUBLICBUCKET = "${public_bucket_name}"
# Need regional endpoints to be supplied in the generated url
S3CLIENT = boto3.client('s3', 
    region_name=REGION,
    endpoint_url=f'https://s3.{REGION}.amazonaws.com',
    config=Config(s3={'addressing_style': 'virtual'}))
S3DOMAIN=".s3." + REGION + ".amazonaws.com"

def remove_control_characters(s):
    return "".join(ch for ch in s if unicodedata.category(ch)[0]!="C")

def publish_image(key, id, uuid, ip):
    # Cp image spec'd in key to public bucket in path -> img/id/uuid
    dest_key = 'img/' + id + '/' + uuid
    # Bucket config includes a 1day lifecycle rule to remove it
    # To do more timely clear up use s3 PutObject Event -> SNS -> SQS (with visibility timeout of xhrs) -> Lambda(delete object) 
    response = S3CLIENT.copy_object(
        ACL='public-read',
        Bucket=PUBLICBUCKET,
        CopySource={
          'Bucket': BUCKET, 
          'Key': key
        },
        Key=dest_key,
        ServerSideEncryption='AES256',
        StorageClass='ONEZONE_IA'
    )
    return 'https://' + PUBLICBUCKET + S3DOMAIN + "/" + dest_key

def return_success(response):
  print("Sending success event")
  return {
    "isBase64Encoded": False,
    "headers": {
      "Content-Type": "application/json"
    },
    "statusCode": 200,
    "body": json.dumps(response)
  }

def return_failure(msg, code):
  print("Sending failure event")
  return {
    "isBase64Encoded": False,
    "headers": {
      "Content-Type": "application/json"
    },
    "statusCode": code,
    "body": json.dumps(msg)
  }

def lambda_handler(event, context):
  print('DEBUG Event -> ' + json.dumps(event))
  # event obj is a dict, but json body comes through as a string - convert to json if so
  body = event.get('body')
  if isinstance(body, str):
    # print('DEBUG - Got str body. Removing ctrl chars and converting to json')
    # Replace any control chars
    body = remove_control_characters(body)
    bodyjson = json.loads(body)
  elif isinstance(body, dict):
    # print('DEBUG - Got dict body. Converting to json')
    bodyjson = json.dumps(body)
  else:
    return "Unknown event type"

  # Validate input
  for field in ["ImageKey", "UUID"]:
    if bodyjson[field] is None:
      return return_failure("Invalid Request: Missing Value for " + field, 500)
  
  request_id = event['requestContext']['requestId']
  source_ip = event['requestContext']['http']['sourceIp']
  print('requestid: ' + request_id + ' sourceip: ' + source_ip)
  result = publish_image(bodyjson['ImageKey'], request_id, bodyjson['UUID'], source_ip)
  if result != None:
    return return_success(result)
  return return_failure('Failed to copy image', 500)