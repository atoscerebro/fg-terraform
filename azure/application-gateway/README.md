<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | >=3.41.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | >=3.41.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_application_gateway.application_gateway](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/application_gateway) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_backend_address_pools"></a> [backend\_address\_pools](#input\_backend\_address\_pools) | A list of (at least one) backend address pools used by the application gateway. | <pre>list(object({<br>    name         = string<br>    fqdns        = optional(list(string))<br>    ip_addresses = optional(list(string))<br>  }))</pre> | n/a | yes |
| <a name="input_backend_http_settings"></a> [backend\_http\_settings](#input\_backend\_http\_settings) | A list of (at least one) backend http settings used by the application gateway. | <pre>list(object({<br>    name                  = string<br>    cookie_based_affinity = string<br>    affinity_cookie_name  = optional(string)<br>    protocol              = string<br>    port                  = number<br>  }))</pre> | n/a | yes |
| <a name="input_firewall"></a> [firewall](#input\_firewall) | The web application firewall configuration for the application gateway. | <pre>object({<br>    firewall_policy_id                = optional(string)<br>    force_firewall_policy_association = optional(bool)<br>    firewall_mode                     = string<br>    rule_set_type                     = optional(string)<br>    rule_set_version                  = string<br>    disabled_rule_groups = optional(list(object({<br>      rule_group_name = string<br>      rules           = optional(list(string))<br>    })))<br>    exclusions = optional(list(object({<br>      match_variable          = string<br>      selector                = optional(string)<br>      selector_match_operator = optional(string)<br>    })))<br>  })</pre> | n/a | yes |
| <a name="input_frontend_ip_configurations"></a> [frontend\_ip\_configurations](#input\_frontend\_ip\_configurations) | A list of (at least one) ip configurations used by http listeners to listen for frontend traffic. | <pre>list(object({<br>    name                 = string<br>    subnet_id            = optional(string)<br>    private_ip_address   = optional(string)<br>    public_ip_address_id = optional(string)<br>  }))</pre> | n/a | yes |
| <a name="input_frontend_ports"></a> [frontend\_ports](#input\_frontend\_ports) | A list of (at least one) ports used by http listeners to listen for frontend traffic. | <pre>list(object({<br>    name = string<br>    port = number<br>  }))</pre> | n/a | yes |
| <a name="input_gateway_ip_configurations"></a> [gateway\_ip\_configurations](#input\_gateway\_ip\_configurations) | A list of (at least one) gateway ip configurations for the application gateway. | <pre>list(object({<br>    name      = string<br>    subnet_id = string<br>  }))</pre> | n/a | yes |
| <a name="input_http_listeners"></a> [http\_listeners](#input\_http\_listeners) | A list of (at least one) http listeners used on the frontend of the application gateway. | <pre>list(object({<br>    name                           = string<br>    frontend_ip_configuration_name = string<br>    frontend_port_name             = string<br>    protocol                       = string<br>    firewall_policy_id             = optional(string)<br>  }))</pre> | n/a | yes |
| <a name="input_location"></a> [location](#input\_location) | The location of the application gateway. | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | The name of the application gateway. | `string` | n/a | yes |
| <a name="input_request_routing_rules"></a> [request\_routing\_rules](#input\_request\_routing\_rules) | A list of (at least one) request routing rules that match http listeners to backend address pools and settings, optionally via path rules. | <pre>list(object({<br>    name                       = string<br>    rule_type                  = string<br>    http_listener_name         = string<br>    backend_address_pool_name  = optional(string)<br>    backend_http_settings_name = optional(string)<br>    url_path_map_name          = optional(string)<br>  }))</pre> | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | The name of the resource group the application gateway belongs to. | `string` | n/a | yes |
| <a name="input_scale"></a> [scale](#input\_scale) | Indicate whether the application gateway should have a static capacity or auto-scale. | <pre>object({<br>    capacity     = optional(number)<br>    min_capacity = optional(number)<br>    max_capcaity = optional(number)<br>  })</pre> | n/a | yes |
| <a name="input_sku"></a> [sku](#input\_sku) | SKU configuration for the application gateway. | <pre>object({<br>    name = string<br>    tier = string<br>  })</pre> | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | A mapping of tags to apply to this applicationg gateway. | `map(string)` | `null` | no |
| <a name="input_url_path_maps"></a> [url\_path\_maps](#input\_url\_path\_maps) | A list of mappings between backend address pools, http settings, and path rules. | <pre>list(object({<br>    name                               = string<br>    default_backend_address_pool_name  = optional(string)<br>    default_backend_http_settings_name = optional(string)<br>    path_rules = list(object({<br>      name                       = string<br>      paths                      = list(string)<br>      backend_address_pool_name  = optional(string)<br>      backend_http_settings_name = optional(string)<br>      firewall_policy_id         = optional(string)<br>    }))<br>  }))</pre> | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_id"></a> [id](#output\_id) | n/a |
<!-- END_TF_DOCS -->