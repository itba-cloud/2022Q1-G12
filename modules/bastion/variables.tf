# Input variable definitions

variable "vpc_id" {
  description = "VPC."
  type        = string
}

variable "subnets" {
  description = "VPC."
  type        = list(string)
}

variable "ami" {
  description = "AMI"
  type        = string
}

variable "key_name" {
  description = "SSH key name"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
}

variable "my_ips" {
  description = "IPs whitelisted for SSH access"
  type        = list(string)
}
