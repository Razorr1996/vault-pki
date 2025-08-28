#!/usr/bin/env bash

set -euo pipefail
# set -x # print cmd

export SCRIPT_DIR="$(cd -- "$(dirname -- "$( readlink -f -- "$0"; )")" &> /dev/null && pwd )"
export OUT_DIR="$(cd -- "${SCRIPT_DIR}/../out" &> /dev/null && pwd )"

KUBECTL="kubectl --context vault-pki --namespace vault"

CLUSTER_KEYS_JSON="$OUT_DIR/cluster-keys.json"

jq -r ".root_token" "$CLUSTER_KEYS_JSON"
