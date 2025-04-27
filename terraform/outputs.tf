output "vpc_id" {
  value = aws_vpc.main.id
}

output "ecs_cluster_id" {
  value = aws_ecs_cluster.this.id
}

output "ecs_service_id" {
  value = aws_ecs_service.this.id
}

output "task_definition_arn" {
  value = aws_ecs_task_definition.this.arn
}
output "ecs_service_name" {
  value = aws_ecs_service.this.name
}

output "ecs_cluster_name" {
  value = aws_ecs_cluster.this.name
}

output "subnet_id" {
  value = aws_subnet.public.id
}

output "security_group_id" {
  value = aws_security_group.allow_http.id
}