#!/bin/bash

# This is some example code how to use eget with different configuration files
# and scripts.
#
# Requirements: gum

gum_style_a() {
  gum style --foreground 212 "$*"
}

# Because of mapfile.
if ((BASH_VERSINFO[0] < 4)); then
  echo "Sorry, you need bash 4.0 or newer to run this script."
  exit 1
fi

select_task() {
  mapfile -t selection < <(
    find "${PWD}" -iname "eget_*.toml" -o -iname "eget_*.sh" \
      | sort \
      | gum choose --no-limit --height=25
  )

  for file in "${selection[@]}"; do
    case "${file}" in
      *"/eget_"*".toml")
        gum_style_a "Eget config: ${file}"
        EGET_CONFIG="${file}" eget --download-all
        ;;
      *"/eget_"*".sh")
        gum_style_a "Eget script: ${file}"
        # TODO: re-enable
        #bash "${file}"
        ;;
    esac
  done
}

eget_select_tasks_to_activate() {
  # TODO: Write a better "update" kind of function instead of simply deleting
  # the entire state. Requires a bit of re-evaluating functions I wrote for
  # comparing content.

  # Delete and at the same time show the previous state, if any.
  rm -Rv "${PWD}/active.d"

  mkdir -pv "${PWD}/active.d"

  echo -e "\nChoose which tasks should be activated for eget."
  mapfile -t selection < <(
    find "${PWD}" -iname "eget_*.toml" -o -iname "eget_*.sh" \
      | sed -e "s|${PWD}/||g" \
      | sort \
      | gum choose --no-limit --height=25
  )

  # TODO: stop if no selection (if .. fi)
  for file in "${selection[@]}"; do
    ln -sv "../${file}" "${PWD}/active.d/${file}"
  done

  echo
  eget_run_active_tasks
}

eget_run_active_tasks() {
  mapfile -t selection < <(
    find "${PWD}/active.d" -iname "eget_*.toml" -o -iname "eget_*.sh" \
      | sort
  )

  # TODO: stop if no selection (if .. fi)
  gum_style_a "The following eget tasks are activated:"
  echo
  printf '%s\n' "${selection[@]}"

  if gum confirm --default=false --affirmative="Yes, run active tasks!" \
    "Do you want to run these tasks?"; then

    for file in "${selection[@]}"; do
      echo

      case "${file}" in
        *"/eget_"*".toml")
          gum_style_a "Eget config: ${file}"
          # TODO: re-enable
          #EGET_CONFIG="${file}" eget --download-all ;;
          ;;
        *"/eget_"*".sh")
          gum_style_a "Eget script: ${file}"
          # TODO: re-enable
          #bash "${file}"
          ;;
      esac
    done
  fi
}

eget_setup_configuration() {

  if ! gum confirm --default=false --affirmative="Yes, create!" \
    "No eget configuration directory found, do you want to create it?"; then
    exit 1
  fi

  echo -e "\nConfiguring eget with an existing configuration repository in 2 steps.\n"

  eget_gh_user="$(
    gum input \
      --header "1. Name of the user on GitHub with an existing eget configuration:" \
      --placeholder "github_user"
  )"

  echo "eget_gh_user: $(gum_style_a "${eget_gh_user}")"

  eget_gh_repo="$(
    gum input \
      --header "2. Name of the GitHub repository with an existing eget configuration:" \
      --value "eget_config"
  )"
  local eget_gh_repo
  local eget_gh_user

  echo "eget_gh_repo: $(gum_style_a "${eget_gh_repo}")"

  if [[ -n "${eget_gh_user}" && -n "${eget_gh_repo}" ]]; then
    git clone "https://github.com/${eget_gh_user}/${eget_gh_repo}.git" \
      "${eget_repo_destination}"
  else
    # TODO: descriptive error message
    exit 1
  fi
}

eget_repo_destination="$HOME/.config/eget_config"
[[ ! -d "${eget_repo_destination}" ]] && eget_setup_configuration

eget_select_tasks_to_activate

eget_run_active_tasks
