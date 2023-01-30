<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | n/a |
| <a name="provider_tls"></a> [tls](#provider\_tls) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_virtual_machine.vm](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_machine) | resource |
| [tls_private_key.vm_private_key](https://registry.terraform.io/providers/hashicorp/tls/latest/docs/resources/private_key) | resource |
| [azurerm_platform_image.vm_storage_image](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/platform_image) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_location"></a> [location](#input\_location) | The location of the VM. | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | The name of the VM. | `string` | n/a | yes |
| <a name="input_network_interface_ids"></a> [network\_interface\_ids](#input\_network\_interface\_ids) | The list of network interface ids this VM belongs to. | `list(string)` | n/a | yes |
| <a name="input_os_profile_admin_password"></a> [os\_profile\_admin\_password](#input\_os\_profile\_admin\_password) | The password of the admin user of the VM. | `string` | n/a | yes |
| <a name="input_os_profile_admin_username"></a> [os\_profile\_admin\_username](#input\_os\_profile\_admin\_username) | The username of the admin on the VM. | `string` | n/a | yes |
| <a name="input_output_admin_private_key"></a> [output\_admin\_private\_key](#input\_output\_admin\_private\_key) | Indicate whether the private ssh key for the VM should be outputted by Terraform. | `bool` | `false` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | The name of the resource group this VM belongs to. | `string` | n/a | yes |
| <a name="input_storage_os_disk_caching"></a> [storage\_os\_disk\_caching](#input\_storage\_os\_disk\_caching) | The type of caching which should be used for the internal OS disk. | `string` | n/a | yes |
| <a name="input_storage_os_disk_managed_disk_type"></a> [storage\_os\_disk\_managed\_disk\_type](#input\_storage\_os\_disk\_managed\_disk\_type) | The type of storage account which should be used for the internal OS disk. | `string` | n/a | yes |
| <a name="input_storage_os_disk_name"></a> [storage\_os\_disk\_name](#input\_storage\_os\_disk\_name) | The name of the internal OS disk. | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | A mapping of tags to apply to this VM. | `map(string)` | `null` | no |
| <a name="input_vm_size"></a> [vm\_size](#input\_vm\_size) | The SKU which should be used for this VM. | `string` | n/a | yes |
| <a name="input_vm_storage_image_sku"></a> [vm\_storage\_image\_sku](#input\_vm\_storage\_image\_sku) | The SKU of the rh-rhel image offer used to create the VM. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_admin_private_key"></a> [admin\_private\_key](#output\_admin\_private\_key) | n/a |
| <a name="output_id"></a> [id](#output\_id) | n/a |
<!-- END_TF_DOCS -->