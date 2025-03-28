# Debian 12 golden image packer template

## Instructions

```sh
git clone https://github.com/den-is/packer-templates.git
cd packer-templates/debian12

## create vars.auto.pkrvars.hcl
touch vars.auto.pkrvars.hcl

## add variables with correct values
cat <<EOT >> vars.auto.pkrvars.hcl
iso             = "path_to_iso"
sha256sum       = "sha256sum_of_the_iso"
default_ssh_key = "public_ssh_key to include in the image"
bridge_nic      = "NIC to bridge to by default"
EOT

# Or provide values to variables using one of the supproted options.
# Environment variable `export PKR_VAR_bridge_nic="interface name"`
# or packer build  -var-file myvars.pkrvars.hcl
# or packer build  -var 'key=value'

## Run build
packer init .
# or `packer init -upgrade .`
packer build .
```
