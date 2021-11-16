module "filebeat" {
  source                 = "./modules/filebeat"
  logstash_namespace     = module.logstash.logstash_namespace
  logstash_service_name  = module.logstash.logstash_service_name
  logstash_beats_port    = module.logstash.beats_port
  namespace              = "filebeat"
  graylog_beats_port     = module.graylog.beats_port
  graylog_namespace      = module.graylog.graylog_namespace
  graylog_beats_services = module.graylog.graylog_beats_services

  depends_on = [
    module.graylog_provisioning,
  ]
}

module "elasticsearch" {
  source                   = "./modules/elasticsearch"
  aws_tags                 = local.aws_tags
  domain_name              = "logs"
  vpc_id                   = module.primary_vpc.vpc_id
  subnets                  = module.primary_vpc.private_subnets
  client_security_group_id = module.eks.cluster_primary_security_group_id
  aws_region               = data.aws_region.current.name
  account_id               = data.aws_caller_identity.current.account_id
}

module "logstash" {
  source                 = "./modules/logstash"
  elasticsearch_address  = module.elasticsearch.elasticsearch_address
  elasticsearch_username = module.elasticsearch.elasticsearch_username
  elasticsearch_password = module.elasticsearch.elasticsearch_password
  namespace              = "logstash"
  zone_id                = data.aws_route53_zone.primary.zone_id
  zone_name              = data.aws_route53_zone.primary.name
}

module "kibana" {
  source = "./modules/kibana"

  ingress_class          = module.ingress_nginx.ingress_class
  elasticsearch_address  = module.elasticsearch.elasticsearch_address
  elasticsearch_username = module.elasticsearch.elasticsearch_username
  elasticsearch_password = module.elasticsearch.elasticsearch_password
  namespace              = "kibana"
  zone_id                = data.aws_route53_zone.primary.zone_id
  zone_name              = data.aws_route53_zone.primary.name
}