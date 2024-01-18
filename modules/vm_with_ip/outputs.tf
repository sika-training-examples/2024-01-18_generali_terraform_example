output "private_ip_address" {
  value = azurerm_network_interface.this.private_ip_address
}

output "public_ip_address" {
  value = var.public_ip ? azurerm_public_ip.this[0].ip_address : null
}
