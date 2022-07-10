data "aws_iam_role" "main" {
  name = var.authorized_role
}

data "aws_iam_policy_document" "bucket" {
  statement {
    actions   = ["s3:ListBucket"]
    resources = ["${aws_s3_bucket.state.arn}"]

    principals {
      type        = "AWS"
      identifiers = [data.aws_iam_role.main.arn]
    }
  }
  statement {
    actions   = ["s3:GetObject", "s3:PutObject", "s3:DeleteObject"]
    resources = ["${aws_s3_bucket.state.arn}/*"]

    principals {
      type        = "AWS"
      identifiers = [data.aws_iam_role.main.arn]
    }
  }
}
