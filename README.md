# fg-terraform

Reusable terraform modules for use by Flemish Government entities, to provision resources using sensible, policy driven defaults.

Modules are organised by cloud provider. Select a cloud provider directory and resource to read resource-specific documentation.

## Example Usage

```terraform
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.32.0"
    }
  }
}

provider "azurerm" {
}

module "virtual-machine" {
  source = "git@github.com:atoscerebro/fg-terraform.git//azure/virtual-machine"
  ...
}
```
