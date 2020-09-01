resource "aws_ecs_cluster" "fargate" {
  name                = var.name
  count               = var.enabled ? 1 : 0
  capacity_providers  = var.spot_enabled ? ["FARGATE", "FARGATE_SPOT"] : ["FARGATE"]
  tags                = merge(var.tags, map("Name", var.name))

  default_capacity_provider_strategy {
    capacity_provider = "FARGATE"
    weight            = var.weight
    base              = var.base
  }

  setting {
    name  = "containerInsights"
    value = var.container_insights_enabled ? "enabled" : "disabled"
  }
}