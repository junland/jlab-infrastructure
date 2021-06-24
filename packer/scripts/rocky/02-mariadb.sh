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

msg_info "Installing and setting up MariaDB..."

dnf install mariadb mariadb-server-galera -y

msg_info "Enabling MariaDB..."

systemctl enable mariadb

msg_info "Configuring MariaDB..."

systemctl start mariadb

mysql --user=root <<_EOF_
UPDATE mysql.user SET Password=PASSWORD('dbpassword') WHERE User='root';
DELETE FROM mysql.user WHERE User='';
DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');
DROP DATABASE IF EXISTS test;
DELETE FROM mysql.db WHERE Db='test' OR Db='test\\_%';
FLUSH PRIVILEGES;
_EOF_

rm -rf /etc/my.cnf.d/*.cnf

cp -v /tmp/files/mariadb.cnf /etc/my.cnf.d/mariadb.cnf

msg_info "Opening ports for MariaDB and Galera..."

firewall-cmd --zone=public --add-service=mysql --permanent

firewall-cmd --zone=public --add-service=galera --permanent

msg_info "Finished $0..."