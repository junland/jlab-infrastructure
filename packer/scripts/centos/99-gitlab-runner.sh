#!/bin/bash

set -e

msg() {
  printf " --------------\n"
  printf ' >>>> %s\n' "$@"
  printf " --------------\n"
}

msg_info() {
  echo -e "\e[94m >>>> $1 \e[0m"
}

msg_fail() {
  echo -e "\e[31m >>>> $1 \e[0m"
  exit 1
}

[ "${EUID}" -eq "0" ] || msg_fail "$0: Script must be run via sudo or root user"

msg_info "Getting OS info..."

. /etc/os-release

msg "Running Gitlab runner installation..."

msg "Installing base requirments..."

dnf install -y wget curl

msg "Installing Gitlab runner..."

curl -L https://packages.gitlab.com/install/repositories/runner/gitlab-runner/script.rpm.sh > /tmp/script.rpm.sh

chmod +x /tmp/script.rpm.sh && os=el dist=7 /tmp/script.rpm.sh

dnf update -y && dnf install -y gitlab-runner

msg_info "Adding Docker group to gitlab-runner user..."

usermod -aG docker gitlab-runner

usermod -aG wheel gitlab-runner

msg "Clean up everything..."

dnf clean all -y

msg "Finished $0..."