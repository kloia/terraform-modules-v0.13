module "s3_bucket" {
  source               = "terraform-aws-modules/s3-bucket/aws"
  create_bucket        = var.access_logs_enabled && length(var.access_log_bucket_name) == 0 && var.create_alb == 0 ? true : false
  bucket               = local.bucket_name
  acl                  = "private"
  attach_public_policy = false

  versioning = {
    enabled = false
  }

  server_side_encryption_configuration = {
    rule = {
      apply_server_side_encryption_by_default = {
        sse_algorithm = "AES256"
      }
    }
  }

  tags = merge(var.tags, map("Name", local.bucket_name))

}

resource "aws_s3_bucket_policy" "s3-alb-pol" {
  bucket = module.s3_bucket.this_s3_bucket_id
  count  = var.access_logs_enabled && var.create_alb ? 1 : 0
  depends_on = [module.s3_bucket]
  policy = <<POLICY
{
  "Id": "Policy",
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "AWS": "${data.aws_elb_service_account.main.arn}"
      },
      "Action": "s3:PutObject",
      "Resource": "arn:aws:s3:::${local.bucket_name}/${local.bucket_prefix}/AWSLogs/417732881703/*"
    },
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "delivery.logs.amazonaws.com"
      },
      "Action": "s3:PutObject",
      "Resource": "arn:aws:s3:::${local.bucket_name}/${local.bucket_prefix}/AWSLogs/417732881703/*",
      "Condition": {
        "StringEquals": {
          "s3:x-amz-acl": "bucket-owner-full-control"
        }
      }
    },
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "delivery.logs.amazonaws.com"
      },
      "Action": "s3:GetBucketAcl",
      "Resource": "arn:aws:s3:::${local.bucket_name}"
    }
  ]
}
POLICY
}
