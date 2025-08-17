resource "helm_release" "vault" {
  name       = "vault"
  repository = "https://helm.releases.hashicorp.com"
  chart      = "vault"
  version = "0.30.1"

  namespace        = "vault"
  create_namespace = true

  values = [
    yamlencode(yamldecode(file("${path.module}/config/helm-vault-values.yaml"))),
  ]
}
