#!/bin/bash

set -e

NODE_EXPORTER_VER=1.1.2
TERRAFORM_VER=1.0.0
NONROOT_USERNAME=admin
PACKER_UPLOAD_DIR=/tmp/files

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

msg_info "Running base system installation..."

msg_info "Update system..."

dnf update -y

msg_info "Installing epel-release, elrepo-release and yum utilities..."

dnf install -y epel-release elrepo-release yum-utils && dnf update -y

msg_info "Installing basic packages..."

dnf install -y curl wget htop nmon git qemu-img drpm bridge-utils

msg_info "Removing comments and whitespace from dnf / yum config file..."

sed -i -e '/^[ \t]*#/d' /etc/yum.conf

sed -i '/^$/d' /etc/yum.conf

msg_info "Adding drpm configuration..."

grep -q '^deltarpm' /etc/yum.conf && sed -i 's/^deltarpm.*/deltarpm=True/' /etc/yum.conf || echo 'deltarpm=True' >> /etc/yum.conf

msg_info "Installing Docker..."

yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo -y && dnf update -y

dnf install -y docker-ce docker-ce-cli

systemctl enable docker && systemctl start docker

groupadd docker || true

usermod -aG docker "${NONROOT_USERNAME}"

msg_info "Adding docker0 bridge as a trusted zone..."

firewall-cmd --permanent --zone=trusted --change-interface=docker0

msg_info "Installing sysctl tuning config file..."

cat ${PACKER_UPLOAD_DIR}/tune-sysctl.conf > /etc/sysctl.d/01-tune.conf

msg_info "Installing limits config file..."

cat ${PACKER_UPLOAD_DIR}/limits.conf > /etc/security/limits.d/limits.conf

msg_info "Installing sshd config file..."

cat ${PACKER_UPLOAD_DIR}/sshd.conf > /etc/ssh/sshd_config

msg_info "Installing issue file..."

cat ${PACKER_UPLOAD_DIR}/issue > /etc/issue

cat ${PACKER_UPLOAD_DIR}/issue.net > /etc/issue.net

msg_info "Installing Prometheus Node Exporter..."

cd /tmp && wget https://github.com/prometheus/node_exporter/releases/download/v${NODE_EXPORTER_VER}/node_exporter-${NODE_EXPORTER_VER}.linux-amd64.tar.gz

cd /tmp && tar -xvf ./node_exporter-${NODE_EXPORTER_VER}.linux-amd64.tar.gz

mv -v /tmp/node_exporter-${NODE_EXPORTER_VER}.linux-amd64/node_exporter /usr/local/bin/node_exporter

chown root:root /usr/local/bin/node_exporter && chmod +x /usr/local/bin/node_exporter

rm -rf /tmp/*node_exporter*

msg_info "Installing Terraform CLI..."

cd /tmp && wget https://releases.hashicorp.com/terraform/1.0.0/terraform_${TERRAFORM_VER}_linux_amd64.zip

cd /tmp && unzip ./terraform_${TERRAFORM_VER}_linux_amd64.zip

mv -v /tmp/terraform /usr/local/bin/terraform

chown root:root /usr/local/bin/terraform && chmod +x /usr/local/bin/terraform

rm -rf /tmp/*terraform*

msg_info "Installing Wireguard..."

mkdir -p /etc/wireguard

dnf install wireguard-tools -y

msg_info "Changing GRUB distributor name..."

sed -i 's/^GRUB_DISTRIBUTOR=.*$/GRUB_DISTRIBUTOR=\"InfrastructureOS\"/' /etc/default/grub

grub2-mkconfig -o /boot/grub2/grub.cfg

msg_info "Disabling swap..."

sed -i '/swap/d' /etc/fstab

msg_info "Adding hostnamectl changes..."

hostnamectl set-chassis embedded

hostnamectl set-deployment production

hostnamectl set-icon-name computer

msg_info "Clean up everything..."

dnf clean all -y

msg_info "Finished $0..."
