import boto3
from botocore.exceptions import ClientError
from botocore.client import Config
import json
import unicodedata
import time
from uuid import uuid4

REGION='${aws_region}'

# Need regional endpoints to be supplied in the generated url
S3CLIENT = boto3.client('s3', 
    region_name=REGION,
    endpoint_url=f'https://s3.{REGION}.amazonaws.com',
    config=Config(s3={'addressing_style': 'virtual'}))

def remove_control_characters(s):
    return "".join(ch for ch in s if unicodedata.category(ch)[0]!="C")

def generate_uuid():
  return str(uuid4())

def generate_url(bucket, key):
  fields = {}
  conditions = [
    {'acl': 'private'},
  ]
  try:
    response = S3CLIENT.generate_presigned_post(
      bucket,
      key,
      Fields=fields,
      Conditions=conditions,
      ExpiresIn=60)
  except ClientError as e:
      print('Exception: ' + str(e))
      return None
  return response

def return_success(response, uuid):
  print("Sending success event")
  # Add the UUID explicitly to make life easier for inserting dynamodb record
  response['uuid'] = uuid
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
    "body": msg
  }

def lambda_handler(event, context):
  print(json.dumps(event))
  bucket = "${bucket_name}"
  # event obj is a dict, but json body comes through as a string - convert to json if so
  body = event.get('body')
  if isinstance(body, str):
    # print('DEBUG - Got str body. Removing ctrl chars and converting to json')
    # Replace any conytrol chars
    body = remove_control_characters(body)
    bodyjson = json.loads(body)
  elif isinstance(body, dict):
    # print('DEBUG - Got dict body. Converting to json')
    bodyjson = json.dumps(body)
  else:
    return "Unknown event type"

  for field in ["Account"]:
    if bodyjson[field] is None:
      return return_failure("Invalid Request: Missing Value for " + field, 500)

  if "UUID" not in bodyjson:
    bodyjson["UUID"] = generate_uuid()
  if "ImageKey" not in bodyjson:
    bodyjson["ImageKey"] = bodyjson["Account"] + '/' + str(int(time.time())) + '/' + bodyjson["UUID"]
  
  response = generate_url(bucket, bodyjson["ImageKey"])
  
  if response != None:
    return return_success(response, bodyjson["UUID"])
  else:
    return return_failure('Failed to generate PreSigned URL', 500)