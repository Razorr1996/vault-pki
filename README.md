# Vault PKI playground

# Prerequisites

1. minikube
2. tgenv/terragrunt
3. tfenv/terraform
4. jq

## Installation

1. Initialize minikube
   ```shell
   ./scripts/00_minikube.sh
   ```

1. Apply base terraform:
   ```shell
   (
     cd terraform/base
     terragrunt apply
   )
   ```

1. Init vault:
   ```shell
   ./scripts/01_vault.sh
   ```

1. Run port-forwarding to vault in a separate terminal:
   ```shell
   ./scripts/90_port_forward.sh
   ```

1. Apply init vault configuration:
   ```shell
   (
     cd terraform/base
     terragrunt apply -var signed=false
   )
   ```

1. Generate Root CA and sign Intermediate CA1:
   ```shell
   ./scripts/02_certificates.sh
   ```

1. Apply the remaining vault terraform config:
   ```shell
   (
     cd terraform/base
     terragrunt apply
   )
   ```
