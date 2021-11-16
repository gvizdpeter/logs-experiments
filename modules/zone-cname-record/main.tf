resource "aws_route53_record" "host_cname_record" {
  zone_id = var.zone_id
  name    = "${var.subdomain}.${var.zone_name}"
  type    = "CNAME"
  ttl     = var.ttl
  records = [var.zone_name]
}