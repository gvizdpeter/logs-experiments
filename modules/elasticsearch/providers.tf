provider "helm" {
  kubernetes {
    config_path    = "/home/peter/k8s/terraform/kube/config"
    //config_context = var.config_context
  }
}

provider "kubernetes" {
  config_path    = "/home/peter/k8s/terraform/kube/config"
  //config_context = var.config_context
}
