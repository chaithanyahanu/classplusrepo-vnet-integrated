terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.1.0" # Adjust the version according to your needs
    }
  }
}

provider "azurerm" {
  features {}
}

# Data block to reference an existing resource group
data "azurerm_resource_group" "existing_rg" {
  name = "classplus-prod-RG"
}

# Storage account with ADLS Gen2
resource "azurerm_storage_account" "storage" {
  name                     = var.storage_account_name
  resource_group_name       = data.azurerm_resource_group.existing_rg.name
  location                  = data.azurerm_resource_group.existing_rg.location
  account_tier              = var.account_tier
  account_replication_type  = var.account_replication_type
  is_hns_enabled            = true  # Enables hierarchical namespace for ADLS Gen2

  # Optional, configuring the access tiers and network access
  access_tier               = var.access_tier
  min_tls_version           = "TLS1_2"
  
  tags = data.azurerm_resource_group.existing_rg.tags
}
