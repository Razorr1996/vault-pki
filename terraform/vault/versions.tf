locals {
  vault_cluster_keys = jsondecode(file("${path.module}/../../out/cluster-keys.json"))
}

terraform {
  required_version = ">= 1.10"

  required_providers {
    vault = {
      source  = "hashicorp/vault"
      version = ">= 5.2.1"
    }
    local = {
      source  = "hashicorp/local"
      version = ">= 2.5.3"
    }
  }
}

provider "vault" {
  token   = local.vault_cluster_keys.root_token
  address = "http://localhost:8200"
}
