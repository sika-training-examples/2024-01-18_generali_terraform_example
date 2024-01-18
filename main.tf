terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.87.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.6.0"
    }
  }
}

variable "azurerm_tenant_id" {}
variable "azurerm_subscription_id" {}
variable "azurerm_client_id" {}
variable "azurerm_client_secret" {}

provider "azurerm" {
  features {}
  tenant_id       = var.azurerm_tenant_id
  subscription_id = var.azurerm_subscription_id
  client_id       = var.azurerm_client_id
  client_secret   = var.azurerm_client_secret
}

variable "name" {
  type = string
}

resource "azurerm_resource_group" "training" {
  name     = "training-${var.name}"
  location = "westeurope"

  tags = {
    managed_by = "terraform"
    aaa        = "bbb"
    foo        = "bar"
  }
}

data "azurerm_resource_group" "nw" {
  name = "NetworkWatcherRG"
}

output "rg_training_id" {
  value = azurerm_resource_group.training.id
}

output "rg_nw_id" {
  value = data.azurerm_resource_group.nw.id
}

resource "random_password" "password" {
  length           = 16
  special          = true
  override_special = "_"
}

output "password" {
  value     = random_password.password.result
  sensitive = true
}

locals {
  admin_ssh_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCslNKgLyoOrGDerz9pA4a4Mc+EquVzX52AkJZz+ecFCYZ4XQjcg2BK1P9xYfWzzl33fHow6pV/C6QC3Fgjw7txUeH7iQ5FjRVIlxiltfYJH4RvvtXcjqjk8uVDhEcw7bINVKVIS856Qn9jPwnHIhJtRJe9emE7YsJRmNSOtggYk/MaV2Ayx+9mcYnA/9SBy45FPHjMlxntoOkKqBThWE7Tjym44UNf44G8fd+kmNYzGw9T5IKpH1E1wMR+32QJBobX6d7k39jJe8lgHdsUYMbeJOFPKgbWlnx9VbkZh+seMSjhroTgniHjUl8wBFgw0YnhJ/90MgJJL4BToxu9PVnH"
  user_data     = <<EOF
#cloud-config
ssh_pwauth: yes
chpasswd:
  expire: false
runcmd:
  - |
    curl -fsSL https://ins.oxs.cz/slu-linux-amd64.sh | sudo sh
EOF
}

module "vm" {
  source = "./modules/vm"

  location             = azurerm_resource_group.training.location
  resource_group_name  = azurerm_resource_group.training.name
  subnet_id            = azurerm_subnet.training[0].id
  name                 = var.name
  ssh_key              = local.admin_ssh_key
  user_data            = local.user_data
  public_ip_address_id = azurerm_public_ip.training.id
}

module "vm2" {
  source = "./modules/vm"

  location            = azurerm_resource_group.training.location
  resource_group_name = azurerm_resource_group.training.name
  subnet_id           = azurerm_subnet.training[0].id
  name                = "${var.name}-2"
  ssh_key             = local.admin_ssh_key
  user_data           = local.user_data
}

output "vm2_ip" {
  value = module.vm2.private_ip_address
}
