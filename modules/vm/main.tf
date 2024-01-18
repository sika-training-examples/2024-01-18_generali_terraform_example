resource "azurerm_network_interface" "this" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = var.public_ip_address_id
  }
}

resource "azurerm_linux_virtual_machine" "this" {
  name = var.name

  location            = var.location
  resource_group_name = var.resource_group_name

  size                            = var.size
  admin_username                  = "default"
  admin_password                  = "asdfasdf1234A."
  disable_password_authentication = false
  admin_ssh_key {
    username   = "default"
    public_key = var.ssh_key
  }
  network_interface_ids = [
    azurerm_network_interface.this.id,
  ]
  user_data = base64encode(var.user_data)

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Debian"
    offer     = "debian-12"
    sku       = "12"
    version   = "latest"
  }
}
