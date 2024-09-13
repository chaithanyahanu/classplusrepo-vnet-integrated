provider "azurerm" {
  features {}
}
# Using an existing resource group
data "azurerm_resource_group" "existing" {
  name = "classplus-prod-RG"
}
# Define Azure Cognitive Search Service
resource "azurerm_search_service" "example" {
  name                = var.search_service_name
  resource_group_name = data.azurerm_resource_group.existing.name
  location            = data.azurerm_resource_group.existing.location
  sku                 = "standard"
  replica_count   = var.replica_count
  partition_count = var.partition_count
}
