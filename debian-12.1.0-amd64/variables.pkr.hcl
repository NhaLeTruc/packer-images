packer {
  required_plugins {
    qemu = {
      version = "~> 1"
      source  = "github.com/hashicorp/qemu"
    }
    ansible = {
      version = "~> 1"
      source = "github.com/hashicorp/ansible"
    }
    vagrant = {
      source  = "github.com/hashicorp/vagrant"
      version = "~> 1"
    }
  }
}

variable "disk_size" {
  type = string
  default = "25G"
}

variable "vm_memory" {
  type = number
  default = 4096
}

variable "vm_cpu" {
  type = number
  default = 2
}

variable "iso_url" {
  type = string
  default = "debian-12.4.0-amd64-netinst.iso"
}

variable "iso_checksum" {
  type = string
  default = "sha256:64d727dd5785ae5fcfd3ae8ffbede5f40cca96f1580aaa2820e8b99dae989d94"
}