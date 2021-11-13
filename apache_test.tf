locals {
  apache_test_manifests_dir = "${path.module}/apache-test"
}

resource "kubernetes_namespace" "apache" {
  metadata {
    name = "apache"
  }
}

resource "kubectl_manifest" "apache_deployment" {
  yaml_body = file("${local.apache_test_manifests_dir}/apache-deployment.yaml")
  depends_on = [
    kubernetes_namespace.apache,
  ]
}

resource "kubectl_manifest" "apache_service" {
  yaml_body = file("${local.apache_test_manifests_dir}/apache-service.yaml")
  depends_on = [
    kubectl_manifest.apache_service,
  ]
}

resource "kubectl_manifest" "vegeta_deployment" {
  yaml_body = templatefile("${local.apache_test_manifests_dir}/vegeta-deployment.yaml", {
    stress_replicas = 1
  })
  depends_on = [
    kubectl_manifest.apache_service,
  ]
}