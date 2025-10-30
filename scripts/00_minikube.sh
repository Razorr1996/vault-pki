#!/usr/bin/env bash

set -euo pipefail

MINIKUBE_PROFILE=vault-pki

minikube start --profile="$MINIKUBE_PROFILE" --addons=metrics-server

kubectl --context "$MINIKUBE_PROFILE" create ns terraform
