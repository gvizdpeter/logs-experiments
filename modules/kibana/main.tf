resource "kubernetes_namespace" "kibana" {
  metadata {
    name = var.namespace
  }
}

resource "kubernetes_secret" "kibana_elasticsearch_master_user" {
  metadata {
    name      = "elasticsearch-master-user"
    namespace = kubernetes_namespace.kibana.metadata[0].name
  }

  data = {
    ELASTICSEARCH_USERNAME = var.elasticsearch_username
    ELASTICSEARCH_PASSWORD = var.elasticsearch_password
  }
}

resource "helm_release" "kibana" {
  name          = "kibana"
  repository    = "https://helm.elastic.co"
  chart         = "kibana"
  version       = var.chart_version
  namespace     = kubernetes_namespace.kibana.metadata[0].name
  recreate_pods = true

  values = [
    templatefile("${path.module}/helm-values/kibana.yaml", {
      elasticsearch_address            = var.elasticsearch_address
      elasticsearch_master_user_secret = kubernetes_secret.kibana_elasticsearch_master_user.metadata[0].name
    })
  ]
}

resource "kubectl_manifest" "kibana_ingress" {
  yaml_body = templatefile("${path.module}/k8s-manifests/ingress.yaml", {
    ingress_class  = var.ingress_class
    namespace      = kubernetes_namespace.kibana.metadata[0].name
    kibana_host    = var.kibana_host
    kibana_service = local.kibana_service
    kibana_port    = local.kibana_port
  })
  depends_on = [
    helm_release.kibana,
  ]
}
