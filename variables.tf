variable aws_region {
  description = "AWS Region in which to deploy the application"
  type        = string
}

variable app_domain {
  description = "Base domain for the whole application. A subdomain of an already established domain."
  type        = string
}

variable authorized_role {
  description = "Name of the role to use throughout the application deployment. We only support a single super-user."
  type        = string
}

variable "db_user" {
  description = "User of the database"
  type        = string
}

variable "db_pass" {
  description = "Password of the database"
  type        = string
  sensitive   = true
}

