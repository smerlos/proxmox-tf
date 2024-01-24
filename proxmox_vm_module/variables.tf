variable "pm_api_url" {
  description = "Proxmox API URL"
  type        = string
}

variable "pm_tls_insecure" {
  description = "Proxmox TLS Insecure"
  type        = bool
  default     = true
}

variable "pm_node" {
  description = "Proxmox Node"
  type        = string
}
variable "pm_storage" {
  description = "value of the storage parameter"
  type        = string
  default     = "local"
}

variable "vm_memory" {
  description = "Memory size for the VM in megabytes"
  type        = number
  default     = 2048
}

variable "vm_cores" {
  description = "Number of CPU cores for the VM"
  type        = number
  default     = 2
}

variable "vm_sockets" {
  description = "Number of CPU sockets for the VM"
  type        = number
  default     = 1
}

variable "vm_disk_size" {
  description = "Disk size for the VM, in gigabytes"
  type        = string
  default     = "32G"
}

variable "vm_storage_type" {
  description = "The storage type for the VM disk (e.g., qcow2, raw)"
  type        = string
  default     = "scsi"
}

variable "vm_network_bridge" {
  description = "The network bridge the VM will be connected to"
  type        = string
  default     = "vmbr1"
}

variable "vm_os_type" {
  description = "Type of the operating system for the VM"
  type        = string
  default     = "cloud-init"
}

variable "vm_template_name" {
  description = "Name of the VM template in Proxmox"
  type        = string
  default     = "ubuntu-2204-cloudinit-template"
}

variable "vms_cird" {
  description = "The CIDR block for the VMs"
  type        = string
  default     = "192.168.200.0/24"
}

variable "base_domain" {
  description = "The base domain for the VMs"
  type        = string
  default     = "compute.internal"
}

variable "vm_counts" {
  description = "The number of master nodes"
  type        = number
  default     = 1
}

variable "vm_vmid" {
  description = "VMID for the VMs"
  type        = number
  default     = 2000
}
variable "vm_scsihw" {
  description = "value of the scsihw parameter"
  type        = string
  default     = "virtio-scsi-pci"
}
variable "vm_bootdisk" {
  description = "value of the bootdisk parameter"
  type        = string
  default     = "scsi0"
}
variable "vm_cpu" {
  description = "value of the cpu parameter"
  type        = string
  default     = "host"
}
variable "base_ip" {
  description = "amount of ip addresses to skip"
  type        = number
  default     = 20
}

variable "vm_network_model" {
  description = "value of the network model parameter"
  type        = string
  default     = "virtio"
}

variable "vm_qemu_os" {
  description = "value of the os id parameter"
  type        = string
  default     = "l26"
}

variable "vm_disk_discard" {
  description = "value of the discard parameter"
  type        = string
  default     = "on"
}

variable "cloudinit_users" {
  description = "A list of users to configure on the machine."
  type = list(object({
    name : string
    gecos : string
    groups : string
    shell : string
    sudo : list(string)
    ssh_import_id : list(string)
  }))
  default = [
    {
      name : "smerlos",
      gecos : "smerlos",
      groups : "sudo, users, admin",
      shell : "/bin/bash",
      sudo : ["ALL=(ALL) NOPASSWD:ALL"],
      ssh_import_id : ["gh:smerlos"]
    }
  ]
}

variable "cloudinit_packages" {
  description = "A list of packages to be installed on the machine."
  type        = list(string)
  default = [
    "open-vm-tools",
    "build-essential",
    "python3-pip",
    "python3",
    "vim",
    "screen",
    "apt-transport-https",
    "ca-certificates",
    "curl",
    "wget",
    "git",
    "ack-grep",
    "open-iscsi",
    "ifupdown",
    "resolvconf",
    "qemu-guest-agent"
  ]
}

variable "cloudinit_runcmd" {
  description = "A list of commands to execute on the machine."
  type        = list(string)
  default = [
    "apt update",
    "apt upgrade -y",
    "apt install -f -y",
    "apt full-upgrade -y",
    "apt-get -y dist-upgrade -y",
    "apt autoremove -y",
    "systemctl start qemu-guest-agent"
  ]
}


variable "pm_user" {
  description = "proxmox user"
  type        = string
}

variable "pm_host" {
  description = "proxmox host"
  type        = string
  default     = ""
}

variable "pm_password" {
  description = "value of the api password parameter"
  type        = string
}
