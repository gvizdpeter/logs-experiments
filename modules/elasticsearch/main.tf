resource "random_password" "elasticsearch_master_password" {
  length           = 16
  special          = true
  upper            = true
  lower            = true
  number           = true
  override_special = "-"
  keepers = {
    "username" = "master"
  }
}

resource "aws_secretsmanager_secret" "elasticsearch_master_user" {
  name = "elasticsearch/users/master"
}

resource "aws_secretsmanager_secret_version" "elasticsearch_master_user" {
  secret_id = aws_secretsmanager_secret.elasticsearch_master_user.id
  secret_string = jsonencode({
    username = random_password.elasticsearch_master_password.keepers["username"]
    password = random_password.elasticsearch_master_password.result
  })
}

resource "aws_elasticsearch_domain" "logs" {
  domain_name           = var.domain_name
  elasticsearch_version = var.elasticsearch_version

  cluster_config {
    dedicated_master_enabled = false
    warm_enabled             = false

    zone_awareness_enabled = true

    zone_awareness_config {
      availability_zone_count = 3
    }

    instance_count = var.instance_count
    instance_type  = var.instance_type
  }

  ebs_options {
    ebs_enabled = true
    volume_size = 10
  }

  advanced_security_options {
    enabled                        = true
    internal_user_database_enabled = true
    master_user_options {
      master_user_name     = random_password.elasticsearch_master_password.keepers["username"]
      master_user_password = random_password.elasticsearch_master_password.result
    }
  }

  encrypt_at_rest {
    enabled = true
  }

  node_to_node_encryption {
    enabled = true
  }

  domain_endpoint_options {
    enforce_https       = true
    tls_security_policy = "Policy-Min-TLS-1-2-2019-07"

    custom_endpoint_enabled         = true
    custom_endpoint_certificate_arn = var.acm_certificate_arn
    custom_endpoint                 = var.elasticsearch_host
  }

  tags = var.aws_tags
}

resource "aws_route53_record" "elasticsearch_cname_record" {
  zone_id = var.zone_id
  name    = var.elasticsearch_host
  type    = "CNAME"
  ttl     = "300"
  records = [aws_elasticsearch_domain.logs.endpoint]
}

resource "kubernetes_namespace" "elasticsearch_exporter" {
  metadata {
    name = "elasticsearch-exporter"
  }
}

resource "kubernetes_secret" "elasticsearch_exporter_master_user" {
  metadata {
    name      = "elasticsearch-master-user"
    namespace = kubernetes_namespace.elasticsearch_exporter.metadata[0].name
  }

  data = {
    ES_USERNAME = random_password.elasticsearch_master_password.keepers["username"]
    ES_PASSWORD = random_password.elasticsearch_master_password.result
  }
}

resource "helm_release" "elasticsearch_exporter" {
  name          = "elasticsearch-exporter"
  repository    = "https://prometheus-community.github.io/helm-charts"
  chart         = "prometheus-elasticsearch-exporter"
  version       = "4.7.0"
  namespace     = kubernetes_namespace.elasticsearch_exporter.metadata[0].name
  recreate_pods = true

  values = [
    templatefile("${path.module}/helm-values/elasticsearch-exporter.yaml", {
      elasticsearch_address            = aws_elasticsearch_domain.logs.endpoint
      elasticsearch_username           = random_password.elasticsearch_master_password.keepers["username"]
      elasticsearch_password           = random_password.elasticsearch_master_password.result
      elasticsearch_master_user_secret = kubernetes_secret.elasticsearch_exporter_master_user.metadata[0].name
    })
  ]
}
