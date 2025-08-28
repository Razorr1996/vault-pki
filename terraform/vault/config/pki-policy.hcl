path "pki*" {
  capabilities = [
    "read",
    "list",
  ]
}

path "pki/test-org/v1/ica2/v1/sign/test-dot-com-subdomain" {
  capabilities = [
    "create",
    "update",
  ]
}

path "pki/test-org/v1/ica2/v1/issue/test-dot-com-subdomain" {
  capabilities = [
    "create",
  ]
}
