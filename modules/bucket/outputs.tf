output "id" {
  description = "The name of the bucket"
  value       = aws_s3_bucket.main.id
}

output "arn" {
  description = "The arn of the bucket"
  value       = aws_s3_bucket.main.arn
}

output "domain" {
  description = "The domain name of the bucket"
  value       = aws_s3_bucket.main.bucket_domain_name
}

output "zone_id" {
  description = "The hosted zone id of the bucket"
  value       = aws_s3_bucket.main.hosted_zone_id
}

