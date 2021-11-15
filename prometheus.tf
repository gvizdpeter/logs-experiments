module "prometheus" {
  source          = "./modules/prometheus"
  ingress_class   = local.ingress_class_name
  namespace       = "prometheus"
  storage_class   = module.efs.storage_class_name
  prometheus_host = "prometheus.${local.domain}"
}