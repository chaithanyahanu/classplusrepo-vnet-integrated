terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.2.0"
    }
  }
}

provider "azurerm" {
  features {}
}
# Use existing resource group
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
  name                 = "subnet_2"
  virtual_network_name = data.azurerm_virtual_network.existing_vnet.name
  resource_group_name  = data.azurerm_resource_group.existing_rg.name
}
# SpeechService Cognitive Service
resource "azurerm_cognitive_account" "speechservice" {
  name                = var.speechservice
  location            = data.azurerm_resource_group.existing_rg.location
  resource_group_name = data.azurerm_resource_group.existing_rg.name
  kind                = "SpeechServices"
  sku_name            = var.sku_name

  identity {
    type = "SystemAssigned"
  }

  network_acls {
    default_action = "Deny"

    virtual_network_rules {
      subnet_id = data.azurerm_subnet.existing_subnet.id
    }
  }

  custom_subdomain_name         = "classplusspeechservice-subdomain"
}
