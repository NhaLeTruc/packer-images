packer {
  required_plugins {
    virtualbox = {
      source  = "github.com/hashicorp/virtualbox"
      version = "~> 1"
    }
  }
}

variable "iso" {
  type = string
}

variable "sha256sum" {
  type = string
}

variable "bridge_nic" {
  type = string
}

variable "default_ssh_key" {
  type    = string
  default = ""
}

source "virtualbox-iso" "main" {
  guest_os_type          = "RedHat_64"
  iso_url                = var.iso
  iso_checksum           = "sha256:${var.sha256sum}"
  vm_name                = "rocky9"
  headless               = true
  ssh_username           = "packer"
  ssh_password           = "packer"
  ssh_port               = 22
  ssh_timeout            = "15m"
  ssh_handshake_attempts = 20
  guest_additions_mode   = "disable"
  iso_interface          = "sata"
  hard_drive_interface   = "sata"
  disk_size              = 20480
  http_directory         = "http"
  shutdown_command       = "echo 'packer' | sudo -S /sbin/halt -h -p"
  output_directory       = "output"
  format                 = "ova"
  boot_wait              = "7s"
  boot_command = [
    "<up><wait><tab>",
    "inst.text ",
    "inst.ks=http://{{ .HTTPIP }}:{{ .HTTPPort }}/ks.cfg",
    "<enter><wait>"
  ]
  vboxmanage = [
    ["modifyvm", "{{ .Name }}", "--nat-localhostreachable1", "on"],
    ["modifyvm", "{{ .Name }}", "--memory", "1024"],
    ["modifyvm", "{{ .Name }}", "--cpus", "1"],
    ["modifyvm", "{{ .Name }}", "--vram", "32"],
    ["modifyvm", "{{ .Name }}", "--graphicscontroller", "vmsvga"],
    ["modifyvm", "{{ .Name }}", "--description", "Default credentials:\npacker packer\nor\nroot packer\nDefault hostname: unconfigured.dev\nDHCP enabled"]
  ]
  vboxmanage_post = [
    [
      "modifyvm",
      "{{ .Name }}",
      "--nic1",
      "bridged",
      "--bridgeadapter1",
      var.bridge_nic
    ]
  ]

}

build {
  sources = ["source.virtualbox-iso.main"]

  provisioner "shell" {
    env = {
      "DEFAULT_SSH_KEY" = var.default_ssh_key
    }
    script            = "scripts/main.sh"
    expect_disconnect = true
  }

  provisioner "shell" {
    script = "scripts/cleanup.sh"
  }

}
