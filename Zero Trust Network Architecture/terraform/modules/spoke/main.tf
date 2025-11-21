resource "azurerm_virtual_network" "spoke" {
  name                = "vnet-spoke"
  address_space       = ["10.100.100.128/26"] # 128-191
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags
}

resource "azurerm_subnet" "app" {
  name                 = "snet-app"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.spoke.name
  address_prefixes     = ["10.100.100.128/28"]  # 128–143
}

resource "azurerm_subnet" "db" {
  name                 = "snet-db"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.spoke.name
  address_prefixes     = ["10.100.100.144/28"]  # 144–159
}

# Storage + Private Endpoint
resource "azurerm_storage_account" "demo" {
  name                     = "stghubspoke${random_string.suffix.result}"
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  tags                     = var.tags
}

resource "azurerm_private_endpoint" "storage_pe" {
  name                = "pe-storage"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = azurerm_subnet.app.id
  tags                = var.tags

  private_service_connection {
    name                           = "psc-storage"
    private_connection_resource_id = azurerm_storage_account.demo.id
    is_manual_connection           = false
    subresource_names              = ["blob"]
  }
}

# Sama salasana molemmille VM:ille
resource "random_password" "admin_password" {
  length      = 16
  min_upper   = 1
  min_lower   = 1
  min_numeric = 1
  min_special = 1
}

# ========== APP VM ==========
resource "azurerm_network_interface" "app_nic" {
  name                = "nic-vm-app"
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.app.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_windows_virtual_machine" "app_vm" {
  name                = "vm-app"
  resource_group_name = var.resource_group_name
  location            = var.location
  size                = "Standard_B2s"
  admin_username      = "azureadmin"
  admin_password      = random_password.admin_password.result
  network_interface_ids = [azurerm_network_interface.app_nic.id]
  tags                = var.tags

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2022-datacenter-azure-edition"
    version   = "latest"
  }
}

# ========== DB VM ==========
resource "azurerm_network_interface" "db_nic" {
  name                = "nic-vm-db"
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.db.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_windows_virtual_machine" "db_vm" {
  name                = "vm-db"
  resource_group_name = var.resource_group_name
  location            = var.location
  size                = "Standard_B2s"
  admin_username      = "azureadmin"
  admin_password      = random_password.admin_password.result
  network_interface_ids = [azurerm_network_interface.db_nic.id]
  tags                = var.tags

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2022-datacenter-azure-edition"
    version   = "latest"
  }
}

resource "random_string" "suffix" {
  length  = 6
  special = false
  upper   = false
  numeric  = true
}
