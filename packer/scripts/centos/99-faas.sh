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

msg "Running FaaS installation..."

msg "Installing base requirments..."

dnf install -y wget curl git containerd

msg "Installing FaaS project..."

"mkdir -p /opt/cni/bin",

curl -sSL https://github.com/containernetworking/plugins/releases/download/v0.8.7/cni-plugins-linux-amd64-v0.8.7.tgz | tar -xz -C /opt/cni/bin && ls -la /opt/cni/bin

curl -sSL https://github.com/openfaas/faas-cli/releases/download/0.12.13/faas-cli > /usr/local/bin/faas-cli 

chmod 777 /usr/local/bin/faas-cli

curl -sSL https://github.com/openfaas/faasd/releases/download/0.9.5/faasd > /usr/local/bin/faasd 

chmod 777 /usr/local/bin/faasd

msg "Clean up everything..."

dnf clean all -y

msg "Finished $0..."