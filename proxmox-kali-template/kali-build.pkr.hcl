build {
  sources = ["source.proxmox-iso.kali"]

  # Copy cloud-init configuration
  provisioner "file" {
    destination = "/etc/cloud/cloud.cfg"
    source      = "http/cloud.cfg"
  }

  provisioner "file" {
    destination = "/etc/cloud/cloud.cfg.d/99-pve.cfg"
    source      = "http/99-pve.cfg"
  }

  # Update system and install base tools
  provisioner "shell" {
    inline = [
      "apt-get update",
      "apt-get upgrade -y",
      "apt-get install -y build-essential git wget curl vim tmux htop",
      "apt-get install -y net-tools openssh-server sudo"
    ]
  }

  # Install Kali metapackages for comprehensive tool coverage
  provisioner "shell" {
    inline = [
      "apt-get install -y kali-linux-headless",
      "apt-get install -y kali-tools-top10",
      "apt-get install -y kali-tools-information-gathering",
      "apt-get install -y kali-tools-vulnerability",
      "apt-get install -y kali-tools-web",
      "apt-get install -y kali-tools-passwords",
      "apt-get install -y kali-tools-wireless",
      "apt-get install -y kali-tools-reverse-engineering",
      "apt-get install -y kali-tools-exploitation",
      "apt-get install -y kali-tools-social-engineering",
      "apt-get install -y kali-tools-sniffing-spoofing",
      "apt-get install -y kali-tools-post-exploitation",
      "apt-get install -y kali-tools-forensics",
      "apt-get install -y kali-tools-reporting"
    ]
  }

  # Install essential penetration testing tools
  provisioner "shell" {
    inline = [
      "apt-get install -y metasploit-framework",
      "apt-get install -y nmap",
      "apt-get install -y wireshark",
      "apt-get install -y aircrack-ng",
      "apt-get install -y hashcat",
      "apt-get install -y john",
      "apt-get install -y hydra",
      "apt-get install -y sqlmap",
      "apt-get install -y nikto",
      "apt-get install -y dirb",
      "apt-get install -y gobuster",
      "apt-get install -y wfuzz",
      "apt-get install -y ffuf"
    ]
  }

  # Install web application testing tools
  provisioner "shell" {
    inline = [
      "apt-get install -y burpsuite",
      "apt-get install -y zaproxy",
      "apt-get install -y commix",
      "apt-get install -y wpscan",
      "apt-get install -y joomscan",
      "apt-get install -y whatweb",
      "apt-get install -y wafw00f"
    ]
  }

  # Install network and wireless tools
  provisioner "shell" {
    inline = [
      "apt-get install -y tcpdump",
      "apt-get install -y ettercap-text-only",
      "apt-get install -y bettercap",
      "apt-get install -y responder",
      "apt-get install -y dnsrecon",
      "apt-get install -y dnsenum",
      "apt-get install -y fierce",
      "apt-get install -y sublist3r",
      "apt-get install -y amass",
      "apt-get install -y masscan",
      "apt-get install -y reaver",
      "apt-get install -y wifite",
      "apt-get install -y pixiewps"
    ]
  }

  # Install exploitation frameworks and tools
  provisioner "shell" {
    inline = [
      "apt-get install -y exploitdb",
      "apt-get install -y searchsploit",
      "apt-get install -y social-engineer-toolkit",
      "apt-get install -y beef-xss",
      "apt-get install -y crackmapexec",
      "apt-get install -y impacket-scripts",
      "apt-get install -y powersploit",
      "apt-get install -y empire"
    ]
  }

  # Install password cracking and hash tools
  provisioner "shell" {
    inline = [
      "apt-get install -y ophcrack",
      "apt-get install -y rainbowcrack",
      "apt-get install -y crunch",
      "apt-get install -y cewl",
      "apt-get install -y maskprocessor",
      "apt-get install -y hash-identifier",
      "apt-get install -y hashid"
    ]
  }

  # Install reverse engineering and binary analysis tools
  provisioner "shell" {
    inline = [
      "apt-get install -y radare2",
      "apt-get install -y ghidra",
      "apt-get install -y binwalk",
      "apt-get install -y foremost",
      "apt-get install -y volatility3",
      "apt-get install -y autopsy",
      "apt-get install -y sleuthkit",
      "apt-get install -y yara"
    ]
  }

  # Install post-exploitation and lateral movement tools
  provisioner "shell" {
    inline = [
      "apt-get install -y mimikatz",
      "apt-get install -y bloodhound",
      "apt-get install -y proxychains4",
      "apt-get install -y sshuttle",
      "apt-get install -y chisel",
      "apt-get install -y ligolo-ng"
    ]
  }

  # Install cloud and container security tools
  provisioner "shell" {
    inline = [
      "apt-get install -y docker.io",
      "apt-get install -y docker-compose",
      "systemctl enable docker"
    ]
  }

  # Install Python security libraries and tools
  provisioner "shell" {
    inline = [
      "apt-get install -y python3-pip",
      "pip3 install --break-system-packages pwntools",
      "pip3 install --break-system-packages scapy",
      "pip3 install --break-system-packages requests",
      "pip3 install --break-system-packages beautifulsoup4",
      "pip3 install --break-system-packages paramiko",
      "pip3 install --break-system-packages pyftpdlib",
      "pip3 install --break-system-packages impacket",
      "pip3 install --break-system-packages mitm6",
      "pip3 install --break-system-packages ldapdomaindump"
    ]
  }

  # Install additional reconnaissance tools
  provisioner "shell" {
    inline = [
      "apt-get install -y theharvester",
      "apt-get install -y recon-ng",
      "apt-get install -y maltego",
      "apt-get install -y spiderfoot",
      "apt-get install -y sherlock",
      "apt-get install -y photon"
    ]
  }

  # Install vulnerability scanners
  provisioner "shell" {
    inline = [
      "apt-get install -y openvas",
      "apt-get install -y nuclei",
      "apt-get install -y nikto",
      "apt-get install -y lynis"
    ]
  }

  # Install privilege escalation enumeration tools
  provisioner "shell" {
    inline = [
      "wget https://github.com/carlospolop/PEASS-ng/releases/latest/download/linpeas.sh -O /usr/local/bin/linpeas.sh",
      "chmod +x /usr/local/bin/linpeas.sh",
      "wget https://github.com/rebootuser/LinEnum/raw/master/LinEnum.sh -O /usr/local/bin/linenum.sh",
      "chmod +x /usr/local/bin/linenum.sh"
    ]
  }

  # Install wordlists and common security resources
  provisioner "shell" {
    inline = [
      "apt-get install -y seclists",
      "apt-get install -y wordlists",
      "gunzip /usr/share/wordlists/rockyou.txt.gz 2>/dev/null || true"
    ]
  }

  # Install shell improvement and productivity tools
  provisioner "shell" {
    inline = [
      "apt-get install -y zsh",
      "apt-get install -y fish",
      "apt-get install -y tmux",
      "apt-get install -y screen",
      "apt-get install -y vim-nox",
      "apt-get install -y neovim"
    ]
  }

  # Install reporting and documentation tools
  provisioner "shell" {
    inline = [
      "apt-get install -y cherrytree",
      "apt-get install -y keepnote",
      "apt-get install -y dradis",
      "apt-get install -y pipal"
    ]
  }

  # Configure Metasploit database
  provisioner "shell" {
    inline = [
      "apt-get install -y postgresql",
      "systemctl enable postgresql",
      "msfdb init || true"
    ]
  }

  # Install additional security utilities
  provisioner "shell" {
    inline = [
      "apt-get install -y exiftool",
      "apt-get install -y steghide",
      "apt-get install -y stegosuite",
      "apt-get install -y outguess",
      "apt-get install -y sslscan",
      "apt-get install -y sslyze",
      "apt-get install -y testssl.sh"
    ]
  }

  # Enable and configure services
  provisioner "shell" {
    inline = [
      "systemctl enable ssh",
      "systemctl enable qemu-guest-agent",
      "systemctl enable cloud-init",
      "systemctl enable cloud-init-local",
      "systemctl enable cloud-config",
      "systemctl enable cloud-final"
    ]
  }

  # Configure SSH for security
  provisioner "shell" {
    inline = [
      "sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config",
      "sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config"
    ]
  }

  # Create useful aliases and environment setup
  provisioner "shell" {
    inline = [
      "echo 'alias ll=\"ls -la\"' >> /etc/bash.bashrc",
      "echo 'alias nse=\"ls /usr/share/nmap/scripts | grep\"' >> /etc/bash.bashrc",
      "echo 'alias www=\"python3 -m http.server 8000\"' >> /etc/bash.bashrc",
      "echo 'export PATH=$PATH:/usr/share/metasploit-framework/tools/exploit' >> /etc/bash.bashrc"
    ]
  }

  # Clean up and optimize
  provisioner "shell" {
    inline = [
      "apt-get autoremove -y",
      "apt-get clean",
      "rm -rf /var/lib/apt/lists/*",
      "rm -rf /tmp/*",
      "history -c"
    ]
  }

}
