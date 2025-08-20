# Vault PKI playground
Build a certificate authority (CA) in Vault with an offline root.

Original doc from Hashicorp: https://developer.hashicorp.com/vault/tutorials/pki/pki-engine-external-ca

# Prerequisites

1. minikube
2. tgenv/terragrunt
3. tfenv/terraform
4. jq
5. vault

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
   vault write -format=json test-org/v1/ica2/v1/issue/test-dot-com-subdomain \
   common_name=1.test.com | jq .data.certificate -r | openssl x509 -in /dev/stdin -text -noout
   ```

# Cleanup

1. Delete generated vault secrets and certificates
   ```shell
   (
     cd terraform
     terragrunt run-all destroy -auto-approve
   )
   rm ./out/*
   minikube delete -p vault-pki
   docker network rm vault-pki
   ```
