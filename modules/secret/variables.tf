variable "length" {
  description = "Length of the random secret"
  type        = number
}

variable "keepers" {
  description = "Keepers of the random seceret"
  type        = map(string)
}

variable "name_prefix" {
  description = "Name prefix of the secret in aws secret manager"
  type        = string
}

variable "description" {
  description = "Description of the secret in aws secret manager"
  type        = string
  default     = null
}
