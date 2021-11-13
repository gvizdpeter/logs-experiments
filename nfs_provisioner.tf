module "nfs_provisioner" {
  source                 = "./modules/nfs-provisioner"
  config_context         = local.config_context
  config_path            = local.config_path
  namespace              = "nfs-provisioner"
  nfs_server_host        = "host.minikube.internal"
  nfs_server_path        = "/home/peter/minikube-nfs"
  nfs_storage_class_name = "nfs-client"
}