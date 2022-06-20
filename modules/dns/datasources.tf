# Public. 
# No lo manejamos desde terraform para que sea sencillo de cablear los NS con el DNS padre.
data "aws_route53_zone" "main" {
  name = var.app_domain
}
