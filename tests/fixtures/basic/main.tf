terraform {
  required_version = ">= 1.13.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.64.0"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "this" {
  name     = var.resource_group_name
  location = var.location
}

module "storage_account" {
  source = "../../../"

  name                = var.storage_account_name
  location            = var.location
  resource_group_name = azurerm_resource_group.this.name
}
