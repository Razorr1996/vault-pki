variable "vault_chart_from_github" {
  description = "Use GitHub Release for Vault Helm Chart instead of helm.releases.hashicorp.com"
  type        = bool
  default     = true
}
