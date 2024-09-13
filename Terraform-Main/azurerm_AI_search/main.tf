provider "azurerm" {
  features {}
}
# Data block to reference the existing resource group
data "azurerm_resource_group" "existing_rg" {
  name = "classplus-prod-RG"
}

# Use existing virtual network
data "azurerm_virtual_network" "existing_vnet" {
  name                = "Prod-vnet"
  resource_group_name = data.azurerm_resource_group.existing_rg.name
}

# Use existing subnet
data "azurerm_subnet" "existing_subnet" {
  name                 = "subnet_1"
  virtual_network_name = data.azurerm_virtual_network.existing_vnet.name
  resource_group_name  = data.azurerm_resource_group.existing_rg.name
}

# Define Azure Cognitive Search Service
resource "azurerm_search_service" "example" {
  name                = var.search_service_name
  resource_group_name = data.azurerm_resource_group.existing.name
  location            = data.azurerm_resource_group.existing.location
  sku                 = "standard"
  replica_count   = var.replica_count
  partition_count = var.partition_count

  network_acls {
    default_action = "Deny"

    virtual_network_rules {
      subnet_id = data.azurerm_subnet.existing_subnet.id
    }
  }

  custom_subdomain_name         = "classplsaisearch-subdomain"
}
