resource "helm_release" "ingress_nginx" {
  name             = "ingress-nginx"
  repository       = "https://kubernetes.github.io/ingress-nginx"
  chart            = "ingress-nginx"
  version          = var.chart_version
  namespace        = var.namespace
  create_namespace = true
  recreate_pods    = true

  values = [
    templatefile("${path.module}/helm-values/ingress-nginx.yaml", {
      ingess_class_name     = var.ingress_class_name
      logstash_namespace    = var.logstash_namespace
      logstash_service_name = var.logstash_service_name
      logstash_beats_port   = var.logstash_beats_port
      graylog_namespace     = var.graylog_namespace
      graylog_service_name  = var.graylog_service_name
      graylog_beats_port    = var.graylog_beats_port
      lb_name               = local.lb_name
      acm_certificate_arn   = var.acm_certificate_arn
    })
  ]
}

data "aws_lb" "eks_ingress_lb" {
  tags = {
    name = local.lb_name
  }
  depends_on = [
    helm_release.ingress_nginx,
  ]
}

resource "aws_route53_record" "wildcard_record_primary_zone" {
  zone_id = var.zone_id
  name    = var.zone_name
  type    = "A"

  alias {
    name                   = data.aws_lb.eks_ingress_lb.dns_name
    zone_id                = data.aws_lb.eks_ingress_lb.zone_id
    evaluate_target_health = true
  }
}