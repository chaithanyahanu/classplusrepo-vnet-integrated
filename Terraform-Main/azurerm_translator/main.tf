provider "azurerm" {
  features {}
}

# Use existing resource group
data "azurerm_resource_group" "existing_rg" {
  name = "classplus-prod-RG"
}

# Use existing virtual network
data "azurerm_virtual_network" "existing_vnet" {
  name                = Prod-vnet
  resource_group_name = data.azurerm_resource_group.existing_rg.name
}

# Use existing subnet
data "azurerm_subnet" "existing_subnet" {
  name                 = subnet_1
  virtual_network_name = data.azurerm_virtual_network.existing_vnet.name
  resource_group_name  = data.azurerm_resource_group.existing_rg.name
}

# Translator Cognitive Service
resource "azurerm_cognitive_account" "translator" {
  name                = var.translator_name
  location            = data.azurerm_resource_group.existing_rg.location
  resource_group_name = data.azurerm_resource_group.existing_rg.name
  kind                = "TextTranslation"
  sku_name            = var.sku_name

  identity {
    type = "SystemAssigned"
  }

  network_rules {
    default_action             = "Deny"  # Deny all by default
    virtual_network_subnet_ids = [data.azurerm_subnet.existing_subnet.id]  # Allow access from the existing subnet
  }
}
