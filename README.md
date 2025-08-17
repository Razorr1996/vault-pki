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

2. Apply base terraform:
   ```shell
   (
     cd terraform/base
     terragrunt apply
   )
   ```

3. Init vault:
   ```shell
   ./scripts/01_vault.sh
   ```
