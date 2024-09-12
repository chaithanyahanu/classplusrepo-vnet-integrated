
# Name of the storage account
variable "storage_account_name" {
  description = "The name of the Storage Account"
  type        = string
  default     = "straccunt4578"
}

# Storage account tier: Standard or Premium
variable "account_tier" {
  description = "The performance tier of the storage account"
  type        = string
  default     = "Standard"
}

# Replication type: LRS, GRS, RAGRS, ZRS
variable "account_replication_type" {
  description = "The replication type of the storage account"
  type        = string
  default     = "LRS"
}
# Access tier: Hot or Cool
variable "access_tier" {
  description = "Defines the access tier for the storage account"
  type        = string
  default     = "Hot"
}

