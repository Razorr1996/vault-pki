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

1. Create and pre-configure minikube cluster:
   ```shell
   ./scripts/00_minikube.sh
   ```

1. Apply base terraform:
   ```shell
   TG_WORKING_DIR=terraform/base terragrunt apply -auto-approve
   ```

1. Init Vault:
   ```shell
   ./scripts/01_vault_init_unseal.sh
   ```

1. Run port-forwarding to Vault in a separate terminal:
   ```shell
   ./scripts/90_port_forward.sh
   ```

1. Apply init Vault configuration:
   ```shell
   TG_WORKING_DIR=terraform/vault terragrunt apply -auto-approve -var signed=false
   ```

1. Generate Root CA and sign `Intermediate CA1 v1` for Vault:
   ```shell
   ./scripts/02_certificates.sh
   ```

1. Apply the remaining Vault terraform config:
   ```shell
   TG_WORKING_DIR=terraform/vault terragrunt apply -auto-approve
   ```

1. Test signed certificate from Vault `Intermediate CA2 v1.1`:
   ```shell
   export VAULT_ADDR=http://localhost:8200
   export VAULT_TOKEN=$(./scripts/92_vault_root_token.sh)
   vault write -format=json pki/test-org/v1/ica2/v1/issue/test-dot-com-subdomain \
   common_name=1.test.com | jq .data.certificate -r | openssl x509 -in /dev/stdin -text -noout
   ```

1. Apply cert-manager ClusterIssuer configuration and test Certificate:
   ```shell
   TG_WORKING_DIR=terraform/cert-manager terragrunt apply -auto-approve
   ```

1. Wait and check Certificate:
   ```shell
   kubectl --context vault-pki -n default wait --for=condition=Ready=true cert/basa62-test-com
   CERTIFICATE=$(
     kubectl --context vault-pki -n default get secret basa62-test-com-tls -o jsonpath='{.data.tls\.crt}' | base64 -d;
     # kubectl --context vault-pki -n default get secret basa62-test-com-tls -o jsonpath='{.data.ca\.crt}' | base64 -d; # Maybe we don't need Root CA in server chain
   )
   KEY=$(kubectl --context vault-pki -n default get secret basa62-test-com-tls -o jsonpath='{.data.tls\.key}' | base64 -d)
   echo "$CERTIFICATE" | openssl storeutl -noout -text /dev/stdin
   echo "$CERTIFICATE" | openssl x509 -dates -noout -issuer -subject
   echo "$CERTIFICATE" | openssl x509 -modulus -noout | openssl md5
   echo "$KEY" | openssl rsa -modulus -noout | openssl md5
   ```
   > cert-manager intentionally avoids adding root certificates to `tls.crt`, because they are useless in a situation where TLS is being done securely. For more information, see [RFC 5246 section 7.4.2](https://datatracker.ietf.org/doc/html/rfc5246#section-7.4.2) which contains the following explanation:
   > > Because certificate validation requires that root keys be distributed independently, the self-signed certificate that specifies the root certificate authority MAY be omitted from the chain, under the assumption that the remote end must already possess it in order to validate it in any case.

# Continue after restart Vault pods

1. Run unseal:
   ```shell
   ./scripts/91_vault_unseal.sh
   ```


# Cleanup

1. Delete minikube cluster, generated Vault secrets and certificates:
   ```shell
   minikube delete -p vault-pki
   docker network rm vault-pki || true
   find ./terraform -type d -name .terraform -exec rm -rv {} \;
   rm -f ./out/*
   ```
