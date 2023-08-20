terraform {
  required_version = ">= 1.0"

  required_providers {
    local = {
      source  = "hashicorp/local"
      version = "~> 2.4.0"
    }
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.13.1"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.23.0"
    }

    null = {
      source  = "hashicorp/null"
      version = "~> 3.2.1"
    }

    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.10.1"
    }
  }
}
