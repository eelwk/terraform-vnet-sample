variable "prefix" {
  description = "The Prefix used for all resources in this example. Example: wb-test"
  default = "wb-testtest"
}

variable "location" {
  description = "The Azure Region in which all resources in this example should be created. Example: West US"
  default = "West US"
}

variable "storageaccount" {
  description = "The storage account the function app should use"
  default = "wbtestterraformstorage"
}