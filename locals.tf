locals {
  domain             = "ragnarok-tech.eu"
  create_domain      = false
  eks_config_path    = local_file.kubeconfig.filename
  ingress_class_name = "nginx"
  eks_name           = "elk"
  aws_azs            = ["us-east-2a", "us-east-2b", "us-east-2c"]
  aws_tags = {
    project = "elk-stack"
  }
}
