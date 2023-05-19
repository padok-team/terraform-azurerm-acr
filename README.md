<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [Azure Container Registry Terraform module](#azure-container-registry-terraform-module)
  - [User Stories for this module](#user-stories-for-this-module)
  - [Usage](#usage)
  - [Examples](#examples)
  - [Modules](#modules)
  - [Inputs](#inputs)
  - [Outputs](#outputs)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

# Azure Container Registry Terraform module

Terraform module which creates **Container Registry** resources on **Azure**. This module provides some useful recommandations about encryption and redondancy.

## User Stories for this module

- AAOps I can store my images into a secure registry.
- AAOps I still can access my images after a disaster.

## Usage

```hcl
module "acr" {
  source = "https://github.com/padok-team/terraform-azurerm-acr"

  name                = "test-acr"
  resource_group_name = "test-acr"
  location            = "francecentral"

  # Encryption at rest
  encryption_key_vault_id     = "my-keyvault"
  encryption_key_vault_key_id = "my-key"
}
```

## Examples

- [Simple example of use case](examples/basic/main.tf)
- [With georeplication around the world](examples/georeplication-around-the-world/main.tf)
- [Secured with ip whitelisting](examples/secured_by_ip_filtering/main.tf)

<!-- BEGIN_TF_DOCS -->
## Modules

No modules.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_encryption_key_vault_id"></a> [encryption\_key\_vault\_id](#input\_encryption\_key\_vault\_id) | The key vault id of the key used to encrypt container registry. | `string` | n/a | yes |
| <a name="input_encryption_key_vault_key_id"></a> [encryption\_key\_vault\_key\_id](#input\_encryption\_key\_vault\_key\_id) | The ID of the encryption Key in the key vault. | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | ACR Name | `string` | n/a | yes |
| <a name="input_resource_group"></a> [resource\_group](#input\_resource\_group) | Resource group configuration. | <pre>object({<br>    name     = string<br>    location = string<br>  })</pre> | n/a | yes |
| <a name="input_admin_enabled"></a> [admin\_enabled](#input\_admin\_enabled) | Specifies whether the admin user is enabled. Defaults to false. | `bool` | `false` | no |
| <a name="input_encryption_identity"></a> [encryption\_identity](#input\_encryption\_identity) | The identity to assign to the container registry. | <pre>object({<br>    id        = string<br>    client_id = string<br>  })</pre> | `null` | no |
| <a name="input_encryption_tenant_id"></a> [encryption\_tenant\_id](#input\_encryption\_tenant\_id) | The tenant id of the identity used to access KeyVault. | `string` | `null` | no |
| <a name="input_georeplications"></a> [georeplications](#input\_georeplications) | A georeplications block as documented below. | <pre>map(object({<br>    regional_endpoint_enabled = bool<br>    zone_redundancy_enabled   = bool<br>    tags                      = map(string)<br>  }))</pre> | `{}` | no |
| <a name="input_identity_ids"></a> [identity\_ids](#input\_identity\_ids) | The list of identities to assign to the container registry. | `list(string)` | `[]` | no |
| <a name="input_ip_addresses"></a> [ip\_addresses](#input\_ip\_addresses) | The CIDR block from which requests will match the rule. | `list(string)` | `[]` | no |
| <a name="input_keyvault_iam_authorization"></a> [keyvault\_iam\_authorization](#input\_keyvault\_iam\_authorization) | Enable iam authorization to access keyvault resources. | `bool` | `true` | no |
| <a name="input_network_default_action"></a> [network\_default\_action](#input\_network\_default\_action) | The behaviour for requests matching no rules. Either Allow or Deny. Defaults to Deny. | `string` | `"Deny"` | no |
| <a name="input_private_endpoint"></a> [private\_endpoint](#input\_private\_endpoint) | The private endpoint configuration. | <pre>object({<br>    enable              = bool,<br>    subnet_id           = string<br>    private_dns_zone_id = string,<br>  })</pre> | <pre>{<br>  "enable": false,<br>  "private_dns_zone_id": null,<br>  "subnet_id": null<br>}</pre> | no |
| <a name="input_public_network_access_enabled"></a> [public\_network\_access\_enabled](#input\_public\_network\_access\_enabled) | Whether public network access is allowed for the container registry. Defaults to false. | `bool` | `false` | no |
| <a name="input_retention_duration"></a> [retention\_duration](#input\_retention\_duration) | The number of days to retain the logs. Defaults to 30. | `string` | `"90"` | no |
| <a name="input_sku"></a> [sku](#input\_sku) | The SKU name of the container registry. Possible values are Basic, Standard and Premium. | `string` | `"Premium"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A mapping of tags to assign to the resource. | `map(string)` | `{}` | no |
| <a name="input_virtual_network"></a> [virtual\_network](#input\_virtual\_network) | The list of subnet ids to associate with the container registry. | `list(string)` | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_this"></a> [this](#output\_this) | The Azure container registry created. |
<!-- END_TF_DOCS -->

## License

[![License](https://img.shields.io/badge/License-Apache_2.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)
