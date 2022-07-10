resource "random_password" "secret" {
  length  = var.length
  keepers = var.keepers
}

resource "aws_secretsmanager_secret" "secret" {
  name_prefix = var.name_prefix
  description = var.description
}

resource "aws_secretsmanager_secret_version" "secret" {
  secret_id     = aws_secretsmanager_secret.secret.id
  secret_string = random_password.secret.result
}