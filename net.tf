locals {
  net          = "10.250.0.0/16"
  subnet_count = 2
}

resource "azurerm_virtual_network" "training" {
  name                = var.name
  address_space       = [local.net]
  location            = azurerm_resource_group.training.location
  resource_group_name = azurerm_resource_group.training.name
}

resource "azurerm_subnet" "training" {
  count = local.subnet_count

  name                 = "${azurerm_virtual_network.training.name}${count.index + 1}"
  resource_group_name  = azurerm_resource_group.training.name
  virtual_network_name = azurerm_virtual_network.training.name
  address_prefixes     = [cidrsubnet(local.net, 8, count.index + 1)]
}

resource "azurerm_subnet" "training2" {
  for_each = {
    foo = 11
    # bar = 12
    baz = 13
  }

  name                 = "${azurerm_virtual_network.training.name}-${each.key}"
  resource_group_name  = azurerm_resource_group.training.name
  virtual_network_name = azurerm_virtual_network.training.name
  address_prefixes     = [cidrsubnet(local.net, 8, each.value)]
}
