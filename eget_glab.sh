#!/bin/bash

# A GitLab CLI tool bringing GitLab to your command line
# License: MIT

# RELEVANT LINKS AND INFORMATION

# https://gitlab.com/gitlab-org/cli
# https://docs.gitlab.com/ee/api/releases/

# TODO: This function may not be required at all, feedback from Mac and ARM
# users required.
# https://unix.stackexchange.com/a/751330/49853
initArch() {
  ARCH=$(uname -m)
  case $ARCH in
    armv5*) ARCH="armv5";;
    armv6*) ARCH="armv6";;
    armv7*) ARCH="arm";;
    aarch64) ARCH="arm64";;
    x86) ARCH="386";;
    x86_64) ARCH="${ARCH}";;
    i686) ARCH="386";;
    i386) ARCH="386";;
  esac
}

glab_version="$(
  curl "https://gitlab.com/api/v4/projects/34675721/releases" \
  | jq -r '.[].tag_name' \
  | sort -r \
  | gum choose
)"

initArch

eget "https://gitlab.com/gitlab-org/cli/-/releases/${glab_version}/downloads/glab_${glab_version#v}_Linux_${ARCH}.tar.gz" \
  --file "glab" --to "${HOME}/.local/bin/"
