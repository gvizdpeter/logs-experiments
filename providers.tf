provider "helm" {
  kubernetes {
    config_path    = local.config_path
    config_context = local.config_context
  }
}

provider "kubernetes" {
  config_path    = local.config_path
  config_context = local.config_context
}

provider "kubectl" {
  config_path    = local.config_path
  config_context = local.config_context
}

provider "aws" {
  # env var AWS_ACCESS_KEY_ID
  # env var AWS_SECRET_ACCESS_KEY
  # env var AWS_DEFAULT_REGION
}
