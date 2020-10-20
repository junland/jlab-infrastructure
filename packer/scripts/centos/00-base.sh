#!/bin/bash

set -e

NODE_EXPORTER_VER=1.0.1

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

msg "Removing older kernels..."

dnf remove -y --oldinstallonly --setopt installonly_limit=2 kernel

msg "Installing epel-release..."

dnf install -y epel-release && dnf update -y

msg "Installing basic packages..."

dnf install -y curl wget htop nmon

msg "Installing Docker..."

yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo -y && dnf update -y

dnf install -y docker-ce docker-ce-cli

systemctl enable docker && systemctl start docker

groupadd docker || true

msg "Installing sysctl tuning config file..."

curl https://raw.githubusercontent.com/junland/jlab-infrastructure/master/ansible/roles/base/files/tune-sysctl.conf > /etc/sysctl.d/01-tune.conf

msg "Installing limits config file..."

curl https://raw.githubusercontent.com/junland/jlab-infrastructure/master/ansible/roles/base/files/limits.conf > /etc/security/limits.d/limits.conf

msg "Installing sshd config file..."

curl https://raw.githubusercontent.com/junland/jlab-infrastructure/master/ansible/roles/base/files/sshd.conf > /etc/ssh/sshd_conf

msg "Installing Prometheus Node Exporter..."

cd /tmp && wget https://github.com/prometheus/node_exporter/releases/download/v${NODE_EXPORTER_VER}/node_exporter-${NODE_EXPORTER_VER}.linux-amd64.tar.gz

cd /tmp && tar -xvf ./node_exporter-${NODE_EXPORTER_VER}.linux-amd64.tar.gz

mv -v /tmp/node_exporter-${NODE_EXPORTER_VER}.linux-amd64/node_exporter /usr/local/bin/node_exporter

chown root:root /usr/local/bin/node_exporter

rm -rf /tmp/*node_exporter*

msg "Disable swap..."

sed -i '/swap/d' /etc/fstab

msg "Clean up everything..."

dnf clean all -y

msg "Finished $0..."