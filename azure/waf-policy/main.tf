resource "azurerm_web_application_firewall_policy" "web_application_firewall_policy" {
  name                = var.name
  resource_group_name = var.resource_group_name
  location            = var.location

  dynamic "managed_rules" {
    for_each = var.managed_rules

    content {
      dynamic "exclusion" {
        for_each = managed_rules.value.exclusions

        content {
          match_variable          = exclusion.value.match_variable
          selector                = exclusion.value.selector
          selector_match_operator = exclusion.value.selector_match_operator
        }
      }

      dynamic "managed_rule_set" {
        for_each = managed_rules.value.managed_rule_sets

        content {
          type    = managed_rule_set.value.type
          version = managed_rule_set.value.version
        }
      }
    }
  }

  tags = var.tags
}
