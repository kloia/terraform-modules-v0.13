output "lambda_arn" {
  value = aws_lambda_function.this[0].arn
}

output "lambda_id" {
  value = aws_lambda_function.this[0].id
}

output "lambda_resource" {
  value = aws_lambda_function.this[0]
}