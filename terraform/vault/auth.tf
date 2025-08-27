resource "vault_auth_backend" "kubernetes" {
  type = "kubernetes"
}

resource "vault_kubernetes_auth_backend_config" "kubernetes" {
  backend         = vault_auth_backend.kubernetes.path
  kubernetes_host = "https://kubernetes.default:443"
}

resource "vault_policy" "pki" {
  name   = "pki"
  policy = file("${path.module}/config/pki-policy.hcl")
}

resource "vault_kubernetes_auth_backend_role" "cert_manager" {
  backend                          = vault_auth_backend.kubernetes.path
  role_name                        = "cert-manager"
  bound_service_account_names      = ["vault-issuer"]
  bound_service_account_namespaces = ["cert-manager"]
  audience                         = "vault://vault-issuer"

  token_policies = [
    vault_policy.pki.name,
  ]
}
