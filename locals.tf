locals {
  domain             = "ragnarok-tech.eu"
  create_domain      = false
  config_path        = "~/.kube/config"
  config_context     = "minikube"
  ingress_class_name = "nginx"
  aws_tags = {
    project = "elk-stack"
  }
}
