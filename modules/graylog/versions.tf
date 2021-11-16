terraform {
  required_providers {
    random = {
      source  = "hashicorp/random"
      version = "~> 3.1.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.3.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.5.0"
    }
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = "~> 1.13.0"
    }
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.64.0"
    }
  }
}