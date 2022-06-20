# TODO(tobi): Logging a S3

data "aws_cloudfront_cache_policy" "disabled" {
  name = "Managed-CachingDisabled"
}

data "aws_cloudfront_cache_policy" "optimized" {
  name = "Managed-CachingOptimized"
}

resource "aws_cloudfront_distribution" "main" {

  origin {
    domain_name = var.frontend_domain_name
    origin_id   = var.frontend_origin_id

    s3_origin_config {
      origin_access_identity = var.frontend_OAI.cloudfront_access_identity_path
    }
  }

  origin {
    domain_name = var.api_domain_name
    origin_id   = var.api_origin_id

    custom_header {
      name  = var.alb_secret_header
      value = var.alb_secret
    }

    custom_origin_config {
      origin_protocol_policy = "http-only"
      origin_ssl_protocols   = ["TLSv1.2"]
      https_port             = 443
      http_port              = 80
    }
  }

  enabled             = true
  is_ipv6_enabled     = false
  comment             = "cdn"
  default_root_object = "index.html"
  aliases             = var.aliases

  # Configure logging here if required 	
  # logging_config {
  #  include_cookies = false
  #  bucket          = aws_s3_bucket.cdnlogs.id
  # #  prefix          = "myprefix"
  # }
  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = var.frontend_origin_id
    cache_policy_id  = data.aws_cloudfront_cache_policy.optimized.id

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
  }

  # Cache behavior with precedence 0
  ordered_cache_behavior {
    path_pattern     = var.api_path_pattern
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD"]
    cache_policy_id  = data.aws_cloudfront_cache_policy.disabled.id
    target_origin_id = var.api_origin_id

    min_ttl                = 0
    compress               = true
    viewer_protocol_policy = "redirect-to-https"
  }

  price_class = "PriceClass_100"

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  logging_config {
    include_cookies = false
    bucket          = aws_s3_bucket.logs.bucket_domain_name
    prefix          = "access-logs-"
  }

  viewer_certificate {
    acm_certificate_arn      = var.certificate_arn
    minimum_protocol_version = "TLSv1.2_2021"
    ssl_support_method       = "sni-only"
  }

  web_acl_id = var.waf_arn
}