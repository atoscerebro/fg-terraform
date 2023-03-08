# fg-terraform

Reusable terraform modules for use by Flemish Government entities, to provision resources using sensible, policy driven defaults.

Modules are organised by cloud provider. Select a cloud provider directory and resource to read resource-specific documentation.

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
  source = "git@github.com:atoscerebro/fg-terraform.git//azure/virtual-machine?ref=v0.1.0"
  ...
}
```

## Releases

All commits to this repository should be made in the [conventional commits](https://www.conventionalcommits.org/en/v1.0.0/) format.

```
<type>[optional scope]: <description>

[optional body]

[optional footer(s)]
```

Minimal examples:

```
// Triggers a major version on next release
major: remove azure modules

// Triggers a minor version on next release
minor: add aks module

// Triggers a patch version on next release
patch: remove comment
```

Refer to the [release.yml](https://github.com/atoscerebro/fg-terraform/blob/master/.github/workflows/release.yml) workflow for a list of commit prefixes.

To trigger a release run `make release` from your command line. The next semantic version will automatically be calculated and released.
