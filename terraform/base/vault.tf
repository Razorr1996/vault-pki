locals {
  helm_vault_values = {
    injector = {
      enabled = false
    }
    server = {
      logLevel = "trace"
      affinity = ""
      ha = {
        enabled = true
        raft = {
          enabled   = true
          setNodeId = true
          config    = <<-EOF
            ui = true
            cluster_name = "vault-integrated-storage"
            storage "raft" {
               path    = "/vault/data/"
            }

            listener "tcp" {
               address = "[::]:8200"
               cluster_address = "[::]:8201"
               tls_disable = "true"
            }
            service_registration "kubernetes" {}
          EOF
        }
      }
    }
  }
}

resource "helm_release" "vault" {
  name       = "vault"
  repository = var.vault_chart_from_github ? null : "https://helm.releases.hashicorp.com"
  chart      = var.vault_chart_from_github ? "https://github.com/hashicorp/vault-helm/archive/refs/tags/v0.30.1.tar.gz" : "vault"
  version    = var.vault_chart_from_github ? null : "0.30.1"

  namespace        = "vault"
  create_namespace = true

  values = [
    yamlencode(local.helm_vault_values),
  ]
}
