#!/bin/bash

# Terraform
arch="amd64"
tf_version="$(
  curl "https://api.github.com/repos/hashicorp/terraform/releases/latest" \
  | jq -r '.name |= sub("^v"; "") | .name'
)"

eget "https://releases.hashicorp.com/terraform/${tf_version}/terraform_${tf_version}_linux_${arch}.zip" \
  --to "${HOME}/.local/bin/terraform"

# OpenTF (no releases yet on https://github.com/opentffoundation/opentf)
