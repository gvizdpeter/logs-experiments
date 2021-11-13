locals {
  graylog_beats_services = [for service_name in var.graylog_beats_services : "\"${service_name}.${var.graylog_namespace}:${var.graylog_beats_port}\""]
}