#!/usr/bin/env python3
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
    headers = {
        'Authorization': token,
        'Content-Type': 'application/json'
    }
    response = requests.post(endpoint + '/addrecord', headers=headers, json = newrecord)
    print('AddRecord StatusCode: ' + str(response.status_code))
    if response.status_code != 200:
        print('ERROR received from api. StatusCode: ' + str(response.status_code))
        print('AddRecord Error was: ' + response.text)
        return False
    return True

def getsignedurl(endpoint, token, customerdetails):
    # Now call authenticated endpoint
    headers = {
        'Authorization': token,
        'Content-Type': 'application/json'
    }
    signedurl = requests.post(endpoint + '/signedurl', headers=headers, json = customerdetails)
    if signedurl.status_code != 200:
        print('ERROR getting signed url. StatusCode: ' + str(signedurl.status_code))
        print('Error - signedurl error --> ' + signedurl.text)
        return None
    return signedurl.text

def postimage(url, fields, file, uuid):
    # Open the image file in  readonly binary mode
    with open(file, 'rb') as f:
        files = {'file': (uuid, f)}
        fields['acl'] = 'private',
        http_response = requests.post(url, data=fields, files=files)
    if http_response.status_code != 204:
        # If successful, returns HTTP status code 204
        print('ERROR: File upload HTTP status code: ' + str(http_response.status_code))
        print('ERROR: Response data: ' + http_response.text)
        return False
    print('Upload via presigned url success. StatusCode: ' + str(http_response.status_code))
    return True

def getrecord(endpoint, token, query):
    # Now call authenticated endpoint
    headers = {
        'Authorization': token,
        'Content-Type': 'application/json'
    }
    response = requests.post(endpoint + '/getrecord', headers=headers, json = query)
    print('GetRecord StatusCode: ' + str(response.status_code))
    if response.status_code != 200:
        print('ERROR received from api. StatusCode: ' + str(response.status_code))
        print('GetRecord Error was: ' + response.text)
        return None
    return response.text

def publishimage(endpoint, token, query):
    # Now call authenticated endpoint
    headers = {
        'Authorization': token,
        'Content-Type': 'application/json'
    }
    response = requests.post(endpoint + '/publishimage', headers=headers, json = query)
    print('PublishImage StatusCode: ' + str(response.status_code))
    if response.status_code != 200:
        print('ERROR received from api. StatusCode: ' + str(response.status_code))
        print('PublishImage Error was: ' + response.text)
        return None
    return response.text


def main():
    region="eu-west-2"
    username = "REPLACEME"
    password = "REPLACEME$$w0rd"
    poolid = "REPLACEME"
    clientid = "REPLACEME"
    secret = "REPLACEME"
    apiendpoint = "REPLACEME"
    account = "companya"

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

    # Get presigned url for image uploads and a uuid to tie image and data together
    customerdata = {
        "Account": account
    }
    signedurl_response = getsignedurl(apiendpoint, token, customerdata)
    if signedurl_response == None:
        print('ERROR - Failed to fetch signed URL')
        return
    signedurl = json.loads(signedurl_response)
    url = signedurl['url']
    fields = signedurl['fields']
    uuid = signedurl['uuid']

    # POST the image to S3
    testfile = 'test_image.png'
    upload_result = postimage(url, fields, testfile, uuid)
    if not upload_result:
        print("Error uploading image. Aborting'")
        return

    # Call authenticated addnewrecord api 
    record_timestamp = datetime.now()
    newrecord = {
        "Account": "HMF",
        "AdmixPct": 1.00,
        "BushelKg": 61.50,
        "Crop": "Winter Wheat",
        "Direction": "In",
        "DryWeightTonnes": 7.68,
        "Image1": "pathdir",
        "ImageBucket": url,
        "ImageKey": fields['key'],
        "MoisturePct": 16.30,
        "SoftwareID": 1,
        "TicketID": 23699,
        "Timestamp": str(record_timestamp.isoformat()),,
        "UUID": uuid,
        "VehicleReg": "NX13 COU",
        "WetWeightTonnes": 8.04
    }
    result = addrecord(apiendpoint, token, newrecord)
    if not result:
        print('ERROR - Failed to add new record')
        return
    print('New Record Added with UUID: ' + uuid)

    # Call authenticated getrecord api 
    query = {
        "Account": account
    }
    result = getrecord(apiendpoint, token, query)
    if result == None:
        print('ERROR - Failed to get record')
        return
    result_json = json.loads(result)
    print('Record Count: ' + str(result_json['Count']))
    if "NextRecord" in result_json:
        print('Pagination Required. Next Record: ' + str(result_json['NextRecord']))
    else:
        print('No pagination required')

    # Get URL for pulished Image
    query = {
        "ImageKey": result_json['Items'][0]['ImageKey'],
        "UUID": result_json['Items'][0]['UUID']
    }
    image_url = publishimage(apiendpoint, token, query)
    if image_url == None:
        print('ERROR - Failed to publish image')
        return
    print("Image URL: " + image_url)
    
    
    return

if __name__ == "__main__":
    main()
