data "aws_iam_policy_document" "bucket" {
  statement {
    actions   = var.allowed_actions
    resources = ["${aws_s3_bucket.main.arn}/*"]

    principals {
      type        = "AWS"
      identifiers = [var.iam_role_arn]
    }
  }
}
