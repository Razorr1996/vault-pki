path "pki*" {
  capabilities = [
    "read",
    "list",
  ]
}

path "pki/test-org/v1/ica2/v*/sign/example-dot-com" {
  capabilities = [
    "create",
    "update",
  ]
}

path "pki/test-org/v1/ica2/v*/issue/example-dot-com" {
  capabilities = [
    "create",
  ]
}
