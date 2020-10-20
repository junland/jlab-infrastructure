#!/bin/bash

set -e

FAAS_CLI_VER=0.12.14
FAAS_D_VER=0.9.5
CNI_PLUGIN_VER=0.8.7

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

mkdir -vp /opt/cni/bin

curl -sSL https://github.com/containernetworking/plugins/releases/download/v${CNI_PLUGIN_VER}/cni-plugins-linux-amd64-v${CNI_PLUGIN_VER}.tgz | tar -xz -C /opt/cni/bin && ls -la /opt/cni/bin

curl -sSL https://github.com/openfaas/faas-cli/releases/download/${FAAS_CLI_VER}/faas-cli > /usr/local/bin/faas-cli 

chmod 777 /usr/local/bin/faas-cli

curl -sSL https://github.com/openfaas/faasd/releases/download/${FAAS_D_VER}/faasd > /usr/local/bin/faasd 

chmod 777 /usr/local/bin/faasd

msg "Clean up everything..."

dnf clean all -y

msg "Finished $0..."