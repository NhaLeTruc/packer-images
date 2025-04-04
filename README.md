# My Personal Packer image repository

All images are WIP and for lab usage

```sh
# create a SSH key for Packer
ssh-keygen -o -a 100 -t ed25519 -f ~/.ssh/packer_id_ed25519 -C "Packer"
```

## Grant Packer Access to Proxmox

```sh Grant Packer Access to Proxmox
# create role
pveum role add PackerUser --privs "Datastore.AllocateSpace Datastore.AllocateTemplate Datastore.Audit Sys.Audit Sys.Modify VM.Allocate VM.Audit VM.Clone VM.Config.CDROM VM.Config.Cloudinit VM.Config.CPU VM.Config.Disk VM.Config.HWType VM.Config.Memory VM.Config.Network VM.Config.Options VM.Console VM.Monitor VM.PowerMgmt"

# create group
pveum group add packer-users

# add permissions
pveum acl modify / -group packer-users -role PackerUser

# create user 'packer'
pveum useradd packer@pve -groups packer-users

# generate a token
pveum user token add packer@pve token -privsep 0
```

The last command will output a token value similar to the following:

```sh Example PVE Token
┌──────────────┬──────────────────────────────────────┐
│ key          │ value                                │
╞══════════════╪══════════════════════════════════════╡
│ full-tokenid │ packer@pve!token                     │
├──────────────┼──────────────────────────────────────┤
│ info         │ {"privsep":"0"}                      │
├──────────────┼──────────────────────────────────────┤
│ value        │ 782a7700-4010-4802-8f4d-820f1b226850 │
└──────────────┴──────────────────────────────────────┘
```

## Proxmox Environment Variables

```sh
export PROXMOX_URL='https://192.168.0.100:8006/api2/json'
export PROXMOX_USERNAME='user@pve!token'
export PROXMOX_TOKEN='xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx'
export PM_API_TOKEN_ID="$PROXMOX_USERNAME"
export PM_API_TOKEN_SECRET="$PROXMOX_TOKEN"
```

## Packer Commands

```sh
packer fmt .
packer init .
packer validate .
packer build .
```

## Test

Navigate to the `test` folder and run the tests:

```sh
cd test
go test ./...
```

### Format

Make sure to format HCL files before pushing.

```bash
packer fmt .
packer fmt test/example
```

### Test Linting and Formatting

Make sure to format and lint test files before pushing.

```bash
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
