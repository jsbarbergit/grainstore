resource "random_uuid" "uuid" {}

locals {
  random_file = join("/", ["/tmp/", random_uuid.uuid.result])
}
resource "local_file" "file" {
  filename   = join("/", [local.random_file, var.filename])
  content    = var.template_file_rendered
  depends_on = [random_uuid.uuid]
}

data "archive_file" "archive" {
  type        = "zip"
  source_dir  = local.random_file
  output_path = join("/", [local.random_file, "/zip.zip"])
  depends_on  = [local_file.file]
}

resource "aws_lambda_function" "function" {
  filename      = join("/", [local.random_file, "/zip.zip"])
  function_name = var.function_name
  role          = var.role_arn
  handler       = var.handler
  runtime       = var.runtime
  publish       = var.publish

  source_code_hash = data.archive_file.archive.output_base64sha256
  description      = var.description
  depends_on       = [data.archive_file.archive]
}
