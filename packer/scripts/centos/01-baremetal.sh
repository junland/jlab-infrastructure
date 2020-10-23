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

msg_info "Running base system installation for bare metal systems..."

msg_info "Update system..."

dnf update -y

msg_info "Installing epel-release and yum utilities..."

dnf install -y epel-release yum-utils && dnf update -y

msg_info "Installing basic packages..."

dnf install -y lm_sensors

msg_info "Enable fstrim scheduler..."

systemctl enable fstrim.timer
