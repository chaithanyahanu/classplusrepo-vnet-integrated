provider "azurerm" {
  features {}
}

# Data block to reference the existing resource group
data "azurerm_resource_group" "existing_rg" {
  name = "classplus-prod-RG"
}

# Create a Custom Vision resource for prediction and training
resource "azurerm_cognitive_account" "custom_vision" {
  name                = var.cognitive_account_name
  location            = data.azurerm_resource_group.existing_rg.location
  resource_group_name = data.azurerm_resource_group.existing_rg.name
  kind                = "CustomVision.Prediction" # Change this as needed
  sku_name             = "S0"

  tags = data.azurerm_resource_group.existing_rg.tags
}

resource "azurerm_cognitive_account" "custom_vision_training" {
  name                = var.cognitive_account_name_training
  location            = data.azurerm_resource_group.existing_rg.location
  resource_group_name = data.azurerm_resource_group.existing_rg.name
  kind                = "CustomVision.Training"
  sku_name             = "S0"

  tags = data.azurerm_resource_group.existing_rg.tags
  }
