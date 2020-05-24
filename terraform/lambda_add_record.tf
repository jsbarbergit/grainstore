data "template_file" "grainstore_add_record" {
  template = <<EOF
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
EOF
}

module "grainstore_add_record" {
  filename               = "index.py"
  source                 = "./modules/lambda"
  template_file_rendered = data.template_file.grainstore_add_record.rendered
  function_name          = "GrainstoreAddRecord"
  # TODO Create own IAM Role when reqs known
  role_arn    = aws_iam_role.cognito_login_role.arn
  handler     = "index.lambda_handler"
  runtime     = "python3.8"
  publish     = true
  description = "Grainstore Add Record Function"
}

resource "aws_lambda_permission" "grainstore_add_record_permission" {
  statement_id  = "AllowExecutionFromAPIGW"
  action        = "lambda:InvokeFunction"
  function_name = module.grainstore_add_record.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = join("/", [aws_apigatewayv2_api.api_gw.execution_arn, "*", "*", "*"])
}