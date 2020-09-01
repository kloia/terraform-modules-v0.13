output "access_log_bucket_name" {
  value = var.access_logs_enabled ? local.bucket_name : ""
}

output "access_log_bucket_prefix" {
  value = var.access_logs_enabled ? local.bucket_prefix : ""
}

output "alb_resource" {
  value = var.internal ? aws_lb.alb-int : aws_lb.alb
}