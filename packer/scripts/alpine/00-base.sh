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

msg_info "Installing Prometheus Node Exporter..."

cd /tmp && wget https://github.com/prometheus/node_exporter/releases/download/v${NODE_EXPORTER_VER}/node_exporter-${NODE_EXPORTER_VER}.linux-amd64.tar.gz

cd /tmp && tar -xvf ./node_exporter-${NODE_EXPORTER_VER}.linux-amd64.tar.gz

mv -v /tmp/node_exporter-${NODE_EXPORTER_VER}.linux-amd64/node_exporter /usr/local/bin/node_exporter

chown root:root /usr/local/bin/node_exporter

rm -rf /tmp/*node_exporter*

msg_info "Installing Wireguard..."

apk add wireguard-tools

mkdir -p /etc/wireguard

echo "wireguard" >> /etc/modules

msg_info "Finished $0..."
