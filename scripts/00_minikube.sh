#!/usr/bin/env bash

set -euo pipefail
# set -x # print cmd

minikube start -p vault-pki

kubectl --context vault-pki create ns terraform
