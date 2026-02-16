resource "azurerm_virtual_network" "hub" {
  name                = "vnet-hub"
  address_space       = ["10.100.100.0/25"]
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags
}

resource "azurerm_subnet" "firewall" {
  name                 = "AzureFirewallSubnet"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.hub.name
  address_prefixes     = ["10.100.100.0/26"]
}

resource "azurerm_subnet" "bastion" {
  name                 = "AzureBastionSubnet"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.hub.name
  address_prefixes     = ["10.100.100.64/27"]
}

resource "azurerm_public_ip" "firewall_pip" {
  name                = "pip-firewall"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"
  tags                = var.tags
}

resource "azurerm_firewall" "hub_fw" {
  name                = "fw-hub"
  location            = var.location
  resource_group_name = var.resource_group_name
  sku_name            = "AZFW_VNet"
  sku_tier            = "Standard"
  tags                = var.tags

  ip_configuration {
    name                 = "fw-config"
    subnet_id            = azurerm_subnet.firewall.id
    public_ip_address_id = azurerm_public_ip.firewall_pip.id
  }
}

# Network Rule: Allow ICMP (tracert)
resource "azurerm_firewall_network_rule_collection" "allow_icmp" {
  name                = "Allow-ICMP"
  azure_firewall_name = azurerm_firewall.hub_fw.name
  resource_group_name = var.resource_group_name
  priority            = 100
  action              = "Allow"

  rule {
    name                  = "ICMP-Out"
    protocols             = ["ICMP"]
    source_addresses      = ["10.100.100.128/28", "10.100.100.144/28"]
    destination_addresses = ["*"]
    destination_ports     = ["*"]
  }
}

# Application Rule: Allow HTTP/HTTPS
resource "azurerm_firewall_application_rule_collection" "allow_http_https" {
  name                = "Allow-HTTP-HTTPS"
  azure_firewall_name = azurerm_firewall.hub_fw.name
  resource_group_name = var.resource_group_name
  priority            = 200
  action              = "Allow"

  rule {
    name = "HTTP-HTTPS-Out"
    source_addresses = ["10.100.100.128/28", "10.100.100.144/28"]
    target_fqdns = ["*"]

    protocol {
      port = 80
      type = "Http"
    }
    protocol {
      port = 443
      type = "Https"
    }
  }
}

resource "azurerm_public_ip" "bastion_pip" {
  name                = "pip-bastion"
  resource_group_name = var.resource_group_name
  location            = var.location
  allocation_method   = "Static"
  sku                 = "Standard"
  tags                = var.tags
}

resource "azurerm_bastion_host" "hub_bastion" {
  name                = "bastion-hub"
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags

  ip_configuration {
    name                 = "config"
    subnet_id            = azurerm_subnet.bastion.id
    public_ip_address_id = azurerm_public_ip.bastion_pip.id
  }
}
