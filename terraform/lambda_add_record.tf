module "grainstore_add_record" {
  filename = "index.py"
  source   = "./modules/lambda"
  template_file_rendered = templatefile("${path.module}/functions/addrecord.py.tpl", {
    aws_region                         = var.aws_region,
    grainstore_data_table_name         = local.table_name,
    grainstore_data_partition_key_name = var.grainstore_data_partition_key_name,
    grainstore_data_sort_key_name      = var.grainstore_data_sort_key_name
  })
  function_name      = "GrainstoreAddRecord-${var.environment}"
  role_arn           = aws_iam_role.grainstore_add_record_role.arn
  handler            = "index.lambda_handler"
  runtime            = "python3.8"
  publish            = true
  description        = "Grainstore Add Record Function ${var.environment}"
  log_retention_days = var.log_retention_days
  environment        = var.environment
}

resource "aws_lambda_permission" "grainstore_add_record_permission" {
  statement_id  = "AllowExecutionFromAPIGW"
  action        = "lambda:InvokeFunction"
  function_name = module.grainstore_add_record.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = join("/", [aws_apigatewayv2_api.api_gw.execution_arn, "*", "*", "*"])
}