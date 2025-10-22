#!/bin/bash

# Q: Why do this on Linux?
# A: Devices like Steam Deck don't ship a go environment yet.

## A) https://pkg.go.dev/golang.org/x/tools/cmd/getgo#section-readme
#curl -LO get.golang.org/$(uname)/go_installer \
#&& chmod +x go_installer \
#&& ./go_installer --version $(curl https://go.dev/dl/?mode=json | jq -r '.[0].version') \
#&& rm go_installer
#cat ~/.bash_profile
#  export PATH=$PATH:${HOME}/.go/bin
#  export GOPATH=${HOME}/go
#  export PATH=$PATH:${HOME}/go/bin

# B) https://go.dev/doc/manage-install

# eget https://go.dev/dl/$(curl https://go.dev/dl/?mode=json | jq -r '.[0].version').linux-amd64.tar.gz --file go --to "${HOME}/.local/bin/go.d"
# export GOROOT="${HOME}/.local/bin/go.d"

# Prettier version of the commented out code from above, also using the typical
# directory structure.

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

go_version="$(
  curl "https://go.dev/dl/?mode=json" \
  | jq -r '.[0].version'
)"

eget "https://go.dev/dl/${go_version}.linux-${ARCH}.tar.gz" \
  --file 'go/*' --all --to "${HOME}/go"
# TODO: Make it permament by adding it to the respective shell configuration
# file.
export GOROOT="${HOME}/go"

# Links for A and B
ln -svf "${GOROOT}/bin/go" "${HOME}/.local/bin/go"
ln -svf "${GOROOT}/bin/gofmt" "${HOME}/.local/bin/gofmt"
