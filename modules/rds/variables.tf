variable "vpc_id" {
  type        = string
  description = "VPC ID"
}

variable "vpc_cidr" {
  type        = string
  description = "VPC CIDR"
}

variable "db_subnets" {
  description = "Subnets for database layer"
  type        = list(string)
}

variable "db_name" {
  description = "Name of the database"
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

variable "db_port" {
  description = "Port of the database"
  type        = number
}
