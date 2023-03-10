<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_managed_disk.vm_managed_disk](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/managed_disk) | resource |
| [azurerm_virtual_machine_data_disk_attachment.vm_managed_disk_attachment](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_machine_data_disk_attachment) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_caching"></a> [caching](#input\_caching) | The type of caching which should be used for the managed disk. | `string` | n/a | yes |
| <a name="input_create_option"></a> [create\_option](#input\_create\_option) | The method to use when creating the managed disk. Empty and FromImage currently supported. | `string` | n/a | yes |
| <a name="input_disk_size_gb"></a> [disk\_size\_gb](#input\_disk\_size\_gb) | The size of the managed disk in GB. | `number` | n/a | yes |
| <a name="input_image_reference_id"></a> [image\_reference\_id](#input\_image\_reference\_id) | The id of an existing platform/marketplace disk image to copy. Requires create\_option to be FromImage. | `string` | `null` | no |
| <a name="input_location"></a> [location](#input\_location) | The location of the managed disk. | `string` | n/a | yes |
| <a name="input_lun"></a> [lun](#input\_lun) | The logical unit number of the managed disk. Each managed disk must have a unique lun. | `number` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | The name of the managed disk. | `string` | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | The name of the resource group this managed disk belongs to. | `string` | n/a | yes |
| <a name="input_storage_account_type"></a> [storage\_account\_type](#input\_storage\_account\_type) | The type of storage account which should be used for the managed disk. | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | A mapping of tags to apply to this managed disk. | `map(string)` | `null` | no |
| <a name="input_virtual_machine_id"></a> [virtual\_machine\_id](#input\_virtual\_machine\_id) | The id of the VM to attach the managed disk to. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_id"></a> [id](#output\_id) | The resource id of the managed disk. |
<!-- END_TF_DOCS -->