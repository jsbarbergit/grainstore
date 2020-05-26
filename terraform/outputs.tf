output "APIGW_LOGIN_ENDPOINT" {
  # Workaround for issue with invoke_url always using wss for proto irrespective of apiv2 type
  value = join("/", [replace(aws_apigatewayv2_stage.api_gw_stage.invoke_url, "wss://", "https://"), "login"])
}

output "API_ID" {
  value = aws_apigatewayv2_stage.api_gw_stage.api_id
}