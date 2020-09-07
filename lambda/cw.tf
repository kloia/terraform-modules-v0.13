resource "aws_cloudwatch_log_group" "this" {
  count             = var.create_cw && var.create_function == true ? 1 : 0
  name              = format("/aws/lambda/%s", var.name)
  retention_in_days = var.log_retention_days
  tags              = merge(var.tags, map("Name", format("cw-lambda-%s", var.name)))
}

resource "aws_iam_policy" "lambda_logging" {
  count       = var.create_cw && var.create_function == true ? 1 : 0
  name        = "lambda_logging"
  path        = "/"
  description = "IAM policy for logging from a lambda"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": "arn:aws:logs:*:*:*",
      "Effect": "Allow"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "lambda_logs" {
  role       = aws_iam_role.iam_for_lambda[0].name
  policy_arn = aws_iam_policy.lambda_logging[0].arn
  count      = var.create_cw && var.create_function == true ? 1 : 0
  depends_on = [aws_cloudwatch_log_group.this[0]]
}