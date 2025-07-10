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

  provisioner "shell" {
    inline = [
      "sudo apt -y install default-jre",
      "sudo apt -y install default-jdk",
      "sudo apt update",
      "sudo apt install ca-certificates curl",
      "sudo install -m 0755 -d /etc/apt/keyrings",
      "sudo curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc",
      "sudo chmod a+r /etc/apt/keyrings/docker.asc",
      "echo 'deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian $(. /etc/os-release && echo "$VERSION_CODENAME") stable' | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null",
      "sudo apt update",
      "sudo apt -y install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin"
    ]
  }

}