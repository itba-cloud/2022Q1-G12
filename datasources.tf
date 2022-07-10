data "aws_caller_identity" "current" {}

data "aws_ecr_authorization_token" "token" {}

data "aws_iam_role" "main" {
  name = var.authorized_role
}
