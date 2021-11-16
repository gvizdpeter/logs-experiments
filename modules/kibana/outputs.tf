output "kibana_url" {
  value = "http://${local.kibana_host}"
  depends_on = [
    kubectl_manifest.kibana_ingress,
  ]
}