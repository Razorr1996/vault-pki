resource "helm_release" "vault" {
  name       = "vault"
  repository = var.vault_chart_from_github ? null : "https://helm.releases.hashicorp.com"
  chart      = var.vault_chart_from_github ? "https://github.com/hashicorp/vault-helm/archive/refs/tags/v0.30.1.tar.gz" : "vault"
  version    = var.vault_chart_from_github ? null : "0.30.1"

  namespace        = "vault"
  create_namespace = true

  values = [
    yamlencode(yamldecode(file("${path.module}/config/helm-vault-values.yaml"))),
  ]
}

resource "helm_release" "cert_manager" {
  name       = "cert-manager"
  repository = "oci://quay.io/jetstack/charts"
  chart      = "cert-manager"
  version    = "v1.18.2"

  namespace        = "cert-manager"
  create_namespace = true

  values = [
    yamlencode(yamldecode(file("${path.module}/config/helm-cert-manager-values.yaml"))),
  ]
}
