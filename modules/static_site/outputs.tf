# Output variable definitions

output "domain_name" {
  description = "buckeet domain name"
  value       = aws_s3_bucket.site.bucket_regional_domain_name
}
