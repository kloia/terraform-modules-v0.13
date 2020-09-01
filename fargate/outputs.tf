output "arn" {
  value = aws_ecs_cluster.fargate[0].arn
}

output "fargate_cluster" {
  value = aws_ecs_cluster.fargate
}