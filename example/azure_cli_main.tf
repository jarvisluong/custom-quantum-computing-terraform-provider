provider "shell" {
}

variable "azure_workspace_name" {
  type = string
  default = "QuantumRunnerWorkspace"
}

resource "shell_script" "azure_job" {
  lifecycle_commands {
    create = file("${path.module}/azure_scripts/create.sh")
    read   = file("${path.module}/azure_scripts/read.sh")
    update = file("${path.module}/azure_scripts/update.sh")
    delete = file("${path.module}/azure_scripts/delete.sh")
  }

  environment = {
    AZURE_RESOURCE_GROUP        = resource.azurerm_resource_group.quantum_runner.name
    WORKSPACE_NAME = var.azure_workspace_name
    AZURE_LOCATION = var.azure_location
    AZURE_STORAGE_ACCOUNT = resource.azurerm_storage_account.quantum_results.name
  }
}