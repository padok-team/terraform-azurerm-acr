variable "name" {
  type        = string
  description = "ACR Name"
}

variable "resource_group_name" {
  type        = string
  description = "The name of the resource group in which to create the Container Registry. Changing this forces a new resource to be created."
}

variable "location" {
  type        = string
  description = "Specifies the supported Azure location where the resource exists. Changing this forces a new resource to be created."
}

variable "sku" {
  type        = string
  default     = "Premium"
  description = "The SKU name of the container registry. Possible values are Basic, Standard and Premium."
}

variable "admin_enabled" {
  type        = string
  description = "Specifies whether the admin user is enabled. Defaults to false."
  default     = false
}

variable "tags" {
  type        = map(string)
  description = "A mapping of tags to assign to the resource."
}

variable "key_vault_key_id" {
  type        = string
  default     = null
  description = "The key vault key identifier for the storage account."
}

variable "georeplications" {
  type = object({
    location                  = string
    regional_endpoint_enabled = optional(bool)
    zone_redundancy_enabled   = optional(bool)
    tags                      = optional(map(string))
  })
  default = null
}

variable "encryption_identity_name" {
  type        = string
  default     = null
  description = "The name of the identity to assign to the container registry."
}

variable "encryption_identity_resource_group_name" {
  type        = string
  default     = null
  description = "The resource group of the identity to assign to the container registry."
}

variable "identity_ids" {
  type        = list(string)
  default     = null
  description = "The list of identities to assign to the container registry."
}
