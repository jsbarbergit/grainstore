module "grainstore_get_record" {
  filename = "index.py"
  source   = "./modules/lambda"
  template_file_rendered = templatefile("${path.module}/functions/getrecord.py.tpl", {
    aws_region                 = var.aws_region,
    grainstore_data_table_name = local.table_name,
  })
  function_name      = "GrainstoreGetRecord-${var.environment}"
  role_arn           = aws_iam_role.grainstore_get_record_role.arn
  handler            = "index.lambda_handler"
  runtime            = "python3.8"
  publish            = true
  description        = "Grainstore Get Record Function ${var.environment}"
  log_retention_days = var.log_retention_days
  environment        = var.environment
}

resource "aws_lambda_permission" "grainstore_get_record_permission" {
  statement_id  = "AllowExecutionFromAPIGW"
  action        = "lambda:InvokeFunction"
  function_name = module.grainstore_get_record.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = join("/", [aws_apigatewayv2_api.api_gw.execution_arn, "*", "*", "*"])
}