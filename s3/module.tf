resource "aws_s3_bucket" "bucket" {

  bucket = var.bucket_name
  acl    = var.acl

  tags = var.tags

  versioning {
    enabled = var.is_vers_enabled
  }


  lifecycle_rule {
    
    id      = "lifecycle=${var.bucket_name}"
    enabled = var.is_lifecycle_enabled

    prefix = var.prefix

    transition {
      days          = var.short_storage_day
      storage_class = var.storage_class
    }

    transition {
      days          = var.long_storage_day
      storage_class = var.long_storage_class
    }

    expiration {
      days = var.expiration
    }
  }


  force_destroy = var.force_destroy
}

output "bucket_domain_name" {
  value = var.bucket_name
}


output "s3_origin_id" {
  value = aws_s3_bucket.bucket.bucket_domain_name
}


