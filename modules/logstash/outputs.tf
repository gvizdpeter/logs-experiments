output "logstash_service_name" {
  value = local.logstash_service_name
  depends_on = [
    helm_release.logstash,
  ]
}

output "logstash_namespace" {
  value = helm_release.logstash.namespace
}

output "beats_port" {
  value = local.beats_port
  depends_on = [
    helm_release.logstash,
  ]
}