resource "helm_release" "ingress_nginx" {
  name             = "ingress-nginx"
  repository       = "https://kubernetes.github.io/ingress-nginx"
  chart            = "ingress-nginx"
  version          = "4.0.3"
  namespace        = var.namespace
  create_namespace = true
  recreate_pods    = true

  values = [
    templatefile("${path.module}/helm-values/ingress-nginx.yamlx", {
      ingess_class_name     = var.ingress_class_name
      /*logstash_namespace    = var.logstash_namespace
      logstash_service_name = var.logstash_service_name
      logstash_beats_port   = var.logstash_beats_port
      graylog_namespace     = var.graylog_namespace
      graylog_service_name  = var.graylog_service_name
      graylog_beats_port    = var.graylog_beats_port*/
    })
  ]
}