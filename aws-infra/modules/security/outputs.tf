output "alb_security_group_id" {
  description = "ID of the ALB Security Group"
  value       = aws_security_group.alb_sg.id
}

output "ecs_security_group_id" {
  description = "ID of the ECS Security Group"
  value       = aws_security_group.ecs_sg.id
}
