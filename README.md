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

The following python (v3.8)  example highlights how a new record could be added:

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

x = requests.post(endpoint + '/login', json = body)
print('Login StatusCode: ' + str(x.status_code))
if x.status_code == 200:
    body = json.loads(x.text)
    access_token = body['access_token']
else:
    print('Login failed. StatusCode: ' + str(x.status_code))
    print('Login Response Body: ' + x.text)

# Now call authenticated endpoint
y_headers = {
    'Authorization': access_token,
    'Content-Type': 'application/json'
}
newrecord = {
    "weight": 100,
    "customerid": "abc123"
}
y = requests.post(endpoint + '/addrecord', headers=y_headers, json = newrecord)
print('testauth StatusCode: ' + str(y.status_code))
print('testAuth Response Body :' + y.text)
```