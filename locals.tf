locals {
  # Frontend
  static_resources = "frontend"

  # API
  public_api_prefix = "/api"

  # AWS VPC Configuration
  aws_vpc_network = "10.0.0.0/16"
  aws_az_count    = 2

  alb_cdn_secret_header = "X-Alb-Cdn-Secret-V1"

  # RDS
  db_name = "gamexprimary"
  db_port = 5432
}