# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "quantum_runner" {
  name     = "quantum_runner"
  location = "West Europe"
}
