resource "aws_iam_role" "iam_for_lambda" {
  name  = "iam_for_lambda"
  count = var.create_function ? 1 : 0

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_lambda_function" "this" {
  count         = var.create_function ? 1 : 0
  filename      = var.filename == "" ? null : local.filename
  s3_bucket     = var.s3_bucket
  s3_key        = var.s3_key
  function_name = var.name
  handler       = var.handler
  description   = var.description
  runtime       = var.runtime
  timeout       = var.timeout
  memory_size   = var.memory_size
  layers        = var.layers
  publish       = var.publish

  role          = aws_iam_role.iam_for_lambda[0].arn
  tags          = merge(var.tags, map("Name", var.name))
  kms_key_arn   = var.environment != null ? var.kms_key_arn : null
  depends_on    = [local.cw_depends, data.archive_file.lambdaCode]

  source_code_hash  = local.hash_enabled ? local.source_hash : null
  s3_object_version = var.s3_object_version

  reserved_concurrent_executions = var.reserved_concurrent_executions

  lifecycle {
    ignore_changes = [
      filename,
    ]
  }

  vpc_config {
    security_group_ids = var.security_groups
    subnet_ids         = var.subnets
  }

  tracing_config {
    mode = var.tracing_mode
  }

  dynamic "file_system_config" {
    for_each = local.efs_misconfigured || local.efs_vars_empty ? [] : [local.efs_config]
    content {
      arn              = local.efs_config.arn
      local_mount_path = local.efs_config.local_mount_path
    }
  }

  dynamic "dead_letter_config" {
    for_each = var.dead_letter_arn == null ? [] : [var.dead_letter_arn]
    content {
      target_arn = var.dead_letter_arn
    }
  }

  dynamic "environment" {
    for_each = var.environment == null ? [] : [var.environment]
    content {
      variables = var.environment
    }
  }
}