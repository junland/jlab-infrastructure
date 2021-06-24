#!/bin/bash

set -e

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

msg_info "Installing and setting up k3s..."

curl -sfL https://get.k3s.io | sh -

systemctl disable k3s

msg_info "Finished $0..."