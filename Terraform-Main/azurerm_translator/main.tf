provider "azurerm" {
  features {}
}

# Use existing resource group
data "azurerm_resource_group" "existing_rg" {
  name = "classplus-prod-RG"
}

# Translator Cognitive Service
resource "azurerm_cognitive_account" "translator" {
  name                = var.translator_name
  location            = data.azurerm_resource_group.existing_rg.location
  resource_group_name = data.azurerm_resource_group.existing_rg.name
  kind                = "TextTranslation"  # Corrected kind
  sku_name            = var.sku_name

  identity {
    type = "SystemAssigned"
  }
}
