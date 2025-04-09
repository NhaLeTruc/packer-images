# Proxmox Debian VM templates

# Packer Debian

Packer configuration for building a Debian Linux 'cloud image' Proxmox template.

Features:

- Includes Cloud Init for configuration when cloning.
- Includes `sudo` and QEMU guest agent.
- Ready for configuration with Ansible.
- Tested with Terratest.

## Usage

This template is meant for use [with terraform-proxmox machine module](https://github.com/LKummer/terraform-proxmox/tree/main/modules/machine).

```hcl
module "example_vm" {
  source = "github.com/LKummer/terraform-proxmox//modules/machine"

  proxmox_template = "debian-12.7.0-1"
  # ...
}
```

See [terraform-proxmox machine example for more details](https://github.com/LKummer/terraform-proxmox/tree/main/examples/machine).

## Development

Required tools:

- Packer `v1.9.1`.
- Terraform `v1.4.6`.
- Go `1.18.2`.

To create a Proxmox API token with correct privileges, [follow this guide](https://homelab.pages.houseofkummer.com/wiki/administrate/proxmox-api-tokens/).

### Build

Building only requires Packer.

Create a variable file `secrets.pkr.hcl` for Proxmox credentials and other variables.
See `secrets.example.pkr.hcl` as an example.

Set `PROXMOX_URL`, `PROXMOX_USERNAME` and `PROXMOX_TOKEN` environment variables.
[See the Proxmox builder documentation](https://www.packer.io/plugins/builders/proxmox/iso) for more information.

Build with a template name suffix denoting the current commit, for example `2b1adb0`:

```sh
packer init .
packer fmt .
packer validate --var-file vars/build.pkrvars.hcl .
packer build --var-file vars/build.pkrvars.hcl .
```

### Test

Testing requires `PROXMOX_URL`, `PROXMOX_USERNAME`, `PROXMOX_TOKEN`, `PM_API_TOKEN_ID` and `PM_API_TOKEN_SECRET` environment variables set, as well as `secrets.pkr.hcl` (see `secrets.example.pkr.hcl`).

For testing and development it is recommended to use a `.env` file to manage credentials.
For example:

```sh
export PROXMOX_URL='https://192.168.0.100:8006/api2/json'
export PROXMOX_USERNAME='user@pve!token'
export PROXMOX_TOKEN='xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx'
export PM_API_TOKEN_ID="$PROXMOX_USERNAME"
export PM_API_TOKEN_SECRET="$PROXMOX_TOKEN"
```

Navigate to the `test` folder and run the tests:

```sh
cd test
go test ./...
```

### Format

Make sure to format HCL files before pushing.

```
packer fmt .
packer fmt test/example
```

### Test Linting and Formatting

Make sure to format and lint test files before pushing.

```
cd test
gofmt -w .
golangci-lint run
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
```

### Ansible test

Assume inventory.ini is populated with a VM's ip, which has a public key inserted in it /.ssh directory and a username 'debian'.

```sh
ansible-inventory -i inventory.ini --list

ansible myhosts -m ping -i inventory.ini -u debian
```

### NOTE

- It is best to preseed the VM with the ssh public key. See "Permission denied publickey" below.
- If failed to preseed public key. You need to find a way to login the VM console (cloud-init is one such method).
- Then edit "/etc/ssh/sshd_config" (debian machines) for "PasswordAuthentication yes" in order to login with username/password.

## Useful Resources

- [Packer Proxmox ISO builder documentation](https://www.packer.io/docs/builders/proxmox/iso).
- [Proxmox wiki on creating a custom cloud image](https://pve.proxmox.com/wiki/Cloud-Init_FAQ#Creating_a_custom_cloud_image).
- [cloud-init documentation](https://cloudinit.readthedocs.io/en/latest/index.html).
- [Setting up Proxmox role with permissions for Packer](https://github.com/hashicorp/packer/issues/8463#issuecomment-726844945).
- [Official Alpine cloud image builder](https://gitlab.alpinelinux.org/alpine/cloud/alpine-cloud-images).
- [How to Create an SSH Key in Linux: Easy Step-by-Step Guide](https://www.digitalocean.com/community/tutorials/how-to-configure-ssh-key-based-authentication-on-a-linux-server)
- [Permission denied publickey](https://serverfault.com/questions/684346/ssh-copy-id-permission-denied-publickey)