build {
  sources = ["source.proxmox-iso.debian"]

  # Copy default cloud-init config
  provisioner "file" {
    destination = "/etc/cloud/cloud.cfg"
    source      = "http/cloud.cfg"
  }

  # Copy Proxmox cloud-init config
  provisioner "file" {
    destination = "/etc/cloud/cloud.cfg.d/99-pve.cfg"
    source      = "http/99-pve.cfg"
  }
}