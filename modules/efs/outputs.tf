output "storage_class_name" {
  value = var.storage_class_name
  depends_on = [
    helm_release.aws_efs_csi_driver,
  ]
}