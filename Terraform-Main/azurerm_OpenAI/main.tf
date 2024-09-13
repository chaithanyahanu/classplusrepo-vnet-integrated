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

# ARM template deployment for Azure OpenAI
resource "azurerm_resource_group_template_deployment" "openai_deployment" {
  name                = "openai-deployment"
  resource_group_name = data.azurerm_resource_group.existing.name
  deployment_mode     = "Incremental"

  template_content = <<TEMPLATE
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#",
  "contentVersion": "1.0.0.0",
  "resources": [
    {
      "type": "Microsoft.CognitiveServices/accounts",
      "apiVersion": "2023-05-01",
      "name": "${var.openai_account_name}",
      "location": "${data.azurerm_resource_group.existing.location}",
      "kind": "OpenAI",
      "sku": {
        "name": "${var.sku_name}"
      },
      "properties": {
        "publicNetworkAccess": "Disabled"
      }
    }
  ]
}
TEMPLATE

  parameters_content = "{}"

  network_acls {
    default_action = "Deny"

    virtual_network_rules {
      subnet_id = data.azurerm_subnet.existing_subnet.id
    }
  }

  custom_subdomain_name         = "clsopenai789-subdomain"
  }
}
