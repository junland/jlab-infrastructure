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
  default = "1.5G"
}

variable "ssh_password" {
  type    = string
  default = "root"
}

variable "ssh_username" {
  type    = string
  default = "root"
}

variable "enable-headless" {
  type    = bool
  default = false
}

variable "version" {
  type    = string
  default = "1.0.0"
}

source "qemu" "rocky" {
  accelerator      = "kvm"
  boot_command     = ["<up>e<wait><down><down><end><bs><bs><bs><bs><bs> text inst.ks=http://{{ .HTTPIP }}:{{ .HTTPPort }}/rocky-ks.cfg <leftCtrlOn>x<leftCtrlOff><wait>"]
  boot_wait        = "10s"
  disk_interface   = "virtio-scsi"
  disk_size        = "${var.disk_size}"
  format           = "qcow2"
  headless         = "${var.enable-headless}"
  host_port_max    = 2229
  host_port_min    = 2222
  http_directory   = "http/rocky"
  http_port_max    = 10089
  http_port_min    = 10082
  iso_checksum     = "sha256:0de5f12eba93e00fefc06cdb0aa4389a0972a4212977362ea18bde46a1a1aa4f"
  iso_url          = "https://download.rockylinux.org/pub/rocky/8/isos/x86_64/Rocky-8.4-x86_64-minimal.iso"
  net_device       = "virtio-net"
  output_directory = "rocky-output"
  qemuargs         = [["-m", "${var.memory}"], ["-serial", "file:serial.out"], ["-smp", "cpus=${var.cpus}"], ["-bios", "/usr/share/ovmf/OVMF.fd"], ["-smbios", "type=0,uefi=on"]]
  shutdown_command = "shutdown -P now"
  ssh_password     = "${var.ssh_password}"
  ssh_port         = 22
  ssh_timeout      = "2400s"
  ssh_username     = "${var.ssh_username}"
  vm_name          = "rocky-base.qcow2"
}

build {
  sources = ["source.qemu.rocky"]

  provisioner "file" {
    source      = "./files"      
    destination = "/tmp/"    
  }

  provisioner "shell" {
    environment_vars = ["SSH_USERNAME=${var.ssh_username}", "SSH_PASSWORD=${var.ssh_password}"]
    pause_before     = "10s"
    scripts          = ["scripts/rocky/00-base.sh"]
  }

  provisioner "shell" {
    environment_vars = ["SSH_USERNAME=${var.ssh_username}", "SSH_PASSWORD=${var.ssh_password}"]
    inline           = ["dnf clean all -y", "dnf autoremove -y"]
    pause_before     = "10s"
  }

}
