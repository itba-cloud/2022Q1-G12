data "aws_iam_policy_document" "site" {
  statement {
    actions   = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.site.arn}/*"]

    principals {
      type        = "AWS"
      identifiers = var.bucket_access_OAI
    }
  }
}

data "aws_iam_policy_document" "www" {
  statement {
    sid     = "PublicReadGetObject"
    effect  = "Allow"
    actions = ["s3:GetObject"]
    principals {
      type        = "AWS"
      identifiers = var.bucket_access_OAI
    }
    resources = ["${aws_s3_bucket.www.arn}/*"]
  }
}
