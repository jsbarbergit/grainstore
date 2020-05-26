module "cognito_login" {
  filename = "index.py"
  source   = "./modules/lambda"
  template_file_rendered = templatefile("${path.module}/functions/cognito-login.py.tpl", {
    aws_region = var.aws_region
  })
  function_name      = "CognitoLogin-${var.environment}"
  role_arn           = aws_iam_role.cognito_login_role.arn
  handler            = "index.lambda_handler"
  runtime            = "python3.8"
  publish            = true
  description        = "Cognito Login Function ${var.environment}"
  log_retention_days = var.log_retention_days
  environment        = var.environment
}

resource "aws_lambda_permission" "allow_cloudwatch" {
  statement_id  = "AllowExecutionFromAPIGW"
  action        = "lambda:InvokeFunction"
  function_name = module.cognito_login.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = join("/", [aws_apigatewayv2_api.api_gw.execution_arn, "*", "*", "*"])
}