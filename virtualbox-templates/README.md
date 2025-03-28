# Golder OS images tempalates for Hashicorp Packer

Golder OS images templates for Hashicorp [Packer](https://www.packer.io/)

Provided golden OS images templates have very basic and relaxed configurations.

Feel free to adopt packer and provisioner scripts to your needs. Use provided templates as a starting point for your own project.

By default building images for [VirtualBox](https://www.virtualbox.org/), with more providers potentially to come.

## Instructions
```sh
git clone https://github.com/den-is/packer-templates.git

cd packer-templates
# cd to desired OS template dir
cd debian12

# Provide appropriate values to vars listed in `main.pkr.hcl`
# Using any available method listed here:
# https://developer.hashicorp.com/packer/guides/hcl/variables

# init project. this will download required_plugins listed in `main.pkr.hcl`
packer init .

# build
packer build .

# track progress and get build artifact from the `./output/` dir (created by packer automatically)
```
