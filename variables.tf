variable "name" {
  type        = string
  description = "ACR Name"
}

variable "resource_group" {
  type = object({
    name     = string
    location = string
  })
  description = "Resource group configuration."
}

variable "public_network_access_enabled" {
  type        = bool
  description = "Whether public network access is allowed for the container registry. Defaults to false."
  default     = false
}

variable "network_default_action" {
  type        = string
  description = "The behaviour for requests matching no rules. Either Allow or Deny. Defaults to Deny."
  default     = "Deny"
}

variable "virtual_network" {
  type        = list(string)
  description = "The list of subnet ids to associate with the container registry."
  default     = []
}

variable "ip_addresses" {
  type        = list(string)
  description = "The CIDR block from which requests will match the rule."
  default     = []
}

variable "sku" {
  type        = string
  default     = "Premium"
  description = "The SKU name of the container registry. Possible values are Basic, Standard and Premium."
}

variable "admin_enabled" {
  type        = bool
  description = "Specifies whether the admin user is enabled. Defaults to false."
  default     = false
}

variable "tags" {
  type        = map(string)
  description = "A mapping of tags to assign to the resource."
  default     = {}
}

variable "georeplications" {
  type = map(object({
    regional_endpoint_enabled = bool
    zone_redundancy_enabled   = bool
    tags                      = map(string)
  }))
  description = "A georeplications block as documented below."
  default     = {}
}

variable "encryption_identity" {
  type = object({
    id        = string
    client_id = string
  })
  default     = null
  description = "The identity to assign to the container registry."
}

variable "encryption_tenant_id" {
  type        = string
  default     = null
  description = "The tenant id of the identity used to access KeyVault."
}

variable "encryption_key_vault_key_id" {
  type        = string
  description = "The ID of the encryption Key in the key vault."
}

variable "encryption_key_vault_id" {
  type        = string
  description = "The key vault id of the key used to encrypt container registry."
}

variable "keyvault_iam_authorization" {
  type        = bool
  default     = true
  description = "Enable iam authorization to access keyvault resources."
}

variable "identity_ids" {
  type        = list(string)
  default     = []
  description = "The list of identities to assign to the container registry."
}

variable "retention_duration" {
  type        = string
  default     = "90"
  description = "The number of days to retain the logs. Defaults to 30."
}

variable "private_endpoint" {
  description = "The private endpoint configuration."
  type = object({
    enable              = bool,
    subnet_id           = string
    private_dns_zone_id = string,
  })
  default = {
    enable              = false
    subnet_id           = null
    private_dns_zone_id = null
  }
}

variable "trust_policy_enabled" {
  description = "Enable trust policy for the container registry. Defaults to false."
  type        = bool
  default     = false
}

variable "quarantine_policy_enabled" {
  description = "Enable quarantine policy for the container registry. Defaults to false."
  type        = bool
  default     = false
}
