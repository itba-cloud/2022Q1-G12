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

variable "private_aliases" {
  description = "Aliases to declare in the private hosted zone"
  type        = list(object({sub_domain = string, domain = string, zone_id = string}))
  default     = []
}

variable "private_cnames" {
  description = "Aliases to declare in the private hosted zone using CNAME record type. Use if aws alias is not available"
  type        = list(object({sub_domain = string, domain = string}))
  default     = []
}
