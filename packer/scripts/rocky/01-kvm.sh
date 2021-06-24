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

msg_info "Installing and setting up KVM..."

dnf install qemu-kvm libvirt virt-install edk2-ovmf bridge-utils -y

msg_info "Enabling libvirtd..."

systemctl enable libvirtd

msg_info "Adding netfilter module..."

echo "br_netfilter" > /etc/modules-load.d/br_netfilter.conf

msg_info "Adding netfilter sysctl configuration..."

cat << EOF > /etc/sysctl.d/02-netfilter.conf
# Disable netfilter for KVM.
net.bridge.bridge-nf-call-ip6tables = 0
net.bridge.bridge-nf-call-iptables = 0
net.bridge.bridge-nf-call-arptables = 0
EOF

msg_info "Downloading and Injecting OVMF.fd binary..."

wget https://github.com/clearlinux/common/raw/master/OVMF.fd -O /usr/share/OVMF/OVMF.fd

msg_info "Finished $0..."