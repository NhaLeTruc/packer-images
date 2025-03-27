packer {
  required_plugins {
    name = {
      version = "1.1.6"
      source  = "github.com/hashicorp/proxmox"
    }
  }
}
variable "bios_type" {
  type = string
}
variable "boot_command" {
  type = string
}
variable "boot_wait" {
  type = string
}
variable "bridge_firewall" {
  type    = bool
  default = false
}
variable "bridge_name" {
  type = string
}
variable "cloud_init" {
  type = bool
}
variable "iso_file" {
  type = string
}
variable "iso_storage_pool" {
  type    = string
  default = "local"
}
variable "machine_default_type" {
  type    = string
  default = "pc"
}
variable "network_model" {
  type    = string
  default = "virtio"
}
variable "os_type" {
  type    = string
  default = "l26"
}
variable "proxmox_api_token_id" {
  type = string
}
variable "proxmox_api_token_secret" {
  type      = string
  sensitive = true
}
variable "proxmox_api_url" {
  type = string
}
variable "proxmox_node" {
  type = string
}
variable "qemu_agent_activation" {
  type    = bool
  default = true
}
variable "scsi_controller_type" {
  type = string
}
variable "ssh_timeout" {
  type = string
}
variable "tags" {
  type = string
}
variable "io_thread" {
  type = bool
}
variable "cpu_type" {
  type    = string
  default = "kvm64"
}
variable "vm_info" {
  type = string
}
variable "disk_discard" {
  type    = bool
  default = true
}
variable "disk_format" {
  type    = string
  default = "qcow2"
}
variable "disk_size" {
  type    = string
  default = "16G"
}
variable "disk_type" {
  type    = string
  default = "scsi"
}
variable "nb_core" {
  type    = number
  default = 1
}
variable "nb_cpu" {
  type    = number
  default = 1
}
variable "nb_ram" {
  type    = number
  default = 1024
}
variable "ssh_username" {
  type = string
}
variable "ssh_password" {
  type = string
}
variable "ssh_handshake_attempts" {
  type = number
}
variable "storage_pool" {
  type    = string
  default = "local-lvm"
}
variable "vm_id" {
  type    = number
  default = 99999
}
variable "vm_name" {
  type = string
}
