# Input variable definitions

variable "authorized_role" {
  description = "Authorized role name for bucket and encryption key creation"
  type        = string
}

# variable "root_IAM_arn" {
#   description = "Root IAM arn"
#   type        = list(string)
# }

variable "aws_region" {
  description = "AWS Region"
  type        = string
}
