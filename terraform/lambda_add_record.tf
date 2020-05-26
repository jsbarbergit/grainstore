module "grainstore_add_record" {
  filename = "index.py"
  source   = "./modules/lambda"
  template_file_rendered = templatefile("${path.module}/functions/addrecord.py.tpl", {
    aws_region = var.aws_region
  })
  function_name = "GrainstoreAddRecord"
  role_arn      = aws_iam_role.grainstore_add_record_role.arn
  handler       = "index.lambda_handler"
  runtime       = "python3.8"
  publish       = true
  description   = "Grainstore Add Record Function"
}

resource "aws_lambda_permission" "grainstore_add_record_permission" {
  statement_id  = "AllowExecutionFromAPIGW"
  action        = "lambda:InvokeFunction"
  function_name = module.grainstore_add_record.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = join("/", [aws_apigatewayv2_api.api_gw.execution_arn, "*", "*", "*"])
}