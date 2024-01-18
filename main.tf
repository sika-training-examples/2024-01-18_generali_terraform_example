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
