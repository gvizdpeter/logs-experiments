output "kibana_url" {
  value = "http://${var.kibana_host}"
  depends_on = [
    kubectl_manifest.kibana_ingress,
  ]
}