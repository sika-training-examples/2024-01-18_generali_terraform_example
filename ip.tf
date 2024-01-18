resource "azurerm_public_ip" "training" {
  name                = var.name
  resource_group_name = azurerm_resource_group.training.name
  location            = azurerm_resource_group.training.location
  allocation_method   = "Static"
}

output "ip" {
  value = azurerm_public_ip.training.ip_address
}
