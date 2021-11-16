locals {
  gryalog_beats_service_name   = "graylog-beats"
  beats_port                   = 5045
  elasticsearch_uri_secret_key = "uri"
  graylog_beats_services       = [for index in range(var.graylog_replicas) : "${local.gryalog_beats_service_name}-${index}"]
  graylog_host                 = "${var.subdomain}.${var.zone_name}"
}