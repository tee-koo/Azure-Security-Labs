resource "azurerm_virtual_network" "spoke" {
  name                = "vnet-spoke"
  address_space       = ["10.100.100.128/26"]
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags
}

resource "azurerm_subnet" "app" {
  name                 = "snet-app"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.spoke.name
  address_prefixes     = ["10.100.100.128/28"]
}

resource "azurerm_subnet" "db" {
  name                 = "snet-db"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.spoke.name
  address_prefixes     = ["10.100.100.144/28"]
}

# Dedicated subnet keeps Private Endpoint placement separate from workloads.
resource "azurerm_subnet" "private_endpoints" {
  name                 = "snet-private-endpoints"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.spoke.name
  address_prefixes     = ["10.100.100.160/28"]
}

resource "azurerm_storage_account" "demo" {
  name                            = "stghubspoke${random_string.suffix.result}"
  resource_group_name             = var.resource_group_name
  location                        = var.location
  account_tier                    = "Standard"
  account_replication_type        = "LRS"
  public_network_access_enabled   = false
  allow_nested_items_to_be_public = false
  shared_access_key_enabled       = false
  https_traffic_only_enabled      = true
  min_tls_version                 = "TLS1_2"
  tags                            = var.tags
}

# Private application container. Using storage_account_id makes the provider
# manage this container through the Azure Resource Manager API.
resource "azurerm_storage_container" "appdata" {
  name                  = "appdata"
  storage_account_id    = azurerm_storage_account.demo.id
  container_access_type = "private"
}

resource "azurerm_private_endpoint" "storage_pe" {
  name                = "pe-storage-blob"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = azurerm_subnet.private_endpoints.id
  tags                = var.tags

  private_service_connection {
    name                           = "psc-storage-blob"
    private_connection_resource_id = azurerm_storage_account.demo.id
    is_manual_connection           = false
    subresource_names              = ["blob"]
  }

  private_dns_zone_group {
    name                 = "blob-dns-zone-group"
    private_dns_zone_ids = [var.private_dns_zone_id]
  }
}

# The application VM uses its system-assigned identity for Blob read/write access.
# No storage account key is required or enabled in this lab.
resource "azurerm_role_assignment" "app_vm_blob_contributor" {
  scope                = azurerm_storage_container.appdata.id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = azurerm_windows_virtual_machine.app_vm.identity[0].principal_id
}

# Preserve the existing Terraform state address when renaming the role assignment.
moved {
  from = azurerm_role_assignment.app_vm_blob_reader
  to   = azurerm_role_assignment.app_vm_blob_contributor
}

resource "random_password" "app_admin_password" {
  length      = 24
  min_upper   = 1
  min_lower   = 1
  min_numeric = 1
  min_special = 1
}

resource "random_password" "db_admin_password" {
  length      = 24
  min_upper   = 1
  min_lower   = 1
  min_numeric = 1
  min_special = 1
}

resource "azurerm_network_security_group" "app" {
  name                = "nsg-app"
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags

  security_rule {
    name                       = "Allow-RDP-From-Bastion"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3389"
    source_address_prefix      = var.bastion_subnet_prefix
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "Deny-Other-Inbound"
    priority                   = 4096
    direction                  = "Inbound"
    access                     = "Deny"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_network_security_group" "db" {
  name                = "nsg-db"
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags

  security_rule {
    name                       = "Allow-RDP-From-Bastion"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3389"
    source_address_prefix      = var.bastion_subnet_prefix
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "Deny-Other-Inbound"
    priority                   = 4096
    direction                  = "Inbound"
    access                     = "Deny"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_subnet_network_security_group_association" "app" {
  subnet_id                 = azurerm_subnet.app.id
  network_security_group_id = azurerm_network_security_group.app.id
}

resource "azurerm_subnet_network_security_group_association" "db" {
  subnet_id                 = azurerm_subnet.db.id
  network_security_group_id = azurerm_network_security_group.db.id
}

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
  admin_password      = random_password.app_admin_password.result
  network_interface_ids = [azurerm_network_interface.app_nic.id]
  tags                = var.tags

  identity {
    type = "SystemAssigned"
  }

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
  admin_password      = random_password.db_admin_password.result
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
  numeric = true
}
