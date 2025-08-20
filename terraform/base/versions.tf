terraform {
  required_providers {
    helm = {
      source  = "hashicorp/helm"
      version = ">=3"
    }
  }
}

provider "helm" {
  kubernetes = {
    config_path    = "~/.kube/config"
    config_context = "vault-pki"
  }
}
