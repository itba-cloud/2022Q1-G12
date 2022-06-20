# Public
variable "app_domain" {
  description = "The base domain of the application"
  type        = string
}

variable "cdn" {
  description = "The cdn distribution of the application"
}

# Private
variable "internal_vpc_domain" {
  description = "Domain name for the private zone of the vpc"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID for private hosted zone"
  type        = string
}

variable "services_alb" {
  description = "Internal services ALB"
}

variable "services_alb_domain" {
  description = "Domain name for ALB"
  type        = string
}


