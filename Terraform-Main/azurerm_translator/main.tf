provider "azurerm" {
  features {}
}

# Use existing resource group
data "azurerm_resource_group" "existing_rg" {
  name = "classplus-prod-RG"
}

# Use existing virtual network
data "azurerm_virtual_network" "existing_vnet" {
  name                = Prod-vnet
  resource_group_name = data.azurerm_resource_group.existing_rg.name
}

# Use existing subnet
data "azurerm_subnet" "existing_subnet" {
  name                 = subnet_1
  virtual_network_name = data.azurerm_virtual_network.existing_vnet.name
  resource_group_name  = data.azurerm_resource_group.existing_rg.name
}

# Translator Cognitive Service
resource "azurerm_cognitive_account" "translator" {
  name                = var.translator_name
  location            = data.azurerm_resource_group.existing_rg.location
  resource_group_name = data.azurerm_resource_group.existing_rg.name
  kind                = "TextTranslation"
  sku_name            = var.sku_name

  identity {
    type = "SystemAssigned"
  }

  network_acls {
    default_action             = "Deny"  # Deny all by default
    virtual_network_subnet_ids = [data.azurerm_subnet.existing_subnet.id]  # Allow access from the existing subnet
  }

  virtual_network_rules {
    subnet_id                          = data.azurerm_subnet.existing_subnet.id
    ignore_missing_vnet_service_endpoint = false
  }
}

resource "azurerm_private_dns_zone" "dns_zone" {
  name                = "privatelink.cognitiveservices.azure.com"
  resource_group_name = data.azurerm_resource_group.existing_rg.name
}

resource "azurerm_private_dns_zone_virtual_network_link" "dns_zone_link" {
  name                  = "classplus-dns"
  resource_group_name   = data.azurerm_resource_group.existing_rg.name
  private_dns_zone_name = azurerm_private_dns_zone.dns_zone.name
  virtual_network_id    = data.azurerm_virtual_network.existing_vnet.id
}

resource "azurerm_private_endpoint" "cognitive_private_endpoint" {
  name                = "cognitive-private-endpoint"
  location            = data.azurerm_resource_group.existing_rg.location
  resource_group_name = data.azurerm_resource_group.existing_rg.name
  subnet_id           = data.azurerm_subnet.existing_subnet.id

  private_service_connection {
    name                           = "classplus-connection"
    private_connection_resource_id = azurerm_cognitive_account.translator.id
    subresource_names              = ["cognitiveservices"]
    is_manual_connection           = false
  }
}

resource "azurerm_private_dns_a_record" "dns_record" {
  name                = azurerm_cognitive_account.translator.name
  zone_name           = azurerm_private_dns_zone.dns_zone.name
  resource_group_name = data.azurerm_resource_group.existing_rg.name
  ttl                 = 300
  records             = [azurerm_private_endpoint.cognitive_private_endpoint.private_ip_address]
}
