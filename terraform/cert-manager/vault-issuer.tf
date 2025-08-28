locals {
  namespace   = "cert-manager"
  issuer_name = "vault-issuer"
}

resource "kubernetes_service_account_v1" "vault_issuer" {
  metadata {
    namespace = local.namespace
    name      = local.issuer_name
  }
}

resource "kubernetes_manifest" "cluster_issuer_vault_issuer" {
  manifest = {
    apiVersion = "cert-manager.io/v1"
    kind       = "ClusterIssuer"
    metadata = {
      name = local.issuer_name
    }
    spec = {
      vault = {
        server = "http://vault.vault:8200"
        path   = "pki/test-org/v1/ica2/v1/sign/test-dot-com-subdomain"
        auth = {
          kubernetes = {
            role = "cert-manager"
            serviceAccountRef = {
              name = kubernetes_service_account_v1.vault_issuer.metadata[0].name
            }
          }
        }
      }
    }
  }
}

# Allow SA "cert-manager" to request tokens for any ServiceAccount in the cert-manager namespace
resource "kubernetes_role_v1" "allow_sa_token_requests" {
  metadata {
    name      = "allow-sa-token-requests"
    namespace = local.namespace
  }

  rule {
    api_groups = [""]
    resources  = ["serviceaccounts/token"]
    verbs      = ["create"]
  }
}

resource "kubernetes_role_binding_v1" "allow_sa_token_requests_cert_manager" {
  metadata {
    name      = "allow-sa-token-requests-cert-manager"
    namespace = local.namespace
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "Role"
    name      = kubernetes_role_v1.allow_sa_token_requests.metadata[0].name
  }

  subject {
    kind      = "ServiceAccount"
    name      = "cert-manager"
    namespace = local.namespace
  }
}

# Certificate

resource "kubernetes_manifest" "certificate" {
  manifest = {
    apiVersion = "cert-manager.io/v1"
    kind = "Certificate"
    metadata = {
      name = "basa62-test-com"
      namespace = "default"
    }
    spec = {
      secretName = "basa62-test-com-tls"
      issuerRef = {
        kind = "ClusterIssuer"
        name = "vault-issuer"
      }
      commonName = "basa62.test.com"
      dnsNames = [
        "basa62.test.com",
        "*.basa62.test.com",
      ]
    }
  }
}
