provider "azurerm" {
  # whilst the `version` attribute is optional, we recommend pinning to a given version of the Provider
  version = "=1.33.0"
}

terraform {
  backend "azurerm" {
    storage_account_name  = "wbtestterraformstorage"
    container_name        = "tfstate"
    key                   = "terraform.tfstate"
   }
}

resource "azurerm_resource_group" "dev" {
  name     = "${var.prefix}-rg"
  location = "${var.location}"
}

resource "azurerm_virtual_network" "dev" {
  name                = "${var.prefix}-network"
  resource_group_name = "${azurerm_resource_group.dev.name}"
  location            = "${azurerm_resource_group.dev.location}"
  address_space       = ["10.0.0.0/16"]
}

resource "azurerm_subnet" "dev" {
  name                 = "internal"
  virtual_network_name = "${azurerm_virtual_network.dev.name}"
  resource_group_name  = "${azurerm_resource_group.dev.name}"
  address_prefix       = "10.0.1.0/24"
}