#!/bin/bash

# RELEVANT LINKS AND INFORMATION

# https://kubernetes.io/docs/tasks/tools/install-kubectl-linux/
# https://github.com/kubernetes/kubernetes
# https://pkg.go.dev/k8s.io/kubernetes/pkg/kubectl

# https://unix.stackexchange.com/a/751330/49853
initArch() {
  ARCH=$(uname -m)
  case $ARCH in
    armv5*) ARCH="armv5";;
    armv6*) ARCH="armv6";;
    armv7*) ARCH="arm";;
    aarch64) ARCH="arm64";;
    x86) ARCH="386";;
    x86_64) ARCH="amd64";;
    i686) ARCH="386";;
    i386) ARCH="386";;
  esac
}

kubectl_version="$(
  curl "https://api.github.com/repos/kubernetes/kubernetes/releases" \
  | jq -r '.[].tag_name' \
  | sort -r \
  | gum choose
)"

initArch

eget "https://dl.k8s.io/release/${kubectl_version}/bin/linux/${ARCH}/kubectl" \
  --to "${HOME}/.local/bin/kubectl_${kubectl_version}"
