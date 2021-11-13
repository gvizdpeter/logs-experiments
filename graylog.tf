module "graylog" {
  source = "./modules/graylog"

  config_context         = local.config_context
  config_path            = local.config_path
  elasticsearch_address  = module.elasticsearch.elasticsearch_address
  elasticsearch_password = module.elasticsearch.elasticsearch_password
  elasticsearch_username = module.elasticsearch.elasticsearch_username
  graylog_host           = "graylog.${local.domain}"
  ingress_class          = local.ingress_class_name
  namespace              = "graylog"
  nfs_storage_class      = module.nfs_provisioner.nfs_storage_class
}

module "graylog_provisioning" {
  source           = "./modules/graylog-provisioning"
  beats_port       = module.graylog.beats_port
  graylog_host     = module.graylog.graylog_host
  graylog_username = module.graylog.graylog_root_username
  graylog_password = module.graylog.graylog_root_password
}