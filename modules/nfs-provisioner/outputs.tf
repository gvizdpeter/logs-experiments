output "nfs_storage_class" {
  value = var.nfs_storage_class_name
  depends_on = [
    helm_release.nfs_provisioner,
  ]
}