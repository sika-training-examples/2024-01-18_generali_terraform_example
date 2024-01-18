resource "azurerm_public_ip" "training" {
  name                = var.name
  resource_group_name = azurerm_resource_group.training.name
  location            = azurerm_resource_group.training.location
  allocation_method   = "Static"
}

output "ip" {
  value = azurerm_public_ip.training.ip_address
}

locals {
  size           = "Standard_A2_v2"
  admin_username = "default"
  admin_password = "asdfasdf1234A."
  admin_ssh_key  = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCslNKgLyoOrGDerz9pA4a4Mc+EquVzX52AkJZz+ecFCYZ4XQjcg2BK1P9xYfWzzl33fHow6pV/C6QC3Fgjw7txUeH7iQ5FjRVIlxiltfYJH4RvvtXcjqjk8uVDhEcw7bINVKVIS856Qn9jPwnHIhJtRJe9emE7YsJRmNSOtggYk/MaV2Ayx+9mcYnA/9SBy45FPHjMlxntoOkKqBThWE7Tjym44UNf44G8fd+kmNYzGw9T5IKpH1E1wMR+32QJBobX6d7k39jJe8lgHdsUYMbeJOFPKgbWlnx9VbkZh+seMSjhroTgniHjUl8wBFgw0YnhJ/90MgJJL4BToxu9PVnH"
}


resource "azurerm_network_interface" "vm" {
  name                = var.name
  location            = azurerm_resource_group.training.location
  resource_group_name = azurerm_resource_group.training.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.training[0].id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.training.id
  }
}

resource "azurerm_linux_virtual_machine" "vm" {
  name = var.name

  location            = azurerm_resource_group.training.location
  resource_group_name = azurerm_resource_group.training.name

  size                            = local.size
  admin_username                  = local.admin_username
  admin_password                  = local.admin_password
  disable_password_authentication = false
  admin_ssh_key {
    username   = local.admin_username
    public_key = local.admin_ssh_key
  }
  network_interface_ids = [
    azurerm_network_interface.vm.id,
  ]
  user_data = base64encode(
    <<EOF
#cloud-config
ssh_pwauth: yes
chpasswd:
  expire: false
runcmd:
  - |
    curl -fsSL https://ins.oxs.cz/slu-linux-amd64.sh | sudo sh
EOF
  )

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
