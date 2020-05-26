module "grainstore_signed_url" {
  filename = "index.py"
  source   = "./modules/lambda"
  template_file_rendered = templatefile("${path.module}/functions/getsignedurl.py.tpl", {
    aws_region = var.aws_region
  })
  function_name = "GrainstoreSignedUrl"
  role_arn      = aws_iam_role.grainstore_signed_url_role.arn
  handler       = "index.lambda_handler"
  runtime       = "python3.8"
  publish       = true
  description   = "Grainstore Generate PreSigned URL Function"
}

resource "aws_lambda_permission" "grainstore_signed_url_permission" {
  statement_id  = "AllowExecutionFromAPIGW"
  action        = "lambda:InvokeFunction"
  function_name = module.grainstore_signed_url.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = join("/", [aws_apigatewayv2_api.api_gw.execution_arn, "*", "*", "*"])
}