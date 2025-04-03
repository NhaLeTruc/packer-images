source "proxmox-iso" "debian" {
  insecure_skip_tls_verify = true
  node                     = var.proxmox_node

  iso_storage_pool = "local"
  iso_file          = "local:iso/debian-12.7.0-amd64-netinst.iso"
  iso_checksum     = "8fde79cfc6b20a696200fc5c15219cf6d721e8feb367e9e0e33a79d1cb68fa83"

  template_name        = "${var.template_name}${var.template_name_suffix}"
  template_description = var.template_description

  unmount_iso = true

  scsi_controller = "virtio-scsi-single"
  os              = "l26"
  qemu_agent      = true

  memory = 2048
  cores  = 2
  sockets = 2
  vm_id  = 901
  

  network_adapters {
    model  = "virtio"
    bridge = "vmbr0"
  }

  disks {
    type         = "scsi"
    disk_size    = "10G"
    storage_pool = "local-lvm"
    format       = "raw"
    io_thread    = true
  }

  http_directory = "http"
  ssh_username   = "root"
  ssh_password   = "packer"
  ssh_port       = 22
  ssh_timeout    = "20m"

  boot_wait = "30s"
  boot_command = [
    "<esc><wait>",
    "auto url=${var.preseed_url}<enter>"
  ]

  cloud_init              = true
  cloud_init_storage_pool = "local-lvm"
}
