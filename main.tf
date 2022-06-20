provider "aws" {
  region = var.aws_region
}

data "aws_caller_identity" "current" {}
data "aws_ecr_authorization_token" "token" {}

provider "docker" {
  registry_auth {
    address  = "${data.aws_caller_identity.current.account_id}.dkr.ecr.${var.aws_region}.amazonaws.com"
    username = data.aws_ecr_authorization_token.token.user_name
    password = data.aws_ecr_authorization_token.token.password
  }
}

data "aws_iam_role" "main" {
  name = var.authorized_role
}

module "certificate" {
  source = "./modules/certificate"

  app_domain   = var.app_domain
}

module "vpc" {
  source = "./modules/vpc"

  cidr_block  = local.aws_vpc_network
  zones_count = local.aws_az_count
  natgw       = true
}

resource "aws_cloudfront_origin_access_identity" "cdn" {
  comment = "Origin access for CDN to the frontend"
}

module "static_site" {
  source = "./modules/static_site"

  src               = local.static_resources
  bucket_access_OAI = [aws_cloudfront_origin_access_identity.cdn.iam_arn]
}

module "services" {
  source = "./services"
}

module "registry" {
  source = "./modules/registry"

  services          = module.services.definitions
  services_location = "services"
}

# Secreto entre CDN y public ALB
// TODO(tobi): Rotar secreto (requiere una lambda)
module "alb_cdn_secret" {
  source = "./modules/secret"

  name_prefix = "alb-cdn-secret-"
  description = "Secret between CDN and ALB"
  length      = 24
  keepers     = {
    header = local.alb_cdn_secret_header
  }
}

module "public_alb" {
  source = "./modules/alb"

  name              = "app-alb"
  internal          = false

  vpc_id            = module.vpc.vpc_id
  vpc_cidr          = module.vpc.vpc_cidr
  subnets           = module.vpc.public_subnets_ids

  services          = module.services.definitions
  public_api_prefix = local.public_api_prefix

  cdn_secret_header = local.alb_cdn_secret_header
  cdn_secret        = module.alb_cdn_secret.value
}

module "internal_alb" {
  source = "./modules/alb"

  name              = "discovery-alb"
  internal          = true

  vpc_id            = module.vpc.vpc_id
  vpc_cidr          = module.vpc.vpc_cidr
  subnets           = module.vpc.app_subnets_ids

  services          = module.services.definitions
  public_api_prefix = local.public_api_prefix
}

module "ecs" {
  source = "./modules/ecs"

  vpc_id                      = module.vpc.vpc_id
  vpc_cidr                    = module.vpc.vpc_cidr
  app_subnets                 = module.vpc.app_subnets_ids
  services                    = module.services.definitions
  service_images              = module.registry.service_images
  task_role_arn               = data.aws_iam_role.main.arn
  execution_role_arn          = data.aws_iam_role.main.arn
  logs_region                 = var.aws_region
  
  public_alb_target_groups    = module.public_alb.services_target_group
  internal_alb_target_groups  = module.internal_alb.services_target_group

  environment = [
    {name = "DB_USER",      value = var.db_user},
    {name = "DB_PASSWORD",  value = var.db_pass},
    {name = "DB_ADDRESS",   value = module.rds.db_address},
    {name = "DB_PORT",      value = local.db_port},
    {name = "DB_NAME",      value = local.db_name},
  ]
}

module "rds" {
  source = "./modules/rds"

  vpc_id      = module.vpc.vpc_id
  vpc_cidr    = module.vpc.vpc_cidr
  db_subnets  = module.vpc.db_subnets_ids
  db_name     = local.db_name
  db_user     = var.db_user
  db_pass     = var.db_pass
  db_port     = local.db_port
}

module "waf" {
  source = "./modules/waf"
}

module "cdn" {
  source = "./modules/cdn"

  frontend_OAI          = aws_cloudfront_origin_access_identity.cdn
  frontend_origin_id    = "frontend"
  frontend_domain_name  = module.static_site.domain_name

  api_origin_id         = "api"
  api_domain_name       = module.public_alb.main.dns_name
  api_path_pattern      = "${local.public_api_prefix}/*"

  aliases               = [var.app_domain, "*.${var.app_domain}"]
  certificate_arn       = module.certificate.arn

  alb_secret_header     = local.alb_cdn_secret_header
  alb_secret            = module.alb_cdn_secret.value

  waf_arn               = module.waf.arn
}

module "dns" {
  source = "./modules/dns"

  app_domain  = var.app_domain
  cdn         = module.cdn.distribution

  internal_vpc_domain = "private.cloud.com"
  vpc_id              = module.vpc.vpc_id
  services_alb        = module.internal_alb.main
  services_alb_domain = "services.private.cloud.com"
}
