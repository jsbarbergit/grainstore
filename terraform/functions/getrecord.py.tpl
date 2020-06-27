import boto3
import json
import unicodedata
from boto3.dynamodb.conditions import Key
from decimal import Decimal

# keep the db initialization outside of the functions to maintain them as long as the container lives
DBCLIENT = boto3.resource('dynamodb')
DBTABLE = DBCLIENT.Table('${grainstore_data_table_name}')

# Convert Dynamo's Decimal stored Numbers to floats to avoid json serializing issue
class DecimalEncoder(json.JSONEncoder):
    def default(self, obj):
        if isinstance(obj, Decimal):
            return float(obj)
        return json.JSONEncoder.default(self, obj)
        
def remove_control_characters(s):
    return "".join(ch for ch in s if unicodedata.category(ch)[0]!="C")

def get_item(pkeyvalue):
  try:
    # Query on Partition Key
    # Sort key is timestamp. ScanIndexForward controls order direction
    response = DBTABLE.query(
      Select='ALL_ATTRIBUTES',
      KeyConditionExpression=Key('Account').eq(pkeyvalue),
      ScanIndexForward=True
    )
  except Exception as e:
    return None, e.__str__()
  return DecimalEncoder().encode(response), None


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
  # print('DEBUG Event -> ' + json.dumps(event))
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
  for field in ["Account"]:
    if bodyjson[field] is None:
      return return_failure("Invalid Request: Missing Value for " + field, 500)
  
  result, err = get_item(bodyjson["Account"])
  if err != None:
    return return_failure('ERROR Getting Data - ' + str(err), 500)
  # Build reponse body message
  msg = {
    "Count": json.loads(result)['Count'],
    "Items": json.loads(result)['Items']
  }
  # Were the results paginated - if so return nextrecord value
  if "LastEvaluatedKey" in result:
    msg['NextRecord'] = {
      "NextRecord": json.loads(result)['LastEvaluatedKey']
    }
  
  print('Records Found: ' + str(json.loads(result)['Count']))
  return return_success(msg)