terraform {
  required_providers {
    proxmox = {
      source  = "terraform.local/local/frostyfab" # FIXME: remove this when https://github.com/Telmate/terraform-provider-proxmox/issues/863 is resolved
      version = "~> 2.9"
    }
    local = {
      source  = "hashicorp/local"
      version = "2.1.0"
    }
    null = {
      source  = "hashicorp/null"
      version = "3.1.0"
    }
  }
  required_version = "1.6.5"
}

provider "proxmox" {
  pm_api_url      = var.pm_api_url
  pm_tls_insecure = var.pm_tls_insecure
  pm_log_enable   = true
  pm_log_file     = "terraform-plugin-proxmox.log"
  pm_debug        = true
  pm_log_levels = {
    _default    = "debug"
    _capturelog = ""
  }
}