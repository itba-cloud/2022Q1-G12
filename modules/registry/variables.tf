variable "services" {
  description = "Services definition by name"
  type        = map(map(any))
}

variable "services_location" {
  description = "Location of services from root"
  type        = string
}
