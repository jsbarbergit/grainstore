import json
import unicodedata

def remove_control_characters(s):
    return "".join(ch for ch in s if unicodedata.category(ch)[0]!="C")

def lambda_handler(event, context):
    # TODO implement
    msg = remove_control_characters(event.get('body'))
    return {
      "isBase64Encoded": False,
      "headers": {
        "Content-Type": "application/json"
      },
      "statusCode": 200,
      "body": msg
    }