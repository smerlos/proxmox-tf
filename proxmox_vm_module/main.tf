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

resource "proxmox_vm_qemu" "cloudinit-vm" {
  count       = var.vm_counts
  qemu_os     = var.vm_qemu_os
  name        = "${replace(cidrhost(var.vms_cird, var.base_ip + count.index), ".", "-")}.${var.base_domain}"
  target_node = var.pm_node
  vmid        = var.vm_vmid + count.index
  clone       = var.vm_template_name
  cores       = var.vm_cores
  sockets     = var.vm_sockets
  memory      = var.vm_memory
  os_type     = var.vm_os_type
  scsihw      = var.vm_scsihw
  bootdisk    = var.vm_bootdisk
  cpu         = var.vm_cpu
  cicustom    = "user=local:snippets/user_data_vm_${var.vm_vmid + count.index}.yml"
  ipconfig0   = "ip=${cidrhost(var.vms_cird, var.base_ip + count.index)}/24,gw=${cidrhost(var.vms_cird, 1)}"
  disk {
    size    = var.vm_disk_size
    type    = var.vm_storage_type
    storage = var.pm_storage
    discard = var.vm_disk_discard
  }
  network {
    model  = var.vm_network_model
    bridge = var.vm_network_bridge
  }
  depends_on = [null_resource.cloud_init_config_files]
}
resource "local_file" "cloud_init_user_data_file" {
  count = var.vm_counts
  content = templatefile("${path.module}/cloud-init/cloud_config.tftpl", {
    hostname      = "${replace(cidrhost(var.vms_cird, var.base_ip + count.index), ".", "-")}.${var.base_domain}",
    users_yaml    = indent(2, yamlencode(var.cloudinit_users)),
    packages_yaml = indent(2, yamlencode(var.cloudinit_packages)),
    runcmd_yaml   = indent(2, yamlencode(var.cloudinit_runcmd))
  })
  filename = yamldecode("${path.module}/cloud-inits/user_data_vm_${var.vm_vmid + count.index}.yml")
}


resource "null_resource" "cloud_init_config_files" {
  count = var.vm_counts
  connection {
    type     = "ssh"
    host     = var.pm_host
    password = var.pm_password
    user     = var.pm_user
  }

  provisioner "file" {
    source      = local_file.cloud_init_user_data_file[count.index].filename
    destination = "/var/lib/vz/snippets/user_data_vm_${var.vm_vmid + count.index}.yml"
  }
  depends_on = [local_file.cloud_init_user_data_file]
}

output "vm_ips" {
  value = [for vm in proxmox_vm_qemu.cloudinit-vm : vm.ipconfig0]
}