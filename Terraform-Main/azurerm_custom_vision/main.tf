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

# Create a Custom Vision resource for prediction and training
resource "azurerm_cognitive_account" "custom_vision" {
  name                = var.cognitive_account_name
  location            = data.azurerm_resource_group.existing_rg.location
  resource_group_name = data.azurerm_resource_group.existing_rg.name
  kind                = "CustomVision.Prediction" # Change this as needed
  sku_name             = "S0"

  tags = data.azurerm_resource_group.existing_rg.tags

  network_acls {
    default_action = "Deny"

    virtual_network_rules {
      subnet_id = data.azurerm_subnet.existing_subnet.id
    }
  }

  custom_subdomain_name         = "customtr-Prediction-subdomain"
}

resource "azurerm_cognitive_account" "custom_vision_training" {
  name                = var.cognitive_account_name_training
  location            = data.azurerm_resource_group.existing_rg.location
  resource_group_name = data.azurerm_resource_group.existing_rg.name
  kind                = "CustomVision.Training"
  sku_name             = "S0"

  tags = data.azurerm_resource_group.existing_rg.tags

  network_acls {
    default_action = "Deny"

    virtual_network_rules {
      subnet_id = data.azurerm_subnet.existing_subnet.id
    }
  }

  custom_subdomain_name         = "customtr-Training-subdomain"
  }
