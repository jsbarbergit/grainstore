import boto3
import json
import unicodedata

TABLE='${grainstore_data_table_name}'
PARTITION_KEY='${grainstore_data_partition_key_name}'
SORT_KEY='${grainstore_data_sort_key_name}'
BODY_FIELDS=[
  "Account", 
  "AdmixPct", 
  "BushelKg", 
  "Crop", 
  "Direction", 
  "DryWeightTonnes", 
  "Image1", 
  "ImageKey", 
  "MoisturePct", 
  "SoftwareID", 
  "TicketID", 
  "Timestamp", 
  "UUID", 
  "VehicleReg", 
  "WetWeightTonnes"
]
DBCLIENT = boto3.client('dynamodb')

def remove_control_characters(s):
    return "".join(ch for ch in s if unicodedata.category(ch)[0]!="C")

def put_item(data):
  try:
    values = json.loads(data)
    response = DBCLIENT.put_item(
      TableName=TABLE,
      Item={
        PARTITION_KEY: { 'S': str(values[PARTITION_KEY]) },
        SORT_KEY: { 'S': str(values[SORT_KEY]) },    
        'AdmixPct': { 'S': str(values['AdmixPct']) },
        'BushelKg' : { 'S': str(values['BushelKg']) },
        'Crop': { 'S': str(values['Crop']) },
        'Direction': { 'S': str(values['Direction']) },
        'DryWeightTonnes': { 'S': str(values['DryWeightTonnes']) },
        'Image1': { 'S': str(values['Image1']) },
        'ImageBucket': { 'S': str(values['ImageBucket']) },
        'ImageKey': { 'S': str(values['ImageKey']) },
        'MoisturePct': { 'S': str(values['MoisturePct']) },
        'SoftwareID': { 'S': str(values['SoftwareID']) },
        'TicketID': { 'S': str(values['TicketID']) },
        'UUID': { 'S': str(values['UUID']) },
        'VehicleReg': { 'S': str(values['VehicleReg']) },
        'WetWeightTonnes': { 'S': str(values['WetWeightTonnes']) }
      },
      ReturnValues='NONE',
      ReturnConsumedCapacity='NONE',
      ReturnItemCollectionMetrics='NONE'
    )
    print('dynamodb response -> ' + str())
    if response['ResponseMetadata']['HTTPStatusCode'] == 200:
      return True
    else:
      return False
  except Exception as e:
    print('DB Write Op Exception -> ' + str(e))
    return False

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
    "body": msg
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
  for field in BODY_FIELDS:
    if bodyjson[field] is None:
      return return_failure("Invalid Request: Missing Value for " + field, 500)
  
 
  result = put_item(body)
  if not result:
    return return_failure('ERROR - failed to write data to table', 500)
  return return_success('Write Success')
