variable "frontend_OAI" {
  description = "OAI"
  type        = map(any)
}

variable "frontend_origin_id" {
  type        = string
}

variable "frontend_domain_name" {
  type        = string
}

variable "api_origin_id" {
  type        = string
}

variable "api_domain_name" {
  type        = string
}

variable "api_path_pattern" {
  type        = string
}

variable "aliases" {
  type        = set(string)
}

variable "certificate_arn" {
  type        = string
}

variable "alb_secret_header" {
  description = "Header where secret between ALB and CDN travels"
  type        = string
}

variable "alb_secret" {
  description = "Secret between ALB and CDN"
  type        = string
}
