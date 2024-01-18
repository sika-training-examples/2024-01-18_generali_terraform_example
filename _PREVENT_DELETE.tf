resource "null_resource" "PREVENT_DELETE" {
  depends_on = [
    # azurerm_public_ip.ip2,
  ]

  lifecycle {
    # prevent_destroy = true
  }
}
