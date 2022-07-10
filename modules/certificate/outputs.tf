output "arn" {
  description = "ARN of the application certificate"
  value       = aws_acm_certificate.app.arn
}
