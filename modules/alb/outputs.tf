output "main" {
  description = "Load balancer created"
  value       = aws_lb.main
}

output "services_target_group" {
  description = "Target group of ALB redirecting to services"
  value       = aws_alb_target_group.services
}