resource "aws_apigatewayv2_api" "api_gw" {
  name          = "grainstore-api"
  protocol_type = "HTTP"
}

resource "aws_apigatewayv2_integration" "login_lambda_integration" {
  api_id                 = aws_apigatewayv2_api.api_gw.id
  integration_type       = "AWS_PROXY"
  connection_type        = "INTERNET"
  description            = "Cognito Login Lambda"
  integration_method     = "POST"
  integration_uri        = module.cognito_login.invoke_arn
  payload_format_version = "2.0"
}

resource "aws_apigatewayv2_route" "login_route" {
  api_id    = aws_apigatewayv2_api.api_gw.id
  route_key = "POST /login"
  #   route_key = "$default"
  target = join("/", ["integrations", aws_apigatewayv2_integration.login_lambda_integration.id])
}

resource "aws_apigatewayv2_stage" "api_gw_dev_stage" {
  api_id      = aws_apigatewayv2_api.api_gw.id
  name        = "dev"
  auto_deploy = true
  # Temp workaround for open issue: https://github.com/terraform-providers/terraform-provider-aws/issues/12893
  lifecycle {
    ignore_changes = [deployment_id, default_route_settings]
  }
}

# resource "aws_apigatewayv2_deployment" "api_gw_deploy" {
#   api_id      = aws_apigatewayv2_api.api_gw.id
#   description = "Grainstore API Deployment"

#   lifecycle {
#     create_before_destroy = true
#   }
# }