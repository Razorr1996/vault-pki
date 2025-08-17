locals {
  default_3y_in_sec   = 94608000
  default_1y_in_sec   = 31536000
  default_1hr_in_sec = 3600

  out_dir = "${path.module}/../../out"

  test_org_v1_ica1_v1_chain = var.signed ? join("\n",[
    for file in ["Intermediate_CA1_v1.crt", "Testing_Root.crt"] : file("${local.out_dir}/${file}")
  ]) : ""

  count_signed = var.signed ? 1 : 0
}

resource "vault_mount" "test_org_v1_ica1_v1" {
  path                      = "test-org/v1/ica1/v1"
  type                      = "pki"
  description               = "PKI engine hosting intermediate CA1 v1 for test org"
  default_lease_ttl_seconds = local.default_1hr_in_sec
  max_lease_ttl_seconds     = local.default_3y_in_sec
}

###

resource "vault_pki_secret_backend_intermediate_cert_request" "test_org_v1_ica1_v1" {
  depends_on   = [vault_mount.test_org_v1_ica1_v1]

  backend      = vault_mount.test_org_v1_ica1_v1.path
  type         = "internal"
  common_name  = "Intermediate CA1 v1 "
  key_type     = "rsa"
  key_bits     = "2048"
  ou           = "Test Org"
  organization = "Basa62"
  country      = "RS"
  locality     = "Company1"
  province     = "GB"
}

resource "local_file" "test_org_v1_ica1_v1_csr" {
  filename = "${local.out_dir}/Intermediate_CA1_v1.csr"
  content  = vault_pki_secret_backend_intermediate_cert_request.test_org_v1_ica1_v1.csr
}

resource "vault_pki_secret_backend_intermediate_set_signed" "test_org_v1_ica1_v1_signed_cert" {
  count = local.count_signed

  depends_on = [vault_mount.test_org_v1_ica1_v1]

  backend     = vault_mount.test_org_v1_ica1_v1.path
  certificate = local.test_org_v1_ica1_v1_chain
}

###
