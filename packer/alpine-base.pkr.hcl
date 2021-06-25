variable "cpus" {
  type    = string
  default = "1"
}

variable "disk_size" {
  type    = string
  default = "25G"
}

variable "memory" {
  type    = string
  default = "1G"
}

variable "ssh_username" {
  type    = string
  default = "root"
}

variable "ssh_password" {
  type    = string
  default = "alpine"
}

variable "enable-headless" {
  type    = bool
  default = false
}

variable "version" {
  type    = string
  default = "true"
}

source "qemu" "alpine" {
  accelerator      = "kvm"
  boot_command      = ["root<enter><wait>", "ifconfig eth0 up && udhcpc -i eth0<enter><wait5>", "wget http://{{ .HTTPIP }}:{{ .HTTPPort }}/alpine-kvm-answers.cfg<enter><wait>", "setup-alpine -f alpine-kvm-answers.cfg<enter><wait10>", "alpine<enter><wait>", "alpine<enter><wait10>", "y<enter>", "<wait10><wait10><wait10>", "/etc/init.d/sshd stop<enter><wait>", "mount /dev/sda2 /mnt<enter>", "echo 'PermitRootLogin yes' >> /mnt/etc/ssh/sshd_config<enter>", "umount /mnt<enter>", "reboot<enter>"]
  boot_wait        = "30s"
  disk_interface   = "virtio-scsi"
  disk_size        = "${var.disk_size}"
  format           = "qcow2"
  headless         = "${var.enable-headless}"
  host_port_max    = 2229
  host_port_min    = 2222
  http_directory   = "http/alpine"
  http_port_max    = 10089
  http_port_min    = 10082
  iso_checksum     = "sha256:3b4d23a61109be618bc42d7d88c2dd14ec7cfbdc6b81272ed268ef640044e317"
  iso_url          = "https://dl-cdn.alpinelinux.org/alpine/v3.14/releases/x86_64/alpine-extended-3.14.0-x86_64.iso"
  net_device       = "virtio-net"
  output_directory = "alpine-output"
  qemuargs         = [["-m", "${var.memory}"], ["-serial", "file:serial.out"], ["-smp", "cpus=${var.cpus}"]]
  shutdown_command = "/sbin/poweroff"
  ssh_password     = "${var.ssh_password}"
  ssh_port         = 22
  ssh_timeout      = "10m"
  ssh_username     = "${var.ssh_username}"
  vm_name          = "alpine-base.qcow2"
}

build {
  sources = ["source.qemu.alpine"]

  provisioner "shell" {
    environment_vars = ["SSH_USERNAME=${var.ssh_username}", "SSH_PASSWORD=${var.ssh_password}"]
    pause_before     = "10s"
    scripts          = ["scripts/alpine/00-base.sh"]
  }

}