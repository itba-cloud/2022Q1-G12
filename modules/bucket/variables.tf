variable "name" {
  description = "Name prefix to apply to bucket"
  type        = string
}

variable "iam_role_arn" {
  description = "Arn of the IAM role for which to assign permissions"
  type        = string
}

variable "allowed_actions" {
  description = "Actions allowed to do on the bucket"
  type        = list(string)
}

