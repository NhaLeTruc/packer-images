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
packer validate .
packer build --var-file vars/secrets.pkr.hcl .
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

## Useful Resources

- [Packer Proxmox ISO builder documentation](https://www.packer.io/docs/builders/proxmox/iso).
- [Proxmox wiki on creating a custom cloud image](https://pve.proxmox.com/wiki/Cloud-Init_FAQ#Creating_a_custom_cloud_image).
- [cloud-init documentation](https://cloudinit.readthedocs.io/en/latest/index.html).
- [Setting up Proxmox role with permissions for Packer](https://github.com/hashicorp/packer/issues/8463#issuecomment-726844945).
- [Official Alpine cloud image builder](https://gitlab.alpinelinux.org/alpine/cloud/alpine-cloud-images).
