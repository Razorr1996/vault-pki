#!/usr/bin/env bash

set -euo pipefail
# set -x # print cmd

KUBECTL="kubectl --context vault-pki --namespace vault"

$KUBECTL port-forward services/vault 8200:http
