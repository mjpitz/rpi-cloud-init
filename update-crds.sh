#!/usr/bin/env bash

## == cert-manager ==##

readonly cert_manager_version=0.14.2

curl -sSL \
  https://github.com/jetstack/cert-manager/releases/download/v${cert_manager_version}/cert-manager.crds.yaml \
  -o k8s/workloads/cert-manager/cert-manager.crds.yaml
