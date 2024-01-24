variable "pm_api_url" {
  description = "Proxmox API URL"
  type        = string
}

variable "pm_node" {
  description = "Proxmox Node"
  type        = string
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
