locals {
  helm_cert_manager_values = {
    crds = {
      enabled = true
    }
  }
}

resource "helm_release" "cert_manager" {
  name       = "cert-manager"
  repository = "oci://quay.io/jetstack/charts"
  chart      = "cert-manager"
  version    = "v1.18.2"

  namespace        = "cert-manager"
  create_namespace = true

  values = [
    yamlencode(local.helm_cert_manager_values),
  ]
}
