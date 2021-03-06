resource "aws_apigatewayv2_api" "api_gw" {
  name          = "grainstore-api-${var.environment}"
  protocol_type = "HTTP"
  cors_configuration {
    allow_origins = ["*"]
    allow_methods = ["*"]
    allow_headers = ["*"]
  }
}

# Authorizers
resource "aws_apigatewayv2_authorizer" "cognito_authorizer" {
  api_id           = aws_apigatewayv2_api.api_gw.id
  authorizer_type  = "JWT"
  identity_sources = ["$request.header.Authorization"]
  name             = "GrainstoreCognitoAuthorizer-${var.environment}"

  jwt_configuration {
    audience = [
      aws_cognito_user_pool_client.client.id,
      aws_cognito_user_pool_client.ui_client.id
    ]
    issuer = join("", ["https://", aws_cognito_user_pool.pool.endpoint])
  }
}

# Integrations
resource "aws_apigatewayv2_integration" "login_lambda_integration" {
  api_id                 = aws_apigatewayv2_api.api_gw.id
  integration_type       = "AWS_PROXY"
  connection_type        = "INTERNET"
  description            = "${var.environment} Cognito Login Lambda"
  integration_method     = "POST"
  integration_uri        = module.cognito_login.invoke_arn
  payload_format_version = "2.0"
}

resource "aws_apigatewayv2_integration" "signed_url_lambda_integration" {
  api_id                 = aws_apigatewayv2_api.api_gw.id
  integration_type       = "AWS_PROXY"
  connection_type        = "INTERNET"
  description            = "${var.environment} Grainstore Presigned URL Lambda"
  integration_method     = "POST"
  integration_uri        = module.grainstore_signed_url.invoke_arn
  payload_format_version = "2.0"
}

resource "aws_apigatewayv2_integration" "add_record_lambda_integration" {
  api_id                 = aws_apigatewayv2_api.api_gw.id
  integration_type       = "AWS_PROXY"
  connection_type        = "INTERNET"
  description            = "${var.environment} Grainstore Add Record Lambda"
  integration_method     = "POST"
  integration_uri        = module.grainstore_add_record.invoke_arn
  payload_format_version = "2.0"
}

resource "aws_apigatewayv2_integration" "get_record_lambda_integration" {
  api_id                 = aws_apigatewayv2_api.api_gw.id
  integration_type       = "AWS_PROXY"
  connection_type        = "INTERNET"
  description            = "${var.environment} Grainstore Get Record Lambda"
  integration_method     = "POST"
  integration_uri        = module.grainstore_get_record.invoke_arn
  payload_format_version = "2.0"
}

resource "aws_apigatewayv2_integration" "publish_image_lambda_integration" {
  api_id                 = aws_apigatewayv2_api.api_gw.id
  integration_type       = "AWS_PROXY"
  connection_type        = "INTERNET"
  description            = "${var.environment} Grainstore Publish Image Lambda"
  integration_method     = "POST"
  integration_uri        = module.grainstore_publish_image.invoke_arn
  payload_format_version = "2.0"
}

# Routes
resource "aws_apigatewayv2_route" "login_route" {
  api_id    = aws_apigatewayv2_api.api_gw.id
  route_key = "POST /login"
  target    = join("/", ["integrations", aws_apigatewayv2_integration.login_lambda_integration.id])

}

resource "aws_apigatewayv2_route" "signed_url_route" {
  api_id             = aws_apigatewayv2_api.api_gw.id
  route_key          = "POST /signedurl"
  target             = join("/", ["integrations", aws_apigatewayv2_integration.signed_url_lambda_integration.id])
  authorization_type = "JWT"
  authorizer_id      = aws_apigatewayv2_authorizer.cognito_authorizer.id
}

resource "aws_apigatewayv2_route" "add_record_route" {
  api_id             = aws_apigatewayv2_api.api_gw.id
  route_key          = "POST /addrecord"
  target             = join("/", ["integrations", aws_apigatewayv2_integration.add_record_lambda_integration.id])
  authorization_type = "JWT"
  authorizer_id      = aws_apigatewayv2_authorizer.cognito_authorizer.id
}

resource "aws_apigatewayv2_route" "get_record_route" {
  api_id             = aws_apigatewayv2_api.api_gw.id
  route_key          = "POST /getrecord"
  target             = join("/", ["integrations", aws_apigatewayv2_integration.get_record_lambda_integration.id])
  authorization_type = "JWT"
  authorizer_id      = aws_apigatewayv2_authorizer.cognito_authorizer.id
}

resource "aws_apigatewayv2_route" "publish_image_route" {
  api_id             = aws_apigatewayv2_api.api_gw.id
  route_key          = "POST /publishimage"
  target             = join("/", ["integrations", aws_apigatewayv2_integration.publish_image_lambda_integration.id])
  authorization_type = "JWT"
  authorizer_id      = aws_apigatewayv2_authorizer.cognito_authorizer.id
}

# Stages
resource "aws_apigatewayv2_stage" "api_gw_stage" {
  api_id      = aws_apigatewayv2_api.api_gw.id
  name        = var.environment
  auto_deploy = true
  # Temp workaround for open issue: https://github.com/terraform-providers/terraform-provider-aws/issues/12893
  lifecycle {
    ignore_changes = [deployment_id, default_route_settings]
  }
}