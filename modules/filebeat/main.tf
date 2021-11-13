resource "helm_release" "filebeat" {
  name             = "filebeat"
  repository       = "https://helm.elastic.co"
  chart            = "filebeat"
  version          = "7.10.2"
  namespace        = var.namespace
  recreate_pods    = true
  create_namespace = true

  values = [
    templatefile("${path.module}/helm-values/filebeat.yaml", {
      logstash_beats_address  = "${var.logstash_service_name}.${var.logstash_namespace}:${var.logstash_beats_port}"
      graylog_beats_addresses = join(", ", local.graylog_beats_services)
    })
  ]
}