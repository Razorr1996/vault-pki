resource "vault_auth_backend" "kubernetes" {
  type = "kubernetes"
}

resource "vault_kubernetes_auth_backend_config" "kubernetes" {
  backend         = vault_auth_backend.kubernetes.path
  kubernetes_host = "https://kubernetes.default:443"
}

resource "vault_policy" "pki" {
  name = "pki"

  # language=hcl
  policy = <<-EOF
    path "pki*" {
      capabilities = [
        "read",
        "list",
      ]
    }

    path "${vault_mount.test_org_v1_ica2_v1.path}/sign/${vault_pki_secret_backend_role.role.name}" {
      capabilities = [
        "create",
        "update",
      ]
    }

    path "${vault_mount.test_org_v1_ica2_v1.path}/issue/${vault_pki_secret_backend_role.role.name}" {
      capabilities = [
        "create",
      ]
    }
  EOF
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
