<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | 1.6.5 |
| <a name="requirement_local"></a> [local](#requirement\_local) | 2.1.0 |
| <a name="requirement_null"></a> [null](#requirement\_null) | 3.1.0 |
| <a name="requirement_proxmox"></a> [proxmox](#requirement\_proxmox) | ~> 2.9 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_local"></a> [local](#provider\_local) | 2.1.0 |
| <a name="provider_null"></a> [null](#provider\_null) | 3.1.0 |
| <a name="provider_proxmox"></a> [proxmox](#provider\_proxmox) | ~> 2.9 |

## Resources

| Name | Type |
|------|------|
| [local_file.cloud_init_user_data_file](https://registry.terraform.io/providers/hashicorp/local/2.1.0/docs/resources/file) | resource |
| [null_resource.cloud_init_config_files](https://registry.terraform.io/providers/hashicorp/null/3.1.0/docs/resources/resource) | resource |
| proxmox_vm_qemu.cloudinit-vm | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_base_domain"></a> [base\_domain](#input\_base\_domain) | The base domain for the VMs | `string` | `"compute.internal"` | no |
| <a name="input_base_ip"></a> [base\_ip](#input\_base\_ip) | amount of ip addresses to skip | `number` | `20` | no |
| <a name="input_cloudinit_packages"></a> [cloudinit\_packages](#input\_cloudinit\_packages) | A list of packages to be installed on the machine. | `list(string)` | <pre>[<br>  "open-vm-tools",<br>  "build-essential",<br>  "python3-pip",<br>  "python3",<br>  "vim",<br>  "screen",<br>  "apt-transport-https",<br>  "ca-certificates",<br>  "curl",<br>  "wget",<br>  "git",<br>  "ack-grep",<br>  "open-iscsi",<br>  "ifupdown",<br>  "resolvconf",<br>  "qemu-guest-agent"<br>]</pre> | no |
| <a name="input_cloudinit_runcmd"></a> [cloudinit\_runcmd](#input\_cloudinit\_runcmd) | A list of commands to execute on the machine. | `list(string)` | <pre>[<br>  "apt update",<br>  "apt upgrade -y",<br>  "apt install -f -y",<br>  "apt full-upgrade -y",<br>  "apt-get -y dist-upgrade -y",<br>  "apt autoremove -y",<br>  "systemctl start qemu-guest-agent"<br>]</pre> | no |
| <a name="input_cloudinit_users"></a> [cloudinit\_users](#input\_cloudinit\_users) | A list of users to configure on the machine. | <pre>list(object({<br>    name : string<br>    gecos : string<br>    groups : string<br>    shell : string<br>    sudo : list(string)<br>    ssh_import_id : list(string)<br>  }))</pre> | <pre>[<br>  {<br>    "gecos": "smerlos",<br>    "groups": "sudo, users, admin",<br>    "name": "smerlos",<br>    "shell": "/bin/bash",<br>    "ssh_import_id": [<br>      "gh:smerlos"<br>    ],<br>    "sudo": [<br>      "ALL=(ALL) NOPASSWD:ALL"<br>    ]<br>  }<br>]</pre> | no |
| <a name="input_pm_api_url"></a> [pm\_api\_url](#input\_pm\_api\_url) | Proxmox API URL | `string` | n/a | yes |
| <a name="input_pm_host"></a> [pm\_host](#input\_pm\_host) | proxmox host | `string` | `""` | no |
| <a name="input_pm_node"></a> [pm\_node](#input\_pm\_node) | Proxmox Node | `string` | n/a | yes |
| <a name="input_pm_password"></a> [pm\_password](#input\_pm\_password) | value of the api password parameter | `string` | n/a | yes |
| <a name="input_pm_storage"></a> [pm\_storage](#input\_pm\_storage) | value of the storage parameter | `string` | `"local"` | no |
| <a name="input_pm_tls_insecure"></a> [pm\_tls\_insecure](#input\_pm\_tls\_insecure) | Proxmox TLS Insecure | `bool` | `true` | no |
| <a name="input_pm_user"></a> [pm\_user](#input\_pm\_user) | proxmox user | `string` | n/a | yes |
| <a name="input_vm_bootdisk"></a> [vm\_bootdisk](#input\_vm\_bootdisk) | value of the bootdisk parameter | `string` | `"scsi0"` | no |
| <a name="input_vm_cores"></a> [vm\_cores](#input\_vm\_cores) | Number of CPU cores for the VM | `number` | `2` | no |
| <a name="input_vm_counts"></a> [vm\_counts](#input\_vm\_counts) | The number of master nodes | `number` | `1` | no |
| <a name="input_vm_cpu"></a> [vm\_cpu](#input\_vm\_cpu) | value of the cpu parameter | `string` | `"host"` | no |
| <a name="input_vm_disk_discard"></a> [vm\_disk\_discard](#input\_vm\_disk\_discard) | value of the discard parameter | `string` | `"on"` | no |
| <a name="input_vm_disk_size"></a> [vm\_disk\_size](#input\_vm\_disk\_size) | Disk size for the VM, in gigabytes | `string` | `"32G"` | no |
| <a name="input_vm_memory"></a> [vm\_memory](#input\_vm\_memory) | Memory size for the VM in megabytes | `number` | `2048` | no |
| <a name="input_vm_network_bridge"></a> [vm\_network\_bridge](#input\_vm\_network\_bridge) | The network bridge the VM will be connected to | `string` | `"vmbr1"` | no |
| <a name="input_vm_network_model"></a> [vm\_network\_model](#input\_vm\_network\_model) | value of the network model parameter | `string` | `"virtio"` | no |
| <a name="input_vm_os_type"></a> [vm\_os\_type](#input\_vm\_os\_type) | Type of the operating system for the VM | `string` | `"cloud-init"` | no |
| <a name="input_vm_qemu_os"></a> [vm\_qemu\_os](#input\_vm\_qemu\_os) | value of the os id parameter | `string` | `"l26"` | no |
| <a name="input_vm_scsihw"></a> [vm\_scsihw](#input\_vm\_scsihw) | value of the scsihw parameter | `string` | `"virtio-scsi-pci"` | no |
| <a name="input_vm_sockets"></a> [vm\_sockets](#input\_vm\_sockets) | Number of CPU sockets for the VM | `number` | `1` | no |
| <a name="input_vm_storage_type"></a> [vm\_storage\_type](#input\_vm\_storage\_type) | The storage type for the VM disk (e.g., qcow2, raw) | `string` | `"scsi"` | no |
| <a name="input_vm_template_name"></a> [vm\_template\_name](#input\_vm\_template\_name) | Name of the VM template in Proxmox | `string` | `"ubuntu-2204-cloudinit-template"` | no |
| <a name="input_vm_vmid"></a> [vm\_vmid](#input\_vm\_vmid) | VMID for the VMs | `number` | `2000` | no |
| <a name="input_vms_cird"></a> [vms\_cird](#input\_vms\_cird) | The CIDR block for the VMs | `string` | `"192.168.200.0/24"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_vm_ips"></a> [vm\_ips](#output\_vm\_ips) | n/a |
<!-- END_TF_DOCS -->