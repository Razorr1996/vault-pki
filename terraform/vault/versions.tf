locals {
  vault_cluster_keys = jsondecode(file("${path.module}/../../out/cluster-keys.json"))
}

terraform {
  required_providers {
    vault = {
      source  = "hashicorp/vault"
      version = ">=5.1"
    }
    local = {
      source  = "hashicorp/local"
      version = ">=2.5"
    }
  }
}

provider "vault" {
  token = local.vault_cluster_keys.root_token
  address = "http://localhost:8200"
}
