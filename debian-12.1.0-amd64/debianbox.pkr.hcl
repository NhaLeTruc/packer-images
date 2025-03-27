source "qemu" "debian-qemu" {
    http_directory = "http"
    boot_command = [
      "<esc><wait>",
      "auto<wait>",
      " auto-install/enable=true",
      " debconf/priority=critical",
      " preseed/url=http://{{ .HTTPIP }}:{{ .HTTPPort }}/preseed.cfg<wait>",
      " -- <wait>",
      "<enter><wait>"
    ]
    iso_url = "${var.iso_url}"
    iso_checksum = "${var.iso_checksum}"
    accelerator = "kvm"
    ssh_username = "root"
    ssh_password = "debianrootpassword"
    ssh_timeout = "60m"
    boot_wait = "10s"
    vm_name = "debian-builder"
    disk_size = "${var.disk_size}"
    format = "qcow2"
    memory = var.vm_memory
    cpus = var.vm_cpu
    net_device = "virtio-net"
    efi_boot = false
}

build {
    name = "debian-image"
    sources = ["source.qemu.debian-qemu"]

    provisioner "ansible" {
      playbook_file = "./playbook.yml"
      extra_arguments = [
        "--extra-vars", "ansible_become_method=su"
      ]
    }
}