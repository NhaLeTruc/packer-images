# Kali Linux Cybersecurity Golden Image for Proxmox

## Overview

Packer configuration for building a Kali Linux 'golden image' Proxmox template optimized for cybersecurity operations, penetration testing, security auditing, digital forensics, and ethical hacking. Kali Linux is the industry-standard platform for security professionals, built on Debian with rolling release updates.

## Features

### Core Infrastructure
- **Kali Linux 2024.x** rolling release
- **Cloud-init** for automated configuration when cloning
- **QEMU guest agent** for Proxmox integration
- **600+ pre-installed security tools** from Kali repositories
- Debian-based stability with cutting-edge security tools
- Optimized for rapid deployment and scalability

### Security Tool Categories

#### Information Gathering & Reconnaissance
- **Nmap** - Network discovery and security auditing
- **Masscan** - High-speed port scanner
- **Amass** - In-depth attack surface mapping
- **Sublist3r** - Subdomain enumeration
- **theHarvester** - OSINT gathering
- **Recon-ng** - Full-featured reconnaissance framework
- **Maltego** - Link analysis and data mining
- **Spiderfoot** - Automated OSINT
- **Sherlock** - Hunt social media accounts
- **DNSRecon, DNSenum, Fierce** - DNS enumeration

#### Vulnerability Analysis
- **OpenVAS** - Comprehensive vulnerability scanner
- **Nuclei** - Fast vulnerability scanner
- **Nikto** - Web server scanner
- **Lynis** - Security auditing tool
- **SearchSploit / ExploitDB** - Exploit database

#### Web Application Testing
- **Burp Suite** - Web application security testing
- **OWASP ZAP** - Web application scanner
- **SQLMap** - SQL injection tool
- **Commix** - Command injection exploiter
- **WPScan** - WordPress security scanner
- **JoomScan** - Joomla scanner
- **WhatWeb** - Web fingerprinting
- **WAFW00F** - WAF detection
- **Dirb, Gobuster, FFuF, Wfuzz** - Directory/file enumeration

#### Network & Wireless Attacks
- **Wireshark** - Network protocol analyzer
- **Tcpdump** - Packet analyzer
- **Ettercap** - Network sniffing/MITM
- **Bettercap** - Network attacks and monitoring
- **Responder** - LLMNR/NBT-NS/MDNS poisoner
- **Aircrack-ng** - WiFi security auditing
- **Wifite** - Automated wireless attack tool
- **Reaver** - WPS brute force
- **Pixiewps** - WPS vulnerability exploiter

#### Exploitation Frameworks
- **Metasploit Framework** - Penetration testing platform
- **Social Engineering Toolkit (SET)** - Social engineering attacks
- **BeEF-XSS** - Browser exploitation framework
- **Empire** - Post-exploitation framework
- **CrackMapExec** - Swiss army knife for pentesting networks
- **Impacket** - Network protocol manipulation

#### Password Attacks
- **Hashcat** - Advanced password recovery
- **John the Ripper** - Password cracker
- **Hydra** - Network logon cracker
- **Ophcrack** - Windows password cracker
- **RainbowCrack** - Rainbow table password cracker
- **Crunch** - Wordlist generator
- **CeWL** - Custom wordlist generator
- **Maskprocessor** - High-performance word generator
- **Hash-identifier, Hashid** - Hash type identification

#### Reverse Engineering & Forensics
- **Ghidra** - Software reverse engineering suite
- **Radare2** - Reverse engineering framework
- **Binwalk** - Firmware analysis tool
- **Foremost** - File carving tool
- **Volatility3** - Memory forensics framework
- **Autopsy** - Digital forensics platform
- **Sleuthkit** - Digital investigation tools
- **YARA** - Malware identification and classification

#### Post-Exploitation & Lateral Movement
- **Mimikatz** - Windows credential extraction
- **BloodHound** - Active Directory relationship mapping
- **Proxychains** - Proxy chains
- **SSHuttle** - VPN over SSH
- **Chisel** - Fast TCP/UDP tunnel
- **Ligolo-ng** - Advanced tunneling tool
- **LinPEAS** - Linux privilege escalation
- **LinEnum** - Linux enumeration

#### Cloud & Container Security
- **Docker** - Container platform for testing
- **Docker Compose** - Multi-container orchestration

#### Reporting & Documentation
- **CherryTree** - Hierarchical note-taking
- **KeepNote** - Note organization
- **Dradis** - Collaboration and reporting
- **Pipal** - Password analysis tool

#### Steganography & OSINT
- **Exiftool** - Metadata extraction
- **Steghide** - Steganography program
- **Stegosuite** - Steganography tool
- **Outguess** - Universal steganographic tool

#### SSL/TLS Testing
- **SSLScan** - SSL/TLS scanner
- **SSLyze** - SSL configuration analyzer
- **TestSSL.sh** - SSL/TLS testing

### Python Security Libraries
- **Pwntools** - CTF framework and exploit development
- **Scapy** - Packet manipulation
- **Requests** - HTTP library
- **BeautifulSoup4** - Web scraping
- **Paramiko** - SSH implementation
- **Impacket** - Network protocols
- **Mitm6** - IPv6 MITM attacks
- **ldapdomaindump** - Active Directory information dumper

### Wordlists & Resources
- **SecLists** - Comprehensive security wordlists
- **RockYou** - Popular password list
- **Various Kali wordlists** - Specialized dictionaries

## System Requirements

### Recommended VM Specifications
- **CPU**: 4 cores (host CPU type for best performance)
- **Memory**: 4096 MB (4 GB) minimum, 8 GB recommended for heavy testing
- **Disk**: 80 GB (comprehensive tool suite requires space)
- **Storage Format**: Raw (best performance) or qcow2
- **Network**: Isolated network recommended for testing environments

### Proxmox Requirements
- Proxmox VE 7.x or later
- Packer 1.9.1 or later
- Sufficient storage for template and clones
- Isolated network for security testing (recommended)

## Quick Start

### 1. Download Kali Linux ISO

Download the latest Kali Linux installer ISO:

```bash
# On Proxmox server
cd /var/lib/vz/template/iso

# Download Kali Linux (installer version)
wget https://cdimage.kali.org/kali-2024.1/kali-linux-2024.1-installer-amd64.iso

# Get checksum
wget https://cdimage.kali.org/kali-2024.1/SHA256SUMS
cat SHA256SUMS | grep installer-amd64.iso
```

### 2. Configure Build Variables

Create `vars/build.pkrvars.hcl` from the sample:

```bash
cp vars/build.pkrvars.hcl.sample vars/build.pkrvars.hcl
```

Edit `vars/build.pkrvars.hcl` with your Proxmox settings:

```hcl
proxmox_node = "pve"              # Your Proxmox node name
vm_id = 1100                       # Template VM ID
template_name = "kali-security"
template_name_suffix = "-2024.1"

# Update ISO path and checksum
iso_file = "local:iso/kali-linux-2024.1-installer-amd64.iso"
iso_checksum = "sha256:your-actual-checksum"

# Adjust resources based on your needs
cores = 4
memory = 4096
disk_size = "80G"
```

### 3. Set Environment Variables

Create `vars/env` from the sample:

```bash
cp vars/env.sample vars/env
```

Configure your Proxmox API credentials:

```bash
export PROXMOX_URL="https://your-proxmox-server:8006/api2/json"
export PROXMOX_USERNAME="root@pam"
export PROXMOX_TOKEN="your-api-token-id"
export PROXMOX_TOKEN_SECRET="your-api-token-secret"
```

Or source the env file:
```bash
source vars/env
```

### 4. Build the Template

```bash
# Initialize Packer
packer init .

# Format configuration files
packer fmt .

# Validate configuration
packer validate --var-file vars/build.pkrvars.hcl .

# Build the template
packer build --var-file vars/build.pkrvars.hcl .
```

**Note**: The build process can take 60-120 minutes due to the extensive tool installation. Ensure stable internet connectivity.

## Usage

### Creating VMs from Template

Once the template is created, clone it in Proxmox:

```bash
# Using Proxmox CLI
qm clone 1100 101 --name pentest-lab-01
qm set 101 --memory 8192
qm set 101 --cores 4

# Start the VM
qm start 101
```

Or use the Proxmox web UI to create linked clones.

### First Boot Configuration

After cloning and starting a VM:

```bash
# Update system
sudo apt update && sudo apt upgrade -y

# Update Kali metapackages
sudo apt install -y kali-linux-headless

# Verify key tools
nmap --version
msfconsole -v
burpsuite --version
hashcat --version
```

### Common Security Testing Workflows

#### Network Reconnaissance

```bash
# Quick network scan
nmap -sn 192.168.1.0/24

# Comprehensive scan
nmap -A -T4 -p- target.com

# Service enumeration
nmap -sV -sC -p- target.com

# Vulnerability scan with NSE
nmap --script vuln target.com
```

#### Web Application Testing

```bash
# Directory brute force
gobuster dir -u http://target.com -w /usr/share/wordlists/dirb/common.txt

# Fast fuzzing
ffuf -u http://target.com/FUZZ -w /usr/share/wordlists/dirbuster/directory-list-2.3-medium.txt

# SQL injection testing
sqlmap -u "http://target.com/page?id=1" --batch

# WordPress scanning
wpscan --url http://target.com --enumerate ap,at,cb,dbe
```

#### Password Attacks

```bash
# Hash cracking with hashcat
hashcat -m 0 -a 0 hashes.txt /usr/share/wordlists/rockyou.txt

# John the Ripper
john --wordlist=/usr/share/wordlists/rockyou.txt hashes.txt

# Network service brute force
hydra -L users.txt -P /usr/share/wordlists/rockyou.txt ssh://target.com
```

#### Wireless Security Testing

```bash
# Monitor mode
airmon-ng start wlan0

# Capture handshake
airodump-ng -c 6 --bssid XX:XX:XX:XX:XX:XX -w capture wlan0mon

# WPS attack
reaver -i wlan0mon -b XX:XX:XX:XX:XX:XX -vv

# Automated wireless attacks
wifite --kill
```

#### Metasploit Framework

```bash
# Start Metasploit
msfconsole

# Database setup (already initialized)
db_status

# Quick workspace
workspace -a pentest_project

# Host discovery
db_nmap -sn 192.168.1.0/24

# Exploitation
use exploit/windows/smb/ms17_010_eternalblue
set RHOSTS target.com
run
```

### Reporting and Documentation

```bash
# Start CherryTree for notes
cherrytree

# Export Metasploit data
msf > db_export -f xml /root/pentest_results.xml

# Generate custom reports
# Use Dradis for collaborative reporting
```

## Kali Linux Specifics

### Rolling Release Model

Kali uses a rolling release model with frequent updates:

```bash
# Full system update
sudo apt update && sudo apt full-upgrade -y

# Update specific tool
sudo apt install --only-upgrade metasploit-framework

# Clean up
sudo apt autoremove -y && sudo apt clean
```

### Kali Metapackages

Install additional tool sets as needed:

```bash
# Full Kali desktop environment
sudo apt install -y kali-linux-large

# All tools
sudo apt install -y kali-linux-everything

# Specific categories
sudo apt install -y kali-tools-802-11          # Wireless tools
sudo apt install -y kali-tools-gpu             # GPU cracking tools
sudo apt install -y kali-tools-hardware        # Hardware hacking
sudo apt install -y kali-tools-crypto-stego    # Cryptography
sudo apt install -y kali-tools-fuzzing         # Fuzzing tools
sudo apt install -y kali-tools-sdr             # Software defined radio
```

### Kali Services Management

```bash
# List all Kali services
kali-tweaks

# Start specific services
sudo systemctl start postgresql    # For Metasploit database
sudo systemctl start apache2       # For hosting payloads
sudo systemctl start ssh           # SSH server

# Enable services at boot
sudo systemctl enable postgresql
```

## Security Best Practices

### Network Isolation

**IMPORTANT**: Always use isolated networks for security testing:

```bash
# Create isolated vmbr1 on Proxmox for testing
# Edit VM network to use isolated bridge
qm set 101 --net0 virtio,bridge=vmbr1
```

### Legal and Ethical Considerations

⚠️ **WARNING**: Only perform security testing on systems you own or have explicit written permission to test. Unauthorized access is illegal.

- Obtain proper authorization before testing
- Use Kali Linux responsibly and ethically
- Keep detailed logs of all testing activities
- Follow responsible disclosure practices
- Comply with all applicable laws and regulations

### Credential Management

```bash
# Change default passwords immediately
passwd root
passwd kali

# Use SSH keys instead of passwords
ssh-keygen -t ed25519
```

### Tool Updates

```bash
# Update specific tools
sudo apt install --only-upgrade nmap
sudo msfupdate

# Update all tools
sudo apt update && sudo apt full-upgrade -y
```

## Customization

### Adding Custom Tools

Edit `kali-build.pkr.hcl` to add custom tools:

```hcl
provisioner "shell" {
  inline = [
    "apt-get install -y your-custom-tool",
    "pip3 install custom-python-package"
  ]
}
```

### Custom Scripts and Payloads

Store custom scripts in `/usr/local/bin`:

```bash
# Create custom script directory
mkdir -p /usr/local/bin/custom

# Add to PATH
echo 'export PATH=$PATH:/usr/local/bin/custom' >> ~/.bashrc
```

### Wordlist Management

```bash
# Common wordlist locations
/usr/share/wordlists/
/usr/share/seclists/
/usr/share/dirb/
/usr/share/dirbuster/
/usr/share/wfuzz/

# Extract rockyou
sudo gunzip /usr/share/wordlists/rockyou.txt.gz

# Download additional wordlists
git clone https://github.com/danielmiessler/SecLists.git /opt/SecLists
```

## Cloud-Init Configuration

Configure cloned VMs using Cloud-Init:

```bash
# Set SSH keys
qm set 101 --sshkey ~/.ssh/id_rsa.pub

# Set IP address
qm set 101 --ipconfig0 ip=192.168.1.100/24,gw=192.168.1.1

# Set DNS
qm set 101 --nameserver 8.8.8.8

# Set user credentials
qm set 101 --ciuser kali
qm set 101 --cipassword secure-password
```

## Troubleshooting

### Enable Packer Logging

```bash
export PACKER_LOG=1
packer build --var-file vars/build.pkrvars.hcl .
```

### Common Issues

**Preseed installation fails:**
- Verify Kali mirror accessibility
- Check preseed.cfg syntax
- Increase boot_wait time if needed
- Ensure sufficient disk space (80GB minimum)

**Tool installation errors:**
- Update package lists: `apt update`
- Check Kali repository configuration
- Verify network connectivity
- Some tools may require specific dependencies

**Out of disk space:**
- Increase disk_size to 80G or more
- Kali tools require significant storage
- Clean package cache regularly

**Network adapter issues:**
- Use virtio network model for best performance
- Some wireless tools require specific adapters
- Consider USB passthrough for physical wireless cards

**Metasploit database issues:**
- Initialize database: `msfdb init`
- Restart PostgreSQL: `systemctl restart postgresql`
- Rebuild database: `msfdb reinit`

## Performance Optimization

### Resource Allocation

For different use cases:

**Light reconnaissance:**
- 2 cores, 2GB RAM, 40GB disk

**General penetration testing:**
- 4 cores, 4GB RAM, 80GB disk

**Password cracking / Heavy testing:**
- 8 cores, 8-16GB RAM, 100GB+ disk
- Consider GPU passthrough for hashcat

### GPU Passthrough (Optional)

For password cracking with hashcat:

```bash
# Configure GPU passthrough in Proxmox
# Edit VM configuration to add GPU
qm set 101 --hostpci0 01:00,pcie=1

# Verify in VM
hashcat -I
```

### SSD Storage

Use SSD storage for:
- VM disk (faster tool loading)
- Wordlist storage (faster password attacks)
- Database operations (Metasploit, reporting)

## Maintenance

### Regular Updates

```bash
# Weekly updates
sudo apt update && sudo apt full-upgrade -y

# Update Metasploit
sudo msfupdate

# Clean up
sudo apt autoremove -y
sudo apt clean
```

### Backup Important Data

```bash
# Backup custom scripts
tar -czf custom-tools-backup.tar.gz /usr/local/bin/custom

# Backup notes and reports
tar -czf reports-backup.tar.gz /root/reports

# Backup configuration
tar -czf configs-backup.tar.gz /root/.config
```

## Use Cases

### Penetration Testing
- External and internal network testing
- Web application security assessments
- Wireless security audits
- Social engineering campaigns

### Security Auditing
- Vulnerability assessments
- Compliance testing
- Security posture evaluation
- Configuration reviews

### Digital Forensics
- Incident response
- Malware analysis
- Memory forensics
- File system analysis

### CTF Competitions
- Capture the Flag events
- Security training
- Skill development
- Challenge solving

### Security Research
- Vulnerability research
- Exploit development
- Tool development
- Proof of concept creation

## Useful Resources

- [Kali Linux Official Documentation](https://www.kali.org/docs/)
- [Kali Tools Documentation](https://www.kali.org/tools/)
- [Metasploit Unleashed](https://www.offensive-security.com/metasploit-unleashed/)
- [Penetration Testing Execution Standard](http://www.pentest-standard.org/)
- [OWASP Testing Guide](https://owasp.org/www-project-web-security-testing-guide/)
- [HackTricks](https://book.hacktricks.xyz/)
- [PayloadsAllTheThings](https://github.com/swisskyrepo/PayloadsAllTheThings)
- [Packer Proxmox Builder](https://www.packer.io/plugins/builders/proxmox/iso)
- [Cloud-Init Documentation](https://cloudinit.readthedocs.io/)

## Legal Disclaimer

This template is provided for educational and authorized security testing purposes only. Users must:

- Obtain explicit written permission before testing any systems
- Comply with all applicable laws and regulations
- Use tools responsibly and ethically
- Follow responsible disclosure practices
- Respect privacy and data protection laws

The authors and contributors are not responsible for misuse of this template or the tools included within.

## Contributing

Improvements and suggestions are welcome. Please ensure:
- Packer configurations are validated
- Documentation is updated for any changes
- Security tools are from official Kali repositories
- Legal and ethical guidelines are followed

## Version Information

- **Kali Linux**: 2024.1 (rolling release)
- **Kernel**: Latest from Kali repositories
- **Metasploit**: Latest version
- **Python**: 3.11+
- **Packer**: 1.9.1+
- **600+ Security Tools** from official Kali repositories

Last updated: 2025-11-14

---

**Remember**: With great power comes great responsibility. Use Kali Linux ethically and legally.
