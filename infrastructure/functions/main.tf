provider "azurerm" {
  # whilst the `version` attribute is optional, we recommend pinning to a given version of the Provider
  version = "=1.33.0"
}

# when running this locally, run this: terraform init -backend-config="access_key=changeme"
terraform {
  backend "azurerm" {
    storage_account_name  = "wbtestterraformstorage"
    container_name        = "function"
    key                   = "terraform.tfstate"
   }
}

resource "azurerm_resource_group" "dev" {
  name     = "${var.prefix}-rg"
  location = "${var.location}"
}

resource "azurerm_storage_account" "dev" {
  name                     = "${var.storageaccount}"
  resource_group_name      = "${azurerm_resource_group.dev.name}"
  location                 = "${azurerm_resource_group.dev.location}"
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_app_service_plan" "dev" {
  name                = "azure-functions-dev-service-plan"
  location            = "${azurerm_resource_group.dev.location}"
  resource_group_name = "${azurerm_resource_group.dev.name}"
  kind                = "FunctionApp"

  sku {
    tier = "Dynamic"
    size = "Y1"
  }
}

resource "azurerm_function_app" "dev" {
  name                      = "${var.prefix}-function"
  location                  = "${azurerm_resource_group.dev.location}"
  resource_group_name       = "${azurerm_resource_group.dev.name}"
  app_service_plan_id       = "${azurerm_app_service_plan.dev.id}"
  storage_connection_string = "${azurerm_storage_account.dev.primary_connection_string}"
  version                   = "~2"
}