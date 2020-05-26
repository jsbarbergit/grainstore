# Explicitly create CW Log groups for lambdas to control retention
resource "aws_cloudwatch_log_group" "log_group" {
  name              = "/aws/lambda/${var.function_name}"
  retention_in_days = var.log_retention_days
  tags = {
    Application = "grainstore"
    Environment = var.environment
  }
}