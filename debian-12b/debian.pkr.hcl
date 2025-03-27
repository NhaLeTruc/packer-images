# Packer plugins section
packer {
  required_plugins {
    qemu = {
      source  = "github.com/hashicorp/qemu"
      version = "~> 1"
    }
    vagrant = {
      source  = "github.com/hashicorp/vagrant"
      version = "~> 1"
    }
  }
}

# Variables Section
variable "boot_wait" {
  type    = string
  default = "5s"
}
variable "disk_size" {
  type    = string
  default = "5G"
}
variable "iso" {
  type    = string
  default = "debian-12.5.0-arm64-DVD-1.iso"
}
variable "arch" {
  type    = string
  default = "a64" # a64 for aarch64 , amd for x86_64
}
variable "checksum" {
  type    = string
  default = "de7c838d24d1664d06671df545471f6ed84d945874060c7318d4b2424a480d10"
}

locals {
  name    = "debian"
  version = "12.5"
  url     = "./${var.iso}"
  #url     = "https://cdimage.debian.org/debian-cd/current/arm64/iso-dvd/${var.iso}"
  vm_name = "${local.name}-${local.version}"
  arch    = "arm64"

  vars = {
    vm_name    = local.name
    domain = "local"
    user = {
      name     = "vagrant"
      password = "vagrant"
      }
    root = {
      password = "vagrant"
      }
  }
}

source "qemu" "debian" {
  vm_name              = local.vm_name
  qemu_binary          = "qemu-system-aarch64"
  machine_type         = "virt"
  accelerator          = "hvf"
  cpus                 = 2
  memory               = 2048
  boot_wait            = "${var.boot_wait}"
  boot_key_interval    = "10ms"
  net_device           = "e1000"
  disk_interface       = "virtio"
  format               = "qcow2" 
  disk_size            = "${var.disk_size}"
  headless             = true
 # The preseed file is generated from a template and served by packer
  http_content            = {
        "/preseed.cfg" = templatefile("${path.root}/preseed.pkrtpl", local.vars )
      }


# The boot command enter the menu to modify the boot args to allow for usage of the preseeding file.
  boot_command = [
    "<wait5>e",
    "<leftCtrlOn>k<leftCtrlOff><leftCtrlOn>k<leftCtrlOff><leftCtrlOn>k<leftCtrlOff><leftCtrlOn>k<leftCtrlOff><leftCtrlOn>k<leftCtrlOff><leftCtrlOn>k<leftCtrlOff><leftCtrlOn>k<leftCtrlOff><leftCtrlOn>k<leftCtrlOff>",
    "linux /install.${var.arch}/vmlinuz<spacebar>",
    "auto=true<spacebar>",
    "preseed/url=http://{{ .HTTPIP }}:{{ .HTTPPort }}/preseed.cfg<spacebar>",
    "vga=788 noprompt<spacebar>",
    "hostname=${local.vars.vm_name}<spacebar>",
    "domain=${local.vars.domain}<spacebar>",
    "console=ttyS0,115200<spacebar>",
    "BOOT_DEBUG=2<spacebar>",
    "DEBCONF_DEBUG=5<enter>",
    "initrd /install.${var.arch}/initrd.gz<enter>",
    "<leftCtrlOn>x<leftCtrlOff>",
  ]
  iso_url              = local.url
  iso_checksum         = var.checksum
  qemuargs=[           
      ["-cpu", "host"],
      ["-bios", "/opt/homebrew/share/qemu/edk2-aarch64-code.fd"], 
      ["-boot", "strict=off"],
      ["-device", "qemu-xhci"],
      ["-audio", "none"],
      ["-serial", "file:./serial-output.txt"],
      ["-device", "usb-kbd"],
      ["-device", "virtio-gpu-pci"],                                                                      
  ] 
  shutdown_command = "echo 'packer'|sudo systemctl poweroff "
  ssh_password     = local.vars.user.password
  ssh_port         = 22
  ssh_timeout      = "5m"
  ssh_username     = local.vars.user.name
}

build {
  name = local.vm_name
  sources = ["source.qemu.debian"]

  # Pre-build task to remove the output directory if it exists
  provisioner "shell-local" {
    inline = ["rm -rf output-debian"]
    only = ["before_build"]
  }

  provisioner "file" {
    source      = "scripts/vagrant.pub"
    destination = "/tmp/vagrant.pub"
  }

  provisioner "shell" {
    execute_command = "echo 'packer'|{{ .Vars }} sudo -S -E bash '{{ .Path }}'"
    scripts         = ["scripts/cleanup.sh", "scripts/vagrant.sh"]
  }

	# Once the provisionning is done we package it for Vagrant
  post-processor "vagrant" {
    keep_input_artifact = true
    output              = "../box/${local.vars.vm_name}-vagrant.box"
  }
}
