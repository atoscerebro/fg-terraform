<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | >= 3.41.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | >= 3.41.0 |
| <a name="provider_tls"></a> [tls](#provider\_tls) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_linux_virtual_machine.vm](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/linux_virtual_machine) | resource |
| [azurerm_network_interface.default_nic](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_interface) | resource |
| [tls_private_key.vm_private_key](https://registry.terraform.io/providers/hashicorp/tls/latest/docs/resources/private_key) | resource |
| [azurerm_subnet.vm_subnet](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subnet) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_admin_username"></a> [admin\_username](#input\_admin\_username) | The username of the admin on the VM. | `string` | n/a | yes |
| <a name="input_location"></a> [location](#input\_location) | The location of the VM. | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | The name of the VM. | `string` | n/a | yes |
| <a name="input_os_profile_admin_password"></a> [os\_profile\_admin\_password](#input\_os\_profile\_admin\_password) | The password of the admin user of the VM. | `string` | `null` | no |
| <a name="input_output_admin_private_key"></a> [output\_admin\_private\_key](#input\_output\_admin\_private\_key) | Indicate whether the private ssh key for the VM should be outputted by Terraform. | `bool` | `true` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | The name of the resource group this VM belongs to. | `string` | n/a | yes |
| <a name="input_storage_os_disk_managed_disk_type"></a> [storage\_os\_disk\_managed\_disk\_type](#input\_storage\_os\_disk\_managed\_disk\_type) | The type of storage account which should be used for the internal OS disk. | `string` | `"Standard_LRS"` | no |
| <a name="input_storage_os_disk_name"></a> [storage\_os\_disk\_name](#input\_storage\_os\_disk\_name) | The name of the internal OS disk. | `string` | n/a | yes |
| <a name="input_subnet_name"></a> [subnet\_name](#input\_subnet\_name) | The subnet to place the VM into. | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | A mapping of tags to apply to this VM. | `map(string)` | `null` | no |
| <a name="input_virtual_network_name"></a> [virtual\_network\_name](#input\_virtual\_network\_name) | The vnet to place the VM into. | `string` | n/a | yes |
| <a name="input_vm_size"></a> [vm\_size](#input\_vm\_size) | The SKU which should be used for this VM. | `string` | `"Standard_DS1_v2"` | no |
| <a name="input_vm_storage_image_sku"></a> [vm\_storage\_image\_sku](#input\_vm\_storage\_image\_sku) | The SKU of the rh-rhel image offer used to create the VM. | `string` | `"9-lvm"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_admin_private_key"></a> [admin\_private\_key](#output\_admin\_private\_key) | The private SSH key assigned to the VM (optional). |
| <a name="output_id"></a> [id](#output\_id) | The resource id of the VM. |
<!-- END_TF_DOCS -->