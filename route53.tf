resource "aws_route53_zone" "primary" {
  name  = var.domain
  count = var.create_domain ? 1 : 0
}

data "aws_route53_zone" "primary" {
  name         = var.domain
  private_zone = false
  depends_on = [
    aws_route53_zone.primary
  ]
}
