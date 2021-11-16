module "prometheus" {
  source        = "./modules/prometheus"
  ingress_class = local.ingress_class_name
  namespace     = "prometheus"
  storage_class = module.efs.storage_class_name
  zone_id       = data.aws_route53_zone.primary.zone_id
  zone_name     = data.aws_route53_zone.primary.name
}