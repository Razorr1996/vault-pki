generate "backend" {
  path      = "backend.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
terraform {
  backend "kubernetes" {
    secret_suffix  = "${path_relative_to_include()}"
    config_path    = "~/.kube/config"
    config_context = "vault-pki"
    namespace      = "terraform"
  }
}
EOF
}
