# fg-terraform

Reusable terraform modules for use by Flemish Government entities, to provision resources using sensible, policy driven defaults.

Modules are organised by cloud provider. Resource-specific documentation can be found in each module directory.

## Modules

<!-- BEGIN_MODULE_LINKS -->
### azure

- [aks](https://github.com/atoscerebro/fg-terraform/tree/master/modules/azure/aks)
- [application-gateway](https://github.com/atoscerebro/fg-terraform/tree/master/modules/azure/application-gateway)
- [managed-disk](https://github.com/atoscerebro/fg-terraform/tree/master/modules/azure/managed-disk)
- [virtual-machine](https://github.com/atoscerebro/fg-terraform/tree/master/modules/azure/virtual-machine)
- [vnet](https://github.com/atoscerebro/fg-terraform/tree/master/modules/azure/vnet)
- [waf-policy](https://github.com/atoscerebro/fg-terraform/tree/master/modules/azure/waf-policy)
<!-- END_MODULE_LINKS -->

## Example Usage

Source a module from the repository as follows. Include a specific release tag to use a particular module version.

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
  source = "git@github.com:atoscerebro/fg-terraform.git//modules/azure/virtual-machine?ref=v0.1.0"
  ...
}
```

## Releases

All pull requests to this repository must be titled using the [conventional commits](https://www.conventionalcommits.org/en/v1.0.0/) format.

Minimal examples:

```
// Triggers a major version on next release
major: remove azure modules

// Triggers a minor version on next release
minor: add aks module

// Triggers a patch version on next release
patch: remove comment
```

Commits can optionally be formatted similarly to assist in generating release notes:

```
<type>[optional scope]: <description>

[optional body]

[optional footer(s)]
```

Refer to the [release.yml](https://github.com/atoscerebro/fg-terraform/blob/master/.github/workflows/release.yml) workflow for a list of commit prefixes.

To trigger a release run `make release` from your command line. The next semantic version will automatically be calculated and released.
