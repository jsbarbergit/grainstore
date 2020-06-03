output "arn" {
  value = aws_lambda_function.function.arn
}

output "qualified_arn" {
  value = aws_lambda_function.function.qualified_arn
}

output "invoke_arn" {
  value = aws_lambda_function.function.invoke_arn
}

output "version" {
  value = aws_lambda_function.function.version
}

output "last_modified" {
  value = aws_lambda_function.function.last_modified
}

output "source_code_hash" {
  value = aws_lambda_function.function.source_code_hash
}

output "function_name" {
  value = aws_lambda_function.function.function_name
}
