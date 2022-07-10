output "distribution" {
  description = "The cloudfront distribution for the deployment"
  value       = aws_cloudfront_distribution.main
}
