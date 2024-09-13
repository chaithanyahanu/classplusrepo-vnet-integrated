provider "azurerm" {
  features {}
}

# Data block to fetch the existing resource group
data "azurerm_resource_group" "existing" {
  name = "classplus-prod-RG"
}

# Data block to fetch the existing virtual network
data "azurerm_virtual_network" "existing_vnet" {
  name                = "Prod-vnet"
  resource_group_name = data.azurerm_resource_group.existing.name
}

# Data block to fetch the existing subnet
data "azurerm_subnet" "existing_subnet" {
  name                 = "subnet_2"
  virtual_network_name = data.azurerm_virtual_network.existing_vnet.name
  resource_group_name   = data.azurerm_resource_group.existing.name
}

# Data block to fetch the subscription ID
data "azurerm_client_config" "example" {}

# ARM template deployment for Azure OpenAI with network rules
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
        "publicNetworkAccess": "Enabled"
      }
    },
    {
      "type": "Microsoft.CognitiveServices/accounts/networkAcls",
      "apiVersion": "2021-03-01",
      "name": "${var.openai_account_name}/networkAcls",
      "properties": {
        "ipRules": [],
        "virtualNetworkRules": [
          {
            "id": "/subscriptions/${data.azurerm_client_config.example.69ad85a8-e5ae-40f5-8f70-f01c051c3d27}/resourceGroups/${data.azurerm_resource_group.existing.name}/providers/Microsoft.Network/virtualNetworks/${data.azurerm_virtual_network.existing_vnet.name}/subnets/${data.azurerm_subnet.existing_subnet.name}"
          }
        ]
      }
    }
  ]
}
TEMPLATE

  parameters_content = "{}"
}
