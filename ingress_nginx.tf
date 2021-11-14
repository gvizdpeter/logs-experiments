module "ingress_nginx" {
  source             = "./modules/ingress-nginx"
  config_path        = local.eks_config_path
  ingress_class_name = local.ingress_class_name
  #  logstash_namespace    = module.logstash.logstash_namespace
  #  logstash_service_name = module.logstash.logstash_service_name
  #  logstash_beats_port   = module.logstash.beats_port
  #  graylog_beats_port    = module.graylog.beats_port
  #  graylog_namespace     = module.graylog.graylog_namespace
  #  graylog_service_name  = module.graylog.gryalog_beats_service_name
  namespace = "ingress-nginx"
}

data "aws_lb" "eks_ingress_lb" {
  tags = {
    name = "eks-ingress-lb"
  }
}
