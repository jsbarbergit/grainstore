output "APIGW_LOGIN_DEV_ENDPOINT" {
  # Workaround for issue with invoke_url always using wss for proto irrespective of apiv2 type
  value = join("/", [replace(aws_apigatewayv2_stage.api_gw_dev_stage.invoke_url, "wss://", "https://"), "login"])
}