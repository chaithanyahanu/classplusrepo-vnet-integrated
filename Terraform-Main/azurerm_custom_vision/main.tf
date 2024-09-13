provider "azurerm" {
  features {}
}

# Data block to reference the existing resource group
data "azurerm_resource_group" "existing_rg" {
  name = "classplus-prod-RG"  # Replace with your actual Resource Group name
}

# Data block to reference the existing virtual network and subnet
data "azurerm_virtual_network" "existing_vnet" {
  name                = "Prod-vnet"   # Replace with your actual VNet name
  resource_group_name = data.azurerm_resource_group.existing_rg.name
}

data "azurerm_subnet" "existing_subnet" {
  name                 = "subnet_1"  # Replace with your actual subnet name
  virtual_network_name = data.azurerm_virtual_network.existing_vnet.name
  resource_group_name  = data.azurerm_resource_group.existing_rg.name
}

# Create a Custom Vision resource for prediction
resource "azurerm_cognitive_account" "custom_vision" {
  name                = var.cognitive_account_name
  location            = data.azurerm_resource_group.existing_rg.location
  resource_group_name = data.azurerm_resource_group.existing_rg.name
  kind                = "CustomVision.Prediction"
  sku_name            = "S0"

  # Add a custom subdomain for private endpoint integration
  custom_subdomain_name = "${var.cognitive_account_name}-subdomain"

  tags = data.azurerm_resource_group.existing_rg.tags
}

# Create a Custom Vision resource for training
resource "azurerm_cognitive_account" "custom_vision_training" {
  name                = var.cognitive_account_name_training
  location            = data.azurerm_resource_group.existing_rg.location
  resource_group_name = data.azurerm_resource_group.existing_rg.name
  kind                = "CustomVision.Training"
  sku_name            = "S0"

  # Add a custom subdomain for private endpoint integration
  custom_subdomain_name = "${var.cognitive_account_name_training}-subdomain"

  tags = data.azurerm_resource_group.existing_rg.tags
}

# Private Endpoint for Custom Vision Prediction
resource "azurerm_private_endpoint" "private_endpoint_prediction" {
  name                = "customvision-prediction-pe"
  location            = data.azurerm_resource_group.existing_rg.location
  resource_group_name = data.azurerm_resource_group.existing_rg.name
  subnet_id           = data.azurerm_subnet.existing_subnet.id

  private_service_connection {
    name                           = "privateserviceconnection"
    private_connection_resource_id = azurerm_cognitive_account.custom_vision.id
    is_manual_connection           = false
    subresource_names              = ["account"]
  }
}

# Private Endpoint for Custom Vision Training
resource "azurerm_private_endpoint" "private_endpoint_training" {
  name                = "customvision-training-pe"
  location            = data.azurerm_resource_group.existing_rg.location
  resource_group_name = data.azurerm_resource_group.existing_rg.name
  subnet_id           = data.azurerm_subnet.existing_subnet.id

  private_service_connection {
    name                           = "privateserviceconnection"
    private_connection_resource_id = azurerm_cognitive_account.custom_vision_training.id
    is_manual_connection           = false
    subresource_names              = ["account"]
  }
}
