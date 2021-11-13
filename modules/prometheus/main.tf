resource "helm_release" "prometheus" {
  name             = "prometheus"
  repository       = "https://prometheus-community.github.io/helm-charts"
  chart            = "prometheus"
  version          = "14.11.0"
  namespace        = var.namespace
  create_namespace = true
  recreate_pods    = true

  values = [
    templatefile("${path.module}/helm-values/prometheus.yaml", {
      nfs_storage_class_name = var.nfs_storage_class
      prometheus_host        = var.prometheus_host
      ingress_class          = var.ingress_class
      storage_size_in_gb     = 1
    })
  ]
}

resource "helm_release" "prometheus_adapter" {
  name          = "prometheus-adapter"
  repository    = "https://prometheus-community.github.io/helm-charts"
  chart         = "prometheus-adapter"
  version       = "3.0.0"
  namespace     = helm_release.prometheus.namespace
  recreate_pods = true

  values = [
    templatefile("${path.module}/helm-values/prometheus-adapter.yaml", {
      prometheus_url  = "http://${local.prometheus_service}"
      prometheus_port = local.prometheus_port
    })
  ]

  depends_on = [
    helm_release.prometheus,
  ]
}