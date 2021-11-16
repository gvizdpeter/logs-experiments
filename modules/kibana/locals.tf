locals {
  kibana_service = "kibana-kibana"
  kibana_port    = 5601
  kibana_host    = "${var.subdomain}.${var.zone_name}"
}