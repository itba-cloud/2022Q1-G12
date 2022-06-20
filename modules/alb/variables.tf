variable "name" {
  description = "Name of the ALB"
  type        = string
}

variable "internal" {
  description = "Decide if the ALB is internet facing or internal"
  type        = bool
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "vpc_cidr" {
  description = "VPC CIDR"
  type        = string
}

variable "subnets" {
  description = "Subnets for ALB"
  type        = list(string)
}

variable "services" {
  description = "Services definition by name"
  type        = map(map(any))
}

variable "public_api_prefix" {
  description = "Path prefix for the public api of services"
  type        = string
}

variable "cdn_secret_header" {
  description = "Header where secret between public ALB and CDN travels. Only for public ALB."
  type        = string
  default     = null
}

variable "cdn_secret" {
  description = "Secret between public ALB and CDN. Only for public ALB."
  type        = string
  default     = null
}

