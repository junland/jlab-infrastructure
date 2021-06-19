#!/bin/ash

set -e

NONROOT_USERNAME=admin

msg_info() {
  echo -e "\e[94m >>>> $1 \e[0m"
}

msg_fail() {
  echo -e "\e[31m >>>> $1 \e[0m"
  exit 1
}

[ `id -u` = 0 ] || msg_fail "$0: Script must be run via sudo or root user"

msg_info "Getting OS info..."

. /etc/os-release

msg_info "Running base system installation..."

msg_info "Update system..."

apk update

msg_info "Install PostgreSQL..."

apk install postgresql

msg_info "Finished $0..."
