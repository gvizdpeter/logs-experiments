resource "helm_release" "prometheus" {
  name             = "prometheus"
  repository       = "https://prometheus-community.github.io/helm-charts"
  chart            = "prometheus"
  version          = var.prometheus_chart_version
  namespace        = var.namespace
  create_namespace = true
  recreate_pods    = true

  values = [
    templatefile("${path.module}/helm-values/prometheus.yaml", {
      storage_class      = var.storage_class
      prometheus_host    = "${var.subdomain}.${var.zone_name}"
      ingress_class      = var.ingress_class
      storage_size_in_gi = 1
    })
  ]
}

resource "helm_release" "prometheus_adapter" {
  name          = "prometheus-adapter"
  repository    = "https://prometheus-community.github.io/helm-charts"
  chart         = "prometheus-adapter"
  version       = var.prometheus_adapter_chart_version
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

module "prometheus_cname_record" {
  source    = "../zone-cname-record"
  subdomain = var.subdomain
  zone_id   = var.zone_id
  zone_name = var.zone_name
}
