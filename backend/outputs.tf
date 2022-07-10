output "kms_key_id" {
  description = "Key"
  value       = aws_kms_key.state.key_id
}

output "bucket" {
  description = "Bucket"
  value       = aws_s3_bucket.state.id
}

output "region" {
  description = "State storage region"
  value       = var.aws_region
}
