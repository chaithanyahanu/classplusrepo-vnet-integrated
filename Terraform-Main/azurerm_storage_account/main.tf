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

# Data block to reference an existing virtual network
data "azurerm_virtual_network" "existing_vnet" {
  name                = "Prod-vnet"  # Replace with your actual virtual network name
  resource_group_name = data.azurerm_resource_group.existing_rg.name
}

# Data block to reference an existing subnet within the virtual network
data "azurerm_subnet" "existing_subnet" {
  name                 = "subnet_1"  # Replace with your actual subnet name
  virtual_network_name = data.azurerm_virtual_network.existing_vnet.name
  resource_group_name  = data.azurerm_resource_group.existing_rg.name
}

# Modify the existing subnet to add the service endpoint for Microsoft.Storage
resource "azurerm_subnet" "updated_subnet" {
  name                 = data.azurerm_subnet.existing_subnet.name
  virtual_network_name = data.azurerm_virtual_network.existing_vnet.name
  resource_group_name  = data.azurerm_resource_group.existing_rg.name

  # Add Microsoft.Storage service endpoint
  service_endpoints = ["Microsoft.Storage"]
}

# Storage account with ADLS Gen2 integrated with the virtual network
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
  
  network_rules {
    default_action             = "Deny"  # Deny all by default
    virtual_network_subnet_ids = [data.azurerm_subnet.existing_subnet.id]  # Allow access from the existing subnet
  }

  tags = data.azurerm_resource_group.existing_rg.tags
}

