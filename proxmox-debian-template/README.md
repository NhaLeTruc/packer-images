# Proxmox Debian VM templates

## Packer Debian

Packer configuration for building a Debian Linux 'cloud image' Proxmox template.

Features:

- Includes Cloud Init for configuration when cloning.
- Includes `sudo` and QEMU guest agent.
- Ready for configuration with Ansible.

## Usage

Modifies `\vars\build.pkrvars.hcl` and `\http\preseed.cfg` for customized vm template.

Reccommended variables

1. disk_size = "10G"

## Development

Required tools:

- Packer `v1.9.1`.

To create a Proxmox API token with correct privileges, [follow this guide](https://homelab.pages.houseofkummer.com/wiki/administrate/proxmox-api-tokens/).

### Build

Building only requires Packer.

Create a variable file `vars/build.pkrvars.hcl` for Proxmox VM's variables.
See `vars/build.pkrvars.hcl.sample` as an example.

Set `PROXMOX_URL`; `PROXMOX_USERNAME`; `PROXMOX_TOKEN`; etc as environment variables. See `vars/env.sample` as an example.
[See the Proxmox builder documentation](https://www.packer.io/plugins/builders/proxmox/iso) for more information.

Build with a template name suffix denoting the current commit, for example `2b1adb0`:

```sh
packer init .
packer fmt .
packer validate --var-file vars/build.pkrvars.hcl .
packer build -var "vm_id=905" -var "template_name_suffix=-12.10.0" --var-file vars/build.pkrvars.hcl .
```

## Troubleshooting

Set `PACKER_LOG=1` to enable logging for easier troubleshooting.

Avoid running Packer on Windows.
This repository, Packer and Debian all assume you are running on Linux.

## SSH setup

To set up SSH access for a virtual machine (VM), you'll need to ensure the VM's operating system has an SSH server installed and running, and that the firewall allows incoming connections on port 22 (or the configured SSH port).

Here's a breakdown of the process:
1. Install and Configure an SSH Server on the VM:
Install OpenSSH:
If you're using a Linux-based VM, install OpenSSH using your distribution's package manager (e.g., sudo apt-get install openssh-server on Debian/Ubuntu).

Start and Enable the SSH Service:
After installation, start the SSH service and enable it to start on boot (e.g., sudo systemctl start sshd, sudo systemctl enable sshd).

Verify SSH is Running:
Use a command like

```bash
ps -aef | grep sshd 
```

to confirm the SSH daemon (sshd) is running.

2. Open Firewall Port:
Check Firewall Rules: Ensure your VM's firewall (if any) allows incoming connections on port 22 (or your configured SSH port).
Add a Rule: If necessary, add a rule to allow SSH traffic on the specified port.

3. Configure SSH Keys (Optional but Recommended):
Generate SSH Key Pair: On your local machine, generate an SSH key pair using ssh-keygen.
Copy Public Key: Copy the public key to the VM's authorized keys file (~/.ssh/authorized_keys).
Connect with Private Key: Use your private key to connect to the VM using SSH.

4. Connect to the VM via SSH:
Open a Terminal:
Open a terminal or command prompt on your local machine.

Use the ssh Command:
Use the ssh command to connect to the VM, specifying the username, IP address, and optional port (if not 22). For example:

```bash
ssh username@vm_ip_address
```

First-Time Connection:
You may be prompted to confirm the server's fingerprint the first time you connect.

Provide Password or Use Key:
If you're using password-based authentication, provide the VM's user password. If using key-based authentication, the connection should establish automatically.

Example (Using Key-Based Authentication):
On your local machine:
Code

```bash
    ssh-keygen -t ed25519  # Generate a new key
```

On the VM:
Code

```bash
    mkdir -p ~/.ssh  # Create the .ssh directory if it doesn't exist
    touch ~/.ssh/authorized_keys  # Create the authorized_keys file
    chmod 700 ~/.ssh  # Set permissions for the directory
    chmod 600 ~/.ssh/authorized_keys  # Set permissions for the file
```

Copy your public key to the VM's ~/.ssh/authorized_keys file:
Code

```bash
    ssh-copy-id -i ~/.ssh/public_key.pub user@vm_ip_address
```

Connect to the VM:
Code

```bash
    ssh user@vm_ip_address

    # Remove old key from same reused IP.
    ssh-keygen -f "/root/.ssh/known_hosts" -R "XXX.XXX.X.XX"
```

### Ansible test

Assume inventory.ini is populated with a VM's ip, which has a public key inserted in it /.ssh directory and a username 'debian'.

```sh
ansible-inventory -i inventory.ini --list

ansible myhosts -m ping -i inventory.ini -u debian
```

### NOTE

- It is best to use cloud-init to prepare the VM with the ssh public key. See `http/cloud.cfg` for details.
- Cloud init config file `http/cloud.cfg` do not behave like `http/preseed.cfg`.
- `http/preseed.cfg` works for Debian OS.
- `http/cloud.cfg` works for Cloud-init. They do not cross-communicate.

## Useful Resources

- [Packer Proxmox ISO builder documentation](https://www.packer.io/docs/builders/proxmox/iso).
- [Proxmox wiki on creating a custom cloud image](https://pve.proxmox.com/wiki/Cloud-Init_FAQ#Creating_a_custom_cloud_image).
- [cloud-init documentation](https://cloudinit.readthedocs.io/en/latest/index.html).
- [Cloud-Init FAQ](https://pve.proxmox.com/wiki/Cloud-Init_FAQ#Creating_a_custom_cloud_image)
- [Setting up Proxmox role with permissions for Packer](https://github.com/hashicorp/packer/issues/8463#issuecomment-726844945).
- [Official Alpine cloud image builder](https://gitlab.alpinelinux.org/alpine/cloud/alpine-cloud-images).
- [How to Create an SSH Key in Linux: Easy Step-by-Step Guide](https://www.digitalocean.com/community/tutorials/how-to-configure-ssh-key-based-authentication-on-a-linux-server)
- [Packer Proxmox Templates](https://github.com/trfore/packer-proxmox-templates)
- [Packer Debian 11 (Bullseye) Template for Proxmox](https://github.com/jacaudi/packer-template-debian-11)
- [Packer](https://github.com/vrsf-homelab/packer)
- [Packer Debian](https://github.com/LKummer/packer-debian)
- [Using Packer and Proxmox to Build Templates](https://dev.to/umairk/using-packer-and-proxmox-to-build-templates-455f)
- [Debian 12 Bookworm cloud-init configs](https://gist.github.com/dazeb/fde301b5035e8af3b040c6109c3d8170)
- [Leveraging Cloud-init in Debian for Efficient Cloud Deployments](https://shape.host/resources/leveraging-cloud-init-in-debian-for-efficient-cloud-deployments)
