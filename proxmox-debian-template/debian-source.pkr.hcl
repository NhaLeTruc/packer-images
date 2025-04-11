source "proxmox-iso" "debian" {

  insecure_skip_tls_verify  = var.tls_bool
  node                      = var.proxmox_node
  vm_id                     = var.vm_id
  template_name             = "${var.template_name}${var.template_name_suffix}"
  template_description      = var.template_description

  boot_iso {
    type          = var.iso_type
    iso_file      = var.iso_file
    iso_checksum  = var.iso_checksum
    unmount       = var.iso_unmount
  }

  scsi_controller         = var.scsi_controller
  os                      = var.os
  machine                 = var.machine
  bios                    = var.bios

  qemu_agent              = var.qemu_agent
  cloud_init              = var.cloud_init
  cloud_init_storage_pool = var.cloud_init_storage_pool

  cores     = var.cores
  memory    = var.memory
  sockets   = var.sockets
  cpu_type  = var.cpu_type
  
  network_adapters {
    bridge   = var.network_bridge
    model    = var.network_model
    # These need firewall and vlan setup to work
    # vlan_tag = var.vlan_tag
    # firewall = var.firewall
  }

  disks {
    type         = var.disk_type
    disk_size    = var.disk_size
    format       = var.disk_format
    storage_pool = var.storage_pool
    io_thread    = var.io_thread
  }

  http_content = {
    "/cloud.cfg" = templatefile("http/cloud.cfg",
      {
        var                    = var,
        ssh_public_key         = chomp(file(var.ssh_public_key_file))
      })
    "/preseed.cfg"  = file("http/preseed.cfg")
    "/99-pve.cfg"   = file("http/99-pve.cfg")
  }
  ssh_username   = var.ssh_username
  ssh_password   = var.ssh_password
  ssh_timeout    = var.ssh_timeout
  ssh_port       = var.ssh_port
  
  boot_wait = var.boot_wait
  boot_command = [
    "<esc><wait>",
    "auto url=${var.preseed_url}<enter>"
  ]

}
