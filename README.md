# CLOUD_PROVIDER TYPE Terraform module

Terraform module which creates **TYPE** resources on **CLOUD_PROVIDER**. This module is an abstraction of the [MODULE_NAME](https://github.com/a_great_module) by [@someoneverysmart](https://github.com/someoneverysmart).

## User Stories for this module

- AATYPE I can be highly available or single zone
- ...

## Usage

```hcl
module "example" {
  source = "https://github.com/padok-team/terraform-aws-example"

  example_of_required_variable = "hello_world"
}
```

## Examples

- [Example of use case](examples/example_of_use_case/main.tf)
- [Example of other use case](examples/example_of_other_use_case/main.tf)

<!-- BEGIN_TF_DOCS -->
## Modules

No modules.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_location"></a> [location](#input\_location) | Specifies the supported Azure location where the resource exists. Changing this forces a new resource to be created. | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | ACR Name | `string` | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | The name of the resource group in which to create the Container Registry. Changing this forces a new resource to be created. | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | A mapping of tags to assign to the resource. | `map(string)` | n/a | yes |
| <a name="input_admin_enabled"></a> [admin\_enabled](#input\_admin\_enabled) | Specifies whether the admin user is enabled. Defaults to false. | `string` | `false` | no |
| <a name="input_encryption_identity_name"></a> [encryption\_identity\_name](#input\_encryption\_identity\_name) | The name of the identity to assign to the container registry. | `string` | `null` | no |
| <a name="input_encryption_identity_resource_group_name"></a> [encryption\_identity\_resource\_group\_name](#input\_encryption\_identity\_resource\_group\_name) | The resource group of the identity to assign to the container registry. | `string` | `null` | no |
| <a name="input_georeplications"></a> [georeplications](#input\_georeplications) | n/a | <pre>object({<br>    location                  = string<br>    regional_endpoint_enabled = optional(bool)<br>    zone_redundancy_enabled   = optional(bool)<br>    tags                      = optional(map(string))<br>  })</pre> | `null` | no |
| <a name="input_identity_ids"></a> [identity\_ids](#input\_identity\_ids) | The list of identities to assign to the container registry. | `list(string)` | `null` | no |
| <a name="input_key_vault_key_id"></a> [key\_vault\_key\_id](#input\_key\_vault\_key\_id) | The key vault key identifier for the storage account. | `string` | `null` | no |
| <a name="input_sku"></a> [sku](#input\_sku) | The SKU name of the container registry. Possible values are Basic, Standard and Premium. | `string` | `"Premium"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_example"></a> [example](#output\_example) | A meaningful description |
<!-- END_TF_DOCS -->
