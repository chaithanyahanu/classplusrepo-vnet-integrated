provider "azurerm" {
  features {}
}

# Data block to fetch the existing resource group
data "azurerm_resource_group" "existing" {
  name = "classplus-prod-RG"
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
        "publicNetworkAccess": "Enabled"
      }
    }
  ]
}
TEMPLATE

  parameters_content = "{}"
}
