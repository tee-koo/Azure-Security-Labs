resource "azurerm_public_ip" "bastion_pip" {
  name                = "pip-bastion-central"
  location            = var.location
  resource_group_name = azurerm_resource_group.core.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_bastion_host" "central" {
  name                = "bastion-central"
  location            = var.location
  resource_group_name = azurerm_resource_group.core.name

  ip_configuration {
    name                 = "ipconfig"
    subnet_id            = azurerm_subnet.bastion.id
    public_ip_address_id = azurerm_public_ip.bastion_pip.id
  }
}
