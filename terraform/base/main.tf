resource "helm_release" "vault" {
  name       = "vault"
  repository = "https://helm.releases.hashicorp.com"
  chart      = "vault"
  version    = "0.30.1"

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
