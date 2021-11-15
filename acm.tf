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
