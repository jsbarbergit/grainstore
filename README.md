# Grainstore

Infrastructure repo for Grainstore AWS Components:

* API Gateway
    * /login
    * /addrecord
* Lambda
    * Login Function
    * Add Record Function
* Cognito
* S3
* DynamoDB

## Build

All Infra is built using Terraform: `terraform apply`

## Example Usage

The following python (v3.8) example highlights how a new record could be added with cognito JWT based auth:

```
#!/usr/bin/env python3
import requests
import json

endpoint = 'https://<poolid>.execute-api.<region>.amazonaws.com/<api_stage>'
body = {
    "username": "<cognito_username>",
    "password": "<cognito_password>",
    "poolid": "<cognito_poolid>",
    "clientid": "<cognito_appclient_id>",
    "clientsecret": "<cognito_appclient_secret>"
}
import requests
import json
from jose import jwt
from datetime import datetime, timedelta

def login(endpoint, username, password, poolid, clientid, secret):
    body = {
        "username": username,
        "password": password,
        "poolid": poolid,
        "clientid": clientid,
        "clientsecret": secret
    }
    x = requests.post(endpoint + '/login', json = body)
    print('Login StatusCode: ' + str(x.status_code))

    if x.status_code == 200:
        body = json.loads(x.text)
        id_token = body['id_token']
        refresh_token =  body['refresh_token']
        access_token = body['access_token']
    else:
        print('Login failed. StatusCode: ' + str(x.status_code))
        print('Login Response Body: ' + x.text)
        return None
    return access_token

def tokenvalid(token, region, poolid, clientid):
    # Decode token to make decision on expiry time
    # Optionally do additional validation steps here, e.g. validate cognito issuer
    # build the URL where the public keys are
    jwks_url = 'https://cognito-idp.{}.amazonaws.com/{}/' \
                '.well-known/jwks.json'.format(
                        region,
                        poolid)
    # get the keys from cognito endpoint
    jwks = requests.get(jwks_url).json()
    # decode the access token
    access_decode = jwt.decode(token, jwks, audience=clientid)
    # get the Expiry time
    expirytime = datetime.fromtimestamp(access_decode['exp'])
    if datetime.now() < expirytime:
        # Token still valid , but if less than 5 mins to go, relogin
        if expirytime - timedelta(minutes=5) < datetime.now():
            print('Token expires in less than 5m - re-auth now')
            return False
    else:
        print('token has expired  - login again')
        return False
    return True

def addrecord(endpoint, token, newrecord):
    # Now call authenticated endpoint
    y_headers = {
        'Authorization': token,
        'Content-Type': 'application/json'
    }
    y = requests.post(endpoint + '/addrecord', headers=y_headers, json = newrecord)
    print('AddRecord StatusCode: ' + str(y.status_code))
    print('AddRecord Response Body :' + y.text)
    if y.status_code != 200:
        print('ERROR received from api. StatusCode: ' + str(y.status_code))
        return False
    return True

def main():
    region="<aws_region>"
    username = "<cognito_username>"
    password = "<cognito_password>"
    poolid = "<cognito_poolid>"
    clientid = "<cognito_appclient_id>"
    secret = "<cognito_appclient_secret>"
    apiendpoint = "https://<api_id>.execute-api.<aws_region>.amazonaws.com/<api_stage>"

    # Login via cognito and retrieve access token
    token = login(apiendpoint, username, password, poolid, clientid, secret)
    if token == None:
        print('ERROR - Cannot proceed without valid access token')
        return

    # Do some stuff
    # 
    
    # Before making an authenticated api call, check token still valid 
    isvalid = tokenvalid(token, region, poolid, clientid)
    if not isvalid:
        token = login(apiendpoint, username, password, poolid, clientid, secret)
        if token == None:
            print('ERROR - Cannot proceed without valid access token')
            return

    # Call authenticated addnewrecord api 
    newrecord = {
        "weight": 100,
        "customerid": "abc123"
    }
    result = addrecord(apiendpoint, token, newrecord)
    if not result:
        print('ERROR - Failed to add new record')
        return
    print('New Record Added')
    return

if __name__ == "__main__":
    main()
```