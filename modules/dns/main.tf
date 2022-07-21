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

resource "aws_route53_record" "private_aliases" {
  for_each = { for alias_def in var.private_aliases : alias_def.sub_domain => alias_def }

  zone_id = aws_route53_zone.private.zone_id
  name    = "${each.value.sub_domain}.${aws_route53_zone.private.name}"
  type    = "A"

  alias {
    name                   = each.value.domain
    zone_id                = each.value.zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "private_cnames" {
  for_each = { for alias_def in var.private_cnames : alias_def.sub_domain => alias_def }

  zone_id = aws_route53_zone.private.zone_id
  name    = "${each.value.sub_domain}.${aws_route53_zone.private.name}"
  type    = "CNAME"
  ttl     = "60"
  records = [each.value.domain]
}

