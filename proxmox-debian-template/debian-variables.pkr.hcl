variable "preseed_url" {
  description = "Preseed file URL."
  type        = string
  default     = "http://{{ .HTTPIP }}:{{ .HTTPPort }}/preseed.cfg"
}

variable "proxmox_node" {
  description = "Proxmox node ID to create the template on."
  type        = string
}

variable "template_name" {
  description = "Name of the created template."
  type        = string
  default     = "debian"
}

variable "template_name_suffix" {
  description = "Suffix added to template_name, used to add Git commit hash or tag to template name."
  type        = string
  default     = ""
}

variable "template_description" {
  description = "Description of the created template."
  type        = string
  default     = <<EOF
Debian Linux cloud image with QEMU guest agent and cloud-init.
https://git.houseofkummer.com/homelab/devops/packer-debian
EOF
}