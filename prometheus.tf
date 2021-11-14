module "prometheus" {
  source            = "./modules/prometheus"
  config_path       = local.eks_config_path
  ingress_class     = local.ingress_class_name
  namespace         = "prometheus"
  nfs_storage_class = "efs-sc"
  #nfs_storage_class = module.nfs_provisioner.nfs_storage_class
  prometheus_host = "prometheus.${local.domain}"
}