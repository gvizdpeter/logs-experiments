locals {
  eks_config_path    = local_file.kubeconfig.filename
  ingress_class_name = "nginx"
  eks_name           = "elk"
  aws_tags = {
    project = "elk-stack"
  }
}
