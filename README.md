<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | 1.6.5 |

## Providers

No providers.

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_pm_api_url"></a> [pm\_api\_url](#input\_pm\_api\_url) | Proxmox API URL | `string` | n/a | yes |
| <a name="input_pm_host"></a> [pm\_host](#input\_pm\_host) | proxmox host | `string` | `""` | no |
| <a name="input_pm_node"></a> [pm\_node](#input\_pm\_node) | Proxmox Node | `string` | n/a | yes |
| <a name="input_pm_password"></a> [pm\_password](#input\_pm\_password) | value of the api password parameter | `string` | n/a | yes |
| <a name="input_pm_user"></a> [pm\_user](#input\_pm\_user) | proxmox user | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_kubernetes_configuration"></a> [kubernetes\_configuration](#output\_kubernetes\_configuration) | n/a |
<!-- END_TF_DOCS -->