#!/usr/bin/env bash

set -euo pipefail
# set -x # print cmd

KUBECTL="kubectl --context minikube --namespace vault"

$KUBECTL exec vault-0 -- vault operator unseal "$VAULT_UNSEAL_KEY"
