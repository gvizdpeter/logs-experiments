locals {
  domain             = "ragnarok-tech.eu"
  create_domain      = false
  config_path        = "~/.kube/config.minikube"
  eks_config_path    = local_file.kubeconfig.filename
  config_context     = "minikube"
  ingress_class_name = "nginx"
  aws_azs            = ["us-east-2a", "us-east-2b", "us-east-2c"]
  aws_tags = {
    project = "elk-stack"
  }
}
