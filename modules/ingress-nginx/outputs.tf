output "ingress_class" {
  value = var.ingress_class_name
  depends_on = [
    helm_release.ingress_nginx,
  ]
}