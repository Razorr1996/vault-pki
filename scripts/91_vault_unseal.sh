#!/usr/bin/env bash

set -euo pipefail
# set -x # print cmd

export SCRIPT_DIR="$(cd -- "$(dirname -- "$( readlink -f -- "$0"; )")" &> /dev/null && pwd )"
export OUT_DIR="$(cd -- "${SCRIPT_DIR}/../out" &> /dev/null && pwd )"

KUBECTL="kubectl --context vault-pki --namespace vault"

CLUSTER_KEYS_JSON="$OUT_DIR/cluster-keys.json"

$KUBECTL wait --for=jsonpath='{.status.phase}'=Running pod/vault-0
$KUBECTL wait --for=jsonpath='{.status.phase}'=Running pod/vault-1
$KUBECTL wait --for=jsonpath='{.status.phase}'=Running pod/vault-2

VAULT_UNSEAL_KEY=$(jq -r ".unseal_keys_b64[]" "$CLUSTER_KEYS_JSON")

$KUBECTL exec vault-0 -- vault operator unseal "$VAULT_UNSEAL_KEY"
$KUBECTL exec vault-1 -- vault operator unseal "$VAULT_UNSEAL_KEY"
$KUBECTL exec vault-2 -- vault operator unseal "$VAULT_UNSEAL_KEY"
