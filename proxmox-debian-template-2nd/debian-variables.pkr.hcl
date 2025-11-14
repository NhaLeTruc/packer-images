############################################
### Admin block
############################################

variable "tls_bool" {
  description = "Skip validating tls certificate."
  type        = bool
  default     = true
}

variable "proxmox_node" {
  description = "Proxmox node ID to create the template on."
  type        = string
  default     = "pve"
}

variable "vm_id" {
  description = "The ID used to reference the virtual machine. This will also be the ID of the final template."
  type        = number
  default     = 0 # next available id
}

variable "template_name" {
  description = "Name of the created template."
  type        = string
  default     = "debian-dataeng"
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
Debian 12 (Bookworm) cloud image optimized for Data Engineering.
Includes: Apache Spark 3.5.0, Scala 2.12, Python 3 with PySpark, Hadoop 3.3.6,
Jupyter, Docker, and comprehensive data science libraries (pandas, numpy, scikit-learn).
Ready for PySpark and Scala Spark workloads with QEMU guest agent and cloud-init.
Rock-solid Debian stability with production-grade reliability.
EOF
}


############################################
### boot_iso block
############################################

variable "iso_type" {
  description = "Bus type that the ISO will be mounted on. Can be ide, sata or scsi. Defaults to ide."
  type        = string
  default     = "scsi"
}

variable "iso_file" {
  description = "Path to the ISO file to boot from, expressed as a proxmox datastore path."
  type        = string
}

variable "iso_checksum" {
  description = "The checksum for the ISO file or virtual hard drive file."
  type        = string
}

variable "iso_unmount" {
  description = "If true, remove the mounted ISO from the template after finishing."
  type        = bool
  default     = true
}


############################################
### Hardwares block
############################################

variable "scsi_controller" {
  description = "The SCSI controller model to emulate. Can be lsi, lsi53c810, virtio-scsi-pci, virtio-scsi-single, megasas, or pvscsi. Defaults to lsi."
  type        = string
  default     = "virtio-scsi-single"
}

variable "os" {
  description = "The operating system. Can be wxp, w2k, w2k3, w2k8, wvista, win7, win8, win10, l24 (Linux 2.4), l26 (Linux 2.6+), solaris or other. Defaults to other."
  type        = string
  default     = "l26"
}

variable "machine" {
  description = "Set the machine type. Supported values are ''; 'pc' or 'q35'."
  type        = string
  default     = ""
}

variable "bios" {
  description = "Set the machine bios. This can be set to ovmf or seabios."
  type        = string
  default     = ""
}

variable "qemu_agent" {
  description = "Enables QEMU Agent option for this VM. When enabled, then qemu-guest-agent must be installed on the guest. When disabled, then ssh_host should be used. Defaults to true."
  type        = bool
  default     = true
}

variable "cloud_init" {
  description = "If true, add an empty Cloud-Init CDROM drive after the virtual machine has been converted to a template. Defaults to false."
  type        = bool
  default     = true
}

variable "cloud_init_storage_pool" {
  description = "Name of the Proxmox storage pool to store the Cloud-Init CDROM on. If not given, the storage pool of the boot device will be used."
  type        = string
  default     = "local-lvm"
}

variable "cores" {
  description = "How many CPU cores to give the virtual machine. Defaults to 1."
  type        = number
  default     = 4
}

variable "sockets" {
  description = "How many CPU sockets to give the virtual machine. Defaults to 1."
  type        = number
  default     = 1
}

variable "memory" {
  description = "How much memory (in megabytes) to give the virtual machine."
  type        = number
  default     = 8192
}

variable "cpu_type" {
  description = "The CPU type to emulate. For best performance, set this to host. Defaults to kvm64."
  type        = string
  default     = "host"
}


############################################
### network_adapters block
############################################
variable "network_bridge" {
  description = "Required. Which Proxmox bridge to attach the adapter to."
  type        = string
  default     = "vmbr0"
}

variable "network_model" {
  description = "Model of the virtual network adapter. Can be rtl8139, ne2k_pci, e1000, pcnet, virtio, ne2k_isa, i82551, i82557b, i82559er, vmxnet3, e1000-82540em, e1000-82544gc or e1000-82545em. Defaults to e1000."
  type        = string
  default     = "virtio"
}


############################################
### disks block
############################################
variable "disk_type" {
  description = "The type of disk. Can be scsi, sata, virtio or ide. Defaults to scsi."
  type        = string
  default     = "scsi"
}

variable "disk_size" {
  description = "The size of the disk, including a unit suffix, such as 10G to indicate 10 gigabytes."
  type        = string
  default     = "50G"
}

variable "disk_format" {
  description = "The format of the file backing the disk. Can be raw, cow, qcow, qed, qcow2, vmdk or cloop. Defaults to raw."
  type        = string
  default     = "raw"
}

variable "storage_pool" {
  description = "Required. Name of the Proxmox storage pool to store the virtual machine disk on."
  type        = string
  default     = "local-lvm"
}

variable "io_thread" {
  description = " Create one I/O thread per storage controller, rather than a single thread for all I/O. This can increase performance when multiple disks are used. Requires virtio-scsi-single controller and a scsi or virtio disk. Defaults to false."
  type        = bool
  default     = true
}


############################################
### SSH block
############################################
variable "http_directory" {
  description = "Path to a directory to serve using an HTTP server. The files in this directory will be available over HTTP that will be requestable from the virtual machine. This is useful for hosting kickstart files and so on. By default this is an empty string, which means no HTTP server will be started."
  type        = string
  default     = "http"
}

variable "ssh_username" {
  description = "Packer username for ssh into vm during creation progress"
  type        = string
  default     = "root"
}

variable "ssh_password" {
  description = "Packer password for ssh into vm during creation progress"
  type        = string
  default     = "packer"
}

variable "ssh_timeout" {
  description = "Packer wait time for vm to make ssh port available. Adjust base on vm boot requirements"
  type        = string
  default     = "30m"
}

variable "ssh_port" {
  description = "Default ssh port on vm"
  type        = number
  default     = 22
}


############################################
### Boot block
############################################
variable "boot_wait" {
  description = "(duration string | ex: 1h5m2s) - The time to wait after booting the initial virtual machine before typing the boot_command. The value of this should be a duration. Examples are 5s and 1m30s which will cause Packer to wait five seconds and one minute 30 seconds, respectively. If this isn't specified, the default is 10s or 10 seconds. To set boot_wait to 0s, use a negative number, such as -1s"
  type        = string
  default     = "10s"
}

variable "preseed_url" {
  description = "Preseed file URL."
  type        = string
  default     = "http://{{ .HTTPIP }}:{{ .HTTPPort }}/preseed.cfg"
}
