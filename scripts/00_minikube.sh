#!/usr/bin/env bash

set -euo pipefail
# set -x # print cmd

source ./.common.sh

minikube start

kubectl --context minikube create ns terraform
kubectl --context minikube patch storageclass csi-hostpath-sc -p '{"metadata": {"annotations":{"storageclass.kubernetes.io/is-default-class":"true"}}}'