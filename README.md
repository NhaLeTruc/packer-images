# My Personal Packer image repository

All images are WIP and for lab usage only.

+ `*-ref*` are useful repositories which aided the creation of `*-template` repositories.
+ Each sub-repo has their own README.

## Grant Packer Access to Proxmox

```sh
# create a SSH key for Packer
ssh-keygen -o -a 100 -t ed25519 -f ~/.ssh/packer_id_ed25519 -C "Packer"
```

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
