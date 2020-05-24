data "template_file" "cognito_login" {
  template = <<EOF
import boto3
import botocore.exceptions
import hmac
import hashlib
import base64
import json
import unicodedata

def remove_control_characters(s):
    return "".join(ch for ch in s if unicodedata.category(ch)[0]!="C")
    
def get_secret_hash(username, clientid, clientsecret):
  msg = username + clientid 
  dig = hmac.new(str(clientsecret).encode('utf-8'),
  msg = str(msg).encode('utf-8'), digestmod=hashlib.sha256).digest()
  d2 = base64.b64encode(dig).decode()
  return d2

def initiate_auth(client, username, password, poolid, clientid, clientsecret):
  secret_hash = get_secret_hash(username, clientid, clientsecret)
  try:
    resp = client.admin_initiate_auth(
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
  except client.exceptions.NotAuthorizedException:
    return None, "The username or password is incorrect"
  except client.exceptions.UserNotConfirmedException:
    return None, "User is not confirmed"
  except Exception as e:
    return None, e.__str__()
  return resp, None

def admin_set_password(client, poolid, username, password):
  try:
    resp = client.admin_set_user_password(
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
      
  client = boto3.client('cognito-idp')
  for field in ["username", "password", "poolid", "clientid", "clientsecret"]:
    if bodyjson[field] is None:
      return return_failure("Invalid Request: Missing Value for " + field, 500)

  # Try auth
  resp, msg = initiate_auth(client, bodyjson['username'], bodyjson['password'], bodyjson['poolid'], bodyjson['clientid'], bodyjson['clientsecret'])
  if msg != None:
    return return_failure("Auth Failure: Error was " + msg, 403)
  if resp.get("AuthenticationResult"):
    return return_success(resp)
  elif resp.get("ChallengeName") == "NEW_PASSWORD_REQUIRED":
    # TODO - tidy this repeat mess up once confirm signup logic working
    resp, msg  = admin_set_password(client, bodyjson['poolid'], bodyjson['username'], bodyjson['password'])
    if msg != None:
      return return_failure("Auth Failure: Error was " + msg, 403)
    resp, msg = initiate_auth(client, bodyjson['username'], bodyjson['password'], bodyjson['poolid'], bodyjson['clientid'], bodyjson['clientsecret'])
    if msg != None:
      return return_failure("Auth Failure: Error was " + msg, 403)
    if resp.get("AuthenticationResult"):
      return return_success(resp)
  else:
    print('Error. Response was -> %s',resp)
    return return_failure("Auth Failure: Error was " + msg, 403)

EOF
}

module "cognito_login" {
  filename               = "index.py"
  source                 = "./modules/lambda"
  template_file_rendered = data.template_file.cognito_login.rendered
  function_name          = "CognitoLogin"
  role_arn               = aws_iam_role.cognito_login_role.arn
  handler                = "index.lambda_handler"
  runtime                = "python3.6"
  publish                = true
  description            = "Cognito Login Function"
}

resource "aws_lambda_permission" "allow_cloudwatch" {
  statement_id  = "AllowExecutionFromAPIGW"
  action        = "lambda:InvokeFunction"
  function_name = module.cognito_login.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = join("/", [aws_apigatewayv2_api.api_gw.execution_arn, "*", "*", "*"])
}