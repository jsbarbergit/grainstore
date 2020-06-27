import boto3
import botocore.exceptions
import hmac
import hashlib
import base64
import json
import unicodedata

IDCLIENT = boto3.client('cognito-idp')

def remove_control_characters(s):
    return "".join(ch for ch in s if unicodedata.category(ch)[0]!="C")
    
def get_secret_hash(username, clientid, clientsecret):
  msg = username + clientid 
  dig = hmac.new(str(clientsecret).encode('utf-8'),
  msg = str(msg).encode('utf-8'), digestmod=hashlib.sha256).digest()
  d2 = base64.b64encode(dig).decode()
  return d2

def initiate_auth(username, password, poolid, clientid, clientsecret):
  secret_hash = get_secret_hash(username, clientid, clientsecret)
  try:
    resp = IDCLIENT.admin_initiate_auth(
        UserPoolId=poolid,
        ClientId=clientid,
        AuthFlow='ADMIN_NO_SRP_AUTH',
        AuthParameters={
          'USERNAME': username,
          'SECRET_HASH': secret_hash,
          'PASSWORD': password,
        },
      ClientMetadata={
        'username': username,
        'password': password,
    })
  except IDCLIENT.exceptions.NotAuthorizedException:
    return None, "The username or password is incorrect"
  except IDCLIENT.exceptions.UserNotConfirmedException:
    return None, "User is not confirmed"
  except Exception as e:
    return None, e.__str__()
  return resp, None

def admin_set_password(poolid, username, password):
  try:
    resp = IDCLIENT.admin_set_user_password(
      UserPoolId=poolid,
      Username=username,
      Password=password,
      Permanent=True
    )
  except Exception as e:
    return None, e.__str__()
  return resp, None

def return_success(resp):
  print("Sending success event")
  # Response body is expected as a string. load up the json first
  respbody = {
    "id_token": resp["AuthenticationResult"]["IdToken"],
    "refresh_token": resp["AuthenticationResult"]["RefreshToken"],
    "access_token": resp["AuthenticationResult"]["AccessToken"],
    "expires_in": resp["AuthenticationResult"]["ExpiresIn"],
    "token_type": resp["AuthenticationResult"]["TokenType"]
  }
  return {
    "isBase64Encoded": False,
    "headers": {
      "Content-Type": "application/json"
    },
    "statusCode": 200,
    "body": json.dumps(respbody)
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
  
  for field in ["username", "password", "poolid", "clientid", "clientsecret"]:
    if bodyjson[field] is None:
      return return_failure("Invalid Request: Missing Value for " + field, 500)

  # Try auth
  resp, msg = initiate_auth(bodyjson['username'], bodyjson['password'], bodyjson['poolid'], bodyjson['clientid'], bodyjson['clientsecret'])
  
  # Check if this is a new user logging in for first time
  if resp.get("ChallengeName") == "NEW_PASSWORD_REQUIRED":
    # Make password permanent and retry login auth
    resp, msg  = admin_set_password(bodyjson['poolid'], bodyjson['username'], bodyjson['password'])
    if msg != None:
      return return_failure("Auth Failure: Error was " + msg, 403)
    resp, msg = initiate_auth(bodyjson['username'], bodyjson['password'], bodyjson['poolid'], bodyjson['clientid'], bodyjson['clientsecret'])

  if msg != None:
    return return_failure("Auth Failure: Error was " + msg, 403)
  elif resp.get("AuthenticationResult"):
      return return_success(resp)
  else:
    print('Error. Response was -> %s',resp)
    return return_failure("UnknownAuth Failure: Error was " + msg, 403)
