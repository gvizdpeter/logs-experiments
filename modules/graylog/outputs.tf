output "gryalog_beats_service_name" {
  value = local.gryalog_beats_service_name
  depends_on = [
    helm_release.graylog,
  ]
}

output "graylog_beats_services" {
  value = local.graylog_beats_services
  depends_on = [
    helm_release.graylog,
  ]
}

output "graylog_namespace" {
  value = helm_release.graylog.namespace
}

output "beats_port" {
  value = local.beats_port
  depends_on = [
    helm_release.graylog,
  ]
}

output "graylog_host" {
  value = var.graylog_host
  depends_on = [
    helm_release.graylog,
  ]
}

output "graylog_root_username" {
  value = random_password.graylog_root_password.keepers["username"]
  depends_on = [
    helm_release.graylog,
  ]
}

output "graylog_root_password" {
  value = random_password.graylog_root_password.result
  depends_on = [
    helm_release.graylog,
  ]
}