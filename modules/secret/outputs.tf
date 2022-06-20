output "version" {
  description = "Domain name of load balancer"
  value       = aws_secretsmanager_secret_version.secret
}

output "value" {
  description = "Random secret value"
  value       = random_password.secret.result
}