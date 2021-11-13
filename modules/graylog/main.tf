resource "kubernetes_namespace" "graylog" {
  metadata {
    name = "graylog"
  }
}

resource "kubernetes_secret" "elasticsearch_uri" {
  metadata {
    name      = "elasticsearch-uri"
    namespace = kubernetes_namespace.graylog.metadata[0].name
  }
  data = {
    "${local.elasticsearch_uri_secret_key}" = "${var.elasticsearch_username}:${var.elasticsearch_password}@${var.elasticsearch_address}"
  }
}

resource "random_password" "graylog_root_password_secret" {
  length  = 64
  special = false
  upper   = true
  lower   = true
  number  = true
}

resource "random_password" "graylog_root_password" {
  length  = 16
  special = true
  upper   = true
  lower   = true
  number  = true
  keepers = {
    "username" = "admin"
  }
}

resource "aws_secretsmanager_secret" "graylog_admin_user" {
  name = "graylog/users/admin"
}

resource "aws_secretsmanager_secret_version" "graylog_admin_user" {
  secret_id = aws_secretsmanager_secret.graylog_admin_user.id
  secret_string = jsonencode({
    username = random_password.graylog_root_password.keepers["username"]
    password = random_password.graylog_root_password.result
  })
}

resource "kubernetes_secret" "graylog_root_password" {
  metadata {
    name      = "graylog-root-password"
    namespace = kubernetes_namespace.graylog.metadata[0].name
  }
  data = {
    "graylog-password-secret" = random_password.graylog_root_password_secret.result
    "graylog-password-sha2"   = sha256(random_password.graylog_root_password.result)
  }
}

resource "helm_release" "graylog" {
  name          = "graylog"
  repository    = "https://charts.kong-z.com"
  chart         = "graylog"
  version       = "1.8.10"
  namespace     = kubernetes_namespace.graylog.metadata[0].name
  recreate_pods = true
  timeout       = 600

  values = [
    templatefile("${path.module}/helm-values/graylog.yaml", {
      elasticsearch_address        = var.elasticsearch_address
      storage_size_gb              = 20
      nfs_storage_class            = var.nfs_storage_class
      beats_port                   = local.beats_port
      graylog_host                 = var.graylog_host
      ingress_class                = var.ingress_class
      elasticsearch_version        = "7"
      elasticsearch_uri_secret     = kubernetes_secret.elasticsearch_uri.metadata[0].name
      elasticsearch_uri_secret_key = local.elasticsearch_uri_secret_key
      root_username                = random_password.graylog_root_password.keepers["username"]
      graylog_root_password_secret = kubernetes_secret.graylog_root_password.metadata[0].name
      gryalog_beats_service_name   = local.gryalog_beats_service_name
      cluster_size                 = local.cluster_size
    })
  ]
}

resource "kubectl_manifest" "graylog_beats_service" {
  count = local.cluster_size

  yaml_body = templatefile("${path.module}/k8s-manifests/beats-service.yaml", {
    service_name = local.graylog_beats_services[count.index]
    namespace    = var.namespace
    beats_port   = local.beats_port
    index        = count.index
  })
  depends_on = [
    helm_release.graylog,
  ]
}