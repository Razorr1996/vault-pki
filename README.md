# Vault PKI playground
Use cert-manager and Vault Issuer in Kubernetes with an offline root CA.

Docs:
- [Build a certificate authority (CA) in Vault with an offline root](https://developer.hashicorp.com/vault/tutorials/pki/pki-engine-external-ca)
- [Configure Vault as a certificate manager in Kubernetes with Helm](https://developer.hashicorp.com/vault/tutorials/archive/kubernetes-cert-manager)
- [cert-manager Vault Kubernetes auth](https://cert-manager.io/docs/configuration/vault/#option-2-vault-authentication-method-use-kubernetes-auth)

# Prerequisites

1. [minikube](https://minikube.sigs.k8s.io/docs/start/)
2. [tenv](https://github.com/tofuutils/tenv?tab=readme-ov-file#automatic-installation) / terragrunt + opentofu
4. [jq](https://jqlang.org/download/)
5. [certstrap](https://formulae.brew.sh/formula/certstrap)
6. [vault](https://developer.hashicorp.com/vault/tutorials/get-started/install-binary#install-vault) (optional for local testing requests)

## Installation

1. Initialize minikube
   ```shell
   ./scripts/00_minikube.sh
   ```

1. Apply base terraform:
   ```shell
   (
     cd terraform/base
     terragrunt apply -auto-approve
   )
   ```

1. Init Vault:
   ```shell
   ./scripts/01_vault.sh
   ```

1. Run port-forwarding to Vault in a separate terminal:
   ```shell
   ./scripts/90_port_forward.sh
   ```

1. Apply init Vault configuration:
   ```shell
   (
     cd terraform/vault
     terragrunt apply -auto-approve -var signed=false
   )
   ```

1. Generate Root CA and sign `Intermediate CA1 v1` for Vault:
   ```shell
   ./scripts/02_certificates.sh
   ```

1. Apply the remaining Vault terraform config:
   ```shell
   (
     cd terraform/vault
     terragrunt apply -auto-approve
   )
   ```

1. Test signed certificate from Vault `Intermediate CA2 v1.1`:
   ```shell
   export VAULT_ADDR=http://localhost:8200
   export VAULT_TOKEN=$(cat out/cluster-keys.json | jq -r ".root_token")
   vault write -format=json pki/test-org/v1/ica2/v1/issue/test-dot-com-subdomain \
   common_name=1.test.com | jq .data.certificate -r | openssl x509 -in /dev/stdin -text -noout
   ```

# Continue after restart Vault pods

1. Run unseal:
   ```shell
   ./scripts/91_vault_unseal.sh
   ```


# Cleanup

1. Delete generated Vault secrets and certificates
   ```shell
   minikube delete -p vault-pki
   docker network rm vault-pki || true
   find ./terraform -type d -name .terraform -exec rm -rv {} \;
   rm -f ./out/*
   ```
