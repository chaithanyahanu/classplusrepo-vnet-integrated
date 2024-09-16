
# Name of the storage account
variable "storage_account_name" {
  description = "The name of the Storage Account"
  type        = string
  default     = ""
}

# Storage account tier: Standard or Premium
variable "account_tier" {
  description = "The performance tier of the storage account"
  type        = string
  default     = ""
}

# Replication type: LRS, GRS, RAGRS, ZRS
variable "account_replication_type" {
  description = "The replication type of the storage account"
  type        = string
  default     = ""
}
# Access tier: Hot or Cool
variable "access_tier" {
  description = "Defines the access tier for the storage account"
  type        = string
  default     = ""
}

