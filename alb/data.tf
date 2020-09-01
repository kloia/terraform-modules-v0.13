data "aws_vpc" "default" {
  count   = length(var.subnets) == 0 ? 1 : 0
  default = true
}

data "aws_vpc" "alb_vpc" {
  id = length(var.subnets) == 0 ? data.aws_vpc.default[0].id : data.aws_subnet.alb_subnets[0].vpc_id
}

data "aws_subnet" "alb_subnets" {
  count = length(var.subnets) != 0 && var.create_alb ? 1 : 0
  id    = var.subnets[0]
}

data "aws_subnet_ids" "default_subnet_ids" {
  count  = length(var.subnets) == 0 && var.create_alb ? 1 : 0
  vpc_id = data.aws_vpc.default[0].id
}

data "aws_elb_service_account" "main" {}

resource "random_string" "random" {
  length  = 6
  special = false
  lower   = true
  upper   = false
  number  = false
}

locals {
  bucket_name   = length(var.access_log_bucket_name) == 0 ? "tf-alb-module-${var.name}-${random_string.random.result}" : var.access_log_bucket_name
  bucket_prefix = "tf-alb-module-${var.name}"
}