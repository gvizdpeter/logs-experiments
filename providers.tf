provider "helm" {
  kubernetes {
    config_path = local.eks_config_path
  }
}

provider "kubernetes" {
  config_path = local.eks_config_path
}

provider "kubectl" {
  config_path = local.eks_config_path
}

provider "aws" {
  # env var AWS_ACCESS_KEY_ID
  # env var AWS_SECRET_ACCESS_KEY
  # env var AWS_DEFAULT_REGION
}
