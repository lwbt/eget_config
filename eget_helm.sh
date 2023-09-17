#!/bin/bash

# The Kubernetes Package Manager
# License: Apache-2.0

# RELEVANT LINKS AND INFORMATION

# Only hashes: https://github.com/helm/helm

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

helm_version="$(
  curl "https://api.github.com/repos/helm/helm/releases" \
  | jq -r '.[].tag_name' \
  | sort -r \
  | gum choose
)"

initArch

eget "https://get.helm.sh/helm-${helm_version}-linux-${ARCH}.tar.gz" \
  --file "helm" --to "${HOME}/.local/bin/"
