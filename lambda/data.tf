locals {
  efs_config = {
    arn              = var.efs_arn
    local_mount_path = var.efs_mount_path
  }

  //For depends_on, since depends_on doesn't support ternary ops, you should merge arrays of dependencies by yourself in locals.
  cw_depends = var.create_cw ? [aws_iam_role_policy_attachment.lambda_logs[0]] : []
  //If file doesn't end with .zip then converts to .zip'ed name. For filename field in lambda resource only, dependency tree will be generated elsewhere.
  //Will also match if filename is empty.
  filename   = local.is_zipped ? var.filename : "${var.filename}.zip"
  //Checks only if file is zipped or not.
  is_zipped  = can(regex("^$|^[\\w-/.]*.zip$", var.filename)) && var.filename != ""

  //Code block for how to hash files, if s3 object version enabled this goes is disabled, for files checks if already zipped or not
  //If not zipped gets the output of zipper to create dependency tree for lifecycle. If s3 then stores last modified field.
  version_enabled = var.s3_object_version != null ? true : false
  hash_enabled    = var.filename != "" || !local.version_enabled ? true : false
  hash_zipped     = local.is_zipped && var.filename != "" ? filebase64sha256(var.filename) : null
  hash_tf_zipped  = !local.is_zipped && var.filename != "" ? filebase64sha256(data.archive_file.lambdaCode[0].output_path) : null
  hash_file       = local.is_zipped ? local.hash_zipped : local.hash_tf_zipped
  hash_bucket     = local.s3_hash_enabled ? base64sha256(data.aws_s3_bucket_object.lamda_code[0].last_modified) : null
  source_hash     = var.filename != "" ? local.hash_file : local.hash_bucket

  //Checks if efs variables both set or both unset, raises error if not proper. If terraform ever releases raise error func, then use it instead.
  efs_vars_incompatible = var.efs_mount_path == "" && var.efs_arn != "" || var.efs_mount_path != "" && var.efs_arn == ""
  efs_vars_empty        = var.efs_mount_path == "" && var.efs_arn == ""
  efs_misconfigured     = !local.efs_vars_empty && local.efs_vars_incompatible
  raise_error_efs       = local.efs_misconfigured ? file("ERROR: You should set both efs_mount_path and efs_arn to some value if you set one!") : null

  //Checks if s3 variables both set or both unset. If terraform ever releases raise error func, then use it.
  s3_vars_incompatible = var.s3_bucket == null && var.s3_key != null || var.s3_bucket != null && var.s3_key == null
  s3_vars_null         = var.s3_bucket == null && var.s3_key == null
  s3_misconfigured     = !local.s3_vars_null && local.efs_vars_incompatible
  s3_hash_enabled      = !local.s3_vars_null && !local.s3_misconfigured && var.s3_object_version == null
}
//If filename is directory then zip the dir, if normal file zip the normal file. If file name is wrong throws exception.
data "archive_file" "lambdaCode" {
  count       = local.is_zipped ? 0 : 1
  type        = "zip"
  source_file = try(fileexists("${path.module}/${var.filename}"), false) ? "${path.module}/${var.filename}" : null
  source_dir  = !try(fileexists("${path.module}/${var.filename}"), false) ? "${path.module}/${var.filename}" : null
  output_path = "${path.module}/${var.filename}.zip"
}

//Only call this data if object version is not enabled to save s3 api costs.
data "aws_s3_bucket_object" "lamda_code" {
  count  = !local.s3_vars_null && !local.s3_misconfigured && var.s3_object_version == null ? 1 : 0
  bucket = var.s3_bucket
  key    = var.s3_key
}