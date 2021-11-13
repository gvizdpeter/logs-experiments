locals {
  gryalog_beats_service_name   = "graylog-beats"
  beats_port                   = 5045
  elasticsearch_uri_secret_key = "uri"
  cluster_size                 = 3
  graylog_beats_services       = [for index in range(local.cluster_size) : "${local.gryalog_beats_service_name}-${index}"]
}