provider "helm" {
  kubernetes {
    config_path    = var.config_path
    config_context = var.config_context
  }
}

provider "kubernetes" {
  config_path    = var.config_path
  config_context = var.config_context
}

provider "kubectl" {
  config_path    = var.config_path
  config_context = var.config_context
}
