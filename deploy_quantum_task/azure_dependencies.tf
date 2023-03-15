# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}
}

variable "azure_subscription_id" {
  type = string
}
variable "azure_location" {
  type = string
  default = "West Europe"
}

resource "azurerm_subscription" "subscription" {
  alias             = "QuantumRunnerSubscription"
  subscription_id   = var.azure_subscription_id
  subscription_name = "Quantum Runner Subscription"
}

resource "azurerm_resource_group" "quantum_runner" {
  name     = "quantum_runner"
  location = var.azure_location
}

resource "azurerm_storage_account" "quantum_results" {
  name                     = "quantumresults"
  resource_group_name      = azurerm_resource_group.quantum_runner.name
  location                 = azurerm_resource_group.quantum_runner.location
  account_tier             = "Standard"
  account_replication_type = "GRS"
}
