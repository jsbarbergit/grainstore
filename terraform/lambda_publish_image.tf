module "grainstore_publish_image" {
  filename = "index.py"
  source   = "./modules/lambda"
  template_file_rendered = templatefile("${path.module}/functions/publish-image.py.tpl", {
    aws_region         = var.aws_region,
    bucket_name        = local.bucket_name
    public_bucket_name = local.public_bucket_name
  })
  function_name      = "GrainstorePublishImage-${var.environment}"
  role_arn           = aws_iam_role.grainstore_publish_image_role.arn
  handler            = "index.lambda_handler"
  runtime            = "python3.8"
  publish            = true
  description        = "Grainstore Publish Image Function ${var.environment}"
  log_retention_days = var.log_retention_days
  environment        = var.environment
}

resource "aws_lambda_permission" "grainstore_publish_image_permission" {
  statement_id  = "AllowExecutionFromAPIGW"
  action        = "lambda:InvokeFunction"
  function_name = module.grainstore_publish_image.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = join("/", [aws_apigatewayv2_api.api_gw.execution_arn, "*", "*", "*"])
}