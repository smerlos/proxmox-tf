# Copyright (c) 2024
#
# Permission is hereby granted, free of charge, to any person obtaining a copy of
# this software and associated documentation files (the "Software"), to deal in
# the Software without restriction, including without limitation the rights to
# use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
# the Software, and to permit persons to whom the Software is furnished to do so,
# subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
# FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
# COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
# IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
# CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

module "ha_proxy" {
  source       = "./proxmox_vm_module"
  vm_disk_size = "40G"
  base_ip      = 20
  vm_counts    = 2
  vm_memory    = 1024 * 2
  vm_vmid      = 1000
  pm_host      = var.pm_host
  pm_user      = var.pm_user
  pm_password  = var.pm_password
  pm_node      = var.pm_node
  pm_api_url   = var.pm_api_url
}

module "k8s_master" {
  source      = "./proxmox_vm_module"
  base_ip     = 30
  vm_counts   = 3
  vm_memory   = 1024 * 4
  vm_vmid     = 1100
  pm_host     = var.pm_host
  pm_user     = var.pm_user
  pm_password = var.pm_password
  pm_node     = var.pm_node
  pm_api_url  = var.pm_api_url
}

module "k8s_worker" {
  source      = "./proxmox_vm_module"
  base_ip     = 40
  vm_counts   = 3
  vm_memory   = 1024 * 8
  vm_vmid     = 1200
  pm_host     = var.pm_host
  pm_user     = var.pm_user
  pm_password = var.pm_password
  pm_node     = var.pm_node
  pm_api_url  = var.pm_api_url
}

output "kubernetes_configuration" {
  value = yamlencode({
    kubernetes = {
      loadBalancers = {
        enabled = true
        hosts = [for ip in module.ha_proxy.vm_ips : {
          name = replace(replace(element(split("/", element(split(",", ip), 0)), 0), ".", "-"), "ip=", ""),
          ip   = replace(element(split("/", element(split(",", ip), 0)), 0), "ip=", "")
        }]
      }
      masters = {
        hosts = [for ip in module.k8s_master.vm_ips : {
          name = replace(replace(element(split("/", element(split(",", ip), 0)), 0), ".", "-"), "ip=", ""),
          ip   = replace(element(split("/", element(split(",", ip), 0)), 0), "ip=", "")
        }]
      }
      nodes = [{
        name = "worker"
        hosts = [for ip in module.k8s_worker.vm_ips : {
          name = replace(replace(element(split("/", element(split(",", ip), 0)), 0), ".", "-"), "ip=", ""),
          ip   = replace(element(split("/", element(split(",", ip), 0)), 0), "ip=", "")
        }]
      }]
    }
  })
}

