module "graylog" {
  source = "./modules/graylog"

  elasticsearch_address  = module.elasticsearch.elasticsearch_address
  elasticsearch_password = module.elasticsearch.elasticsearch_password
  elasticsearch_username = module.elasticsearch.elasticsearch_username
  ingress_class          = local.ingress_class_name
  namespace              = "graylog"
  storage_class          = "gp2"
  zone_id                = data.aws_route53_zone.primary.zone_id
  zone_name              = data.aws_route53_zone.primary.name
}

module "graylog_provisioning" {
  source           = "./modules/graylog-provisioning"
  beats_port       = module.graylog.beats_port
  graylog_host     = module.graylog.graylog_host
  graylog_username = module.graylog.graylog_root_username
  graylog_password = module.graylog.graylog_root_password
  graylog_replicas = module.graylog.graylog_replicas
}