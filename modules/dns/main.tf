# Public
resource "aws_route53_record" "main" {
  zone_id = data.aws_route53_zone.main.zone_id
  name    = var.app_domain
  type    = "A"

  alias {
    name                   = var.cdn.domain_name
    zone_id                = var.cdn.hosted_zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "www" {
  zone_id = data.aws_route53_zone.main.zone_id
  name    = "www.${var.app_domain}"
  type    = "A"

  alias {
    name                   = aws_route53_record.main.name
    zone_id                = data.aws_route53_zone.main.id
    evaluate_target_health = false
  }
}

# Private
resource "aws_route53_zone" "private" {
  name = var.internal_vpc_domain

  vpc {
    vpc_id = var.vpc_id
  }
}

resource "aws_route53_record" "alb" {
  zone_id = aws_route53_zone.private.zone_id
  name    = var.services_alb_domain
  type    = "A"

  alias {
    name                   = var.services_alb.dns_name
    zone_id                = var.services_alb.zone_id
    evaluate_target_health = false
  }
}
