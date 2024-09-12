provider "azurerm" {
  features {}
}

# Data block to reference the existing resource group
data "azurerm_resource_group" "existing_rg" {
  name = "classplus-prod-RG"
}

# App Service Plan resource
resource "azurerm_service_plan" "example" {
  name                = var.app_service_plan_name
  location            = data.azurerm_resource_group.existing_rg.location
  resource_group_name = data.azurerm_resource_group.existing_rg.name

  os_type  = "Linux"  # Specify the OS type
  sku_name = "P1v2"   # Specify the SKU name

  # 'reserved' is no longer necessary, as it is inferred automatically
}

# App Service resource
resource "azurerm_app_service" "example" {
  name                = var.app_service_name
  location            = data.azurerm_resource_group.existing_rg.location
  resource_group_name = data.azurerm_resource_group.existing_rg.name
  app_service_plan_id = azurerm_service_plan.example.id

  site_config {
    linux_fx_version = "PYTHON|3.9"  # Set correct Python version
    scm_type         = "LocalGit"
  }
}
