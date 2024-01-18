module "vm-from-git" {
  source = "git::https://github.com/sika-training-examples/2024-01-18_vm_module_example.git?ref=master"

  location            = azurerm_resource_group.training.location
  resource_group_name = azurerm_resource_group.training.name
  subnet_id           = azurerm_subnet.training[0].id
  name                = "${var.name}-from-git"
  ssh_key             = local.admin_ssh_key
  user_data           = local.user_data
}
