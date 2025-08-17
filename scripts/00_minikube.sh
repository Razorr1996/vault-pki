#!/usr/bin/env bash

set -euo pipefail
# set -x # print cmd

minikube start

kubectl --context minikube create ns terraform
