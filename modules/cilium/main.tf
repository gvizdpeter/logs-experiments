resource "helm_release" "cilium" {
  chart         = "cilium"
  repository    = "https://helm.cilium.io/"
  name          = "cilium"
  version       = var.chart_version
  recreate_pods = true
  namespace     = var.namespace

  values = [file("${path.module}/helm-values/cilium.yaml")]
}