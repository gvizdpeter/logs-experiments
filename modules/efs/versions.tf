terraform {
  required_providers {
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.3.0"
    }
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.64.0"
    }
  }
}