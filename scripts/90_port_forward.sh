#!/usr/bin/env bash

set -euo pipefail
# set -x # print cmd

KUBECTL="kubectl --context minikube --namespace vault"

$KUBECTL port-forward services/vault 8200:http
