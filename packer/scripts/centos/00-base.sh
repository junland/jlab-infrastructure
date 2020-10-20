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

msg "Running base system installation..."

msg "Update system..."

dnf update -y

msg "Installing epel-release..."

dnf install -y epel-release && dnf update -y

msg "Installing basic packages..."

dnf install -y wget htop nmon

msg "Installing Docker..."

yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo -y && dnf update -y

dnf install -y docker-ce docker-ce-cli

systemctl enable docker && systemctl start docker

groupadd docker || true

msg "Disable swap..."

sed -i '/swap/d' /etc/fstab

msg "Clean up everything..."

dnf clean all -y

msg "Finished $0..."