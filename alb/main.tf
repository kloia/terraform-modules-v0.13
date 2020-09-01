resource "aws_lb" "alb" {
  name               = var.name
  internal           = var.internal
  load_balancer_type = "application"
  security_groups    = length(var.security_groups) == 0 ? [aws_security_group.sg-alb[0].id] : var.security_groups
  subnets            = length(var.subnets) == 0 ? data.aws_subnet_ids.default_subnet_ids[0].ids : var.subnets
  count              = !var.internal && var.create_alb ? 1 : 0
  idle_timeout       = var.idle_timeout
  tags               = merge(var.tags, map("Name", var.name))
  ip_address_type    = "ipv4"
  enable_http2       = var.enable_http2

  enable_deletion_protection       = var.enable_deletion_protection
  drop_invalid_header_fields       = var.drop_invalid_header_fields
  enable_cross_zone_load_balancing = var.enable_cross_zone_load_balancing

  access_logs {
    bucket  = module.s3_bucket.this_s3_bucket_id
    prefix  = "tf-alb-module-${var.name}"
    enabled = var.access_logs_enabled
  }

  timeouts {
    create = var.load_balancer_create_timeout
    update = var.load_balancer_update_timeout
    delete = var.load_balancer_delete_timeout
  }
}

resource "aws_lb" "alb-int" {
  name               = var.name
  internal           = var.internal
  load_balancer_type = "application"
  security_groups    = length(var.subnets) == 0 ? [aws_security_group.sg-alb-int[0].id] : var.security_groups
  subnets            = var.subnets
  count              = var.internal && var.create_lb ? 1 : 0
  idle_timeout       = var.idle_timeout
  tags               = merge(var.tags, map("Name", var.name))
  ip_address_type    = "ipv4"
  enable_http2       = var.enable_http2

  enable_deletion_protection       = var.enable_deletion_protection
  drop_invalid_header_fields       = var.drop_invalid_header_fields
  enable_cross_zone_load_balancing = var.enable_cross_zone_load_balancing

  access_logs {
    bucket  = module.s3_bucket.this_s3_bucket_id
    prefix  = "tf-alb-module-${var.name}"
    enabled = var.access_logs_enabled
  }

  timeouts {
    create = var.load_balancer_create_timeout
    update = var.load_balancer_update_timeout
    delete = var.load_balancer_delete_timeout
  }
}