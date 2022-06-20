// TODO(tobi): Locking

terraform {
  required_version = "~> 1.2.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.18.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

resource "aws_s3_bucket" "state" {
  bucket_prefix = "state"
}

data "aws_iam_role" "main" {
  name = var.authorized_role
}

resource "aws_kms_key" "state" {
  description             = "state"
  deletion_window_in_days = 10
}

resource "aws_kms_alias" "state" {
  name          = "alias/tf_state_key"
  target_key_id = aws_kms_key.state.key_id
}

resource "aws_s3_bucket_public_access_block" "state" {
  bucket = aws_s3_bucket.state.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
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

resource "aws_s3_bucket_policy" "state" {
  bucket = aws_s3_bucket.state.id
  policy = data.aws_iam_policy_document.bucket.json
}
