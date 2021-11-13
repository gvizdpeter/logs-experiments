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

module "wildcard_cert" {
  source  = "terraform-aws-modules/acm/aws"
  version = "~> 3.2.0"

  domain_name = data.aws_route53_zone.primary.name
  zone_id     = data.aws_route53_zone.primary.zone_id

  subject_alternative_names = [
    "*.${data.aws_route53_zone.primary.name}"
  ]

  wait_for_validation = true

  tags = local.aws_tags
}
