resource "kubernetes_namespace" "logstash" {
  metadata {
    name = var.namespace
  }
}

resource "kubernetes_secret" "logstash_elasticsearch_master_user" {
  metadata {
    name      = "elasticsearch-master-user"
    namespace = kubernetes_namespace.logstash.metadata[0].name
  }

  data = {
    ELASTICSEARCH_USERNAME = var.elasticsearch_username
    ELASTICSEARCH_PASSWORD = var.elasticsearch_password
  }
}

resource "helm_release" "logstash" {
  name          = "logstash"
  repository    = "https://helm.elastic.co"
  chart         = "logstash"
  version       = var.chart_version
  namespace     = kubernetes_namespace.logstash.metadata[0].name
  recreate_pods = true

  values = [
    templatefile("${path.module}/helm-values/logstash.yaml", {
      elasticsearch_address            = var.elasticsearch_address
      elasticsearch_master_user_secret = kubernetes_secret.logstash_elasticsearch_master_user.metadata[0].name
      beats_port                       = local.beats_port
    })
  ]
}

module "logstash_cname_record" {
  source    = "../zone-cname-record"
  subdomain = var.subdomain
  zone_id   = var.zone_id
  zone_name = var.zone_name
}
