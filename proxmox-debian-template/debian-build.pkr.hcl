build {
  sources = ["source.proxmox-iso.debian"]

  provisioner "shell" {
    inline = [
      "apt-get install --yes python3-pip",
      "passwd --lock root",
      "echo PasswordAuthentication no >> /etc/ssh/sshd_config"
    ]
  }

  provisioner "file" {
    content     = <<EOF
growpart:
  devices:
    - '/dev/sda2'
    - '/dev/sda6'
EOF
    destination = "/etc/cloud/cloud.cfg.d/99_growpart.cfg"
  }
}