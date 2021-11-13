module "filebeat" {
  source                 = "./modules/filebeat"
  config_context         = local.config_context
  config_path            = local.config_path
  logstash_namespace     = module.logstash.logstash_namespace
  logstash_service_name  = module.logstash.logstash_service_name
  logstash_beats_port    = module.logstash.beats_port
  namespace              = "filebeat"
  graylog_beats_port     = module.graylog.beats_port
  graylog_namespace      = module.graylog.graylog_namespace
  graylog_beats_services = module.graylog.graylog_beats_services
}

module "elasticsearch" {
  source              = "./modules/elasticsearch"
  acm_certificate_arn = module.wildcard_cert.acm_certificate_arn
  aws_tags            = local.aws_tags
  domain_name         = "logs"
  elasticsearch_host  = "elastic.${local.domain}"
  zone_id             = data.aws_route53_zone.primary.zone_id
  config_context      = local.config_context
  config_path         = local.config_path
}

module "logstash" {
  source                 = "./modules/logstash"
  config_context         = local.config_context
  config_path            = local.config_path
  elasticsearch_address  = module.elasticsearch.elasticsearch_address
  elasticsearch_username = module.elasticsearch.elasticsearch_username
  elasticsearch_password = module.elasticsearch.elasticsearch_password
  namespace              = "logstash"
}

module "kibana" {
  source = "./modules/kibana"

  kibana_host            = "kibana.${local.domain}"
  ingress_class          = module.ingress_nginx.ingress_class
  elasticsearch_address  = module.elasticsearch.elasticsearch_address
  elasticsearch_username = module.elasticsearch.elasticsearch_username
  elasticsearch_password = module.elasticsearch.elasticsearch_password
  namespace              = "kibana"
  config_path            = local.config_path
  config_context         = local.config_context
}