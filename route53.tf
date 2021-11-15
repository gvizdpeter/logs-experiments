resource "aws_route53_zone" "primary" {
  name  = local.domain
  count = local.create_domain ? 1 : 0
}

data "aws_route53_zone" "primary" {
  name         = local.domain
  private_zone = false
  depends_on = [
    aws_route53_zone.primary
  ]
}
