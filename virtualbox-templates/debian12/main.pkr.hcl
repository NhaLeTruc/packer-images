packer {
  required_plugins {
    virtualbox = {
      version = "~> 1"
      source  = "github.com/hashicorp/virtualbox"
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
  guest_os_type          = "Debian_64"
  iso_url                = var.iso
  iso_checksum           = var.sha256sum
  vm_name                = "debian12"
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
  shutdown_command       = "sudo systemctl poweroff"
  output_directory       = "output"
  format                 = "ova"
  boot_wait              = "7s"
  boot_command = [
    "<down>",
    "<tab>",
    "fb=false ",
    "auto=true ",
    "url=http://{{.HTTPIP}}:{{.HTTPPort}}/preseed.cfg ",
    "hostname=debian ",
    "domain=local ",
    "debian-installer=en_US.UTF-8 ",
    "locale=en_US.UTF-8 ",
    "kbd-chooser/method=us ",
    "keyboard-configuration/xkb-keymap=us ",
    "console-setup/ask_detect=false ",
    "console-keymaps-at/keymap=us ",
    "debconf/frontend=noninteractive ",
    "grub-installer/bootdev=/dev/sda <wait>",
    "<enter>"
  ]
  vboxmanage = [
    ["modifyvm", "{{.Name}}", "--nat-localhostreachable1", "on"],
    ["modifyvm", "{{.Name}}", "--memory", "1024"],
    ["modifyvm", "{{.Name}}", "--cpus", "1"],
    ["modifyvm", "{{.Name}}", "--vram", "32"],
    ["modifyvm", "{{.Name}}", "--graphicscontroller", "vmsvga"],
    ["modifyvm", "{{.Name}}", "--description", "Default credentials: packer packer\nDefault hostname: debian.local\nDHCP enabled"]
  ]
  vboxmanage_post = [
    [
      "modifyvm",
      "{{.Name}}",
      "--nic1",
      "bridged",
      "--bridgeadapter1",
      var.bridge_nic
    ]
  ]
}

build {
  sources = ["sources.virtualbox-iso.main"]

  provisioner "shell" {
    env = {
      "DEFAULT_SSH_KEY" = var.default_ssh_key
    }
    execute_command   = "echo 'packer' | {{.Vars}} sudo -E -S bash '{{.Path}}'"
    script            = "scripts/main.sh"
    expect_disconnect = true
  }

  provisioner "shell" {
    execute_command = "echo 'packer' | {{.Vars}} sudo -E -S bash '{{.Path}}'"
    script          = "scripts/cleanup.sh"
  }

}
