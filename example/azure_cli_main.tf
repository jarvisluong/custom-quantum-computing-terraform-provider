provider "shell" {
}

variable "azure_workspace_name" {
  type = string
  default = "QuantumRunnerWorkspace"
}

variable "azure_quantum_job_runner_target" {
  type = string
  default = "ionq.qpu"
}

resource "shell_script" "azure_workspace" {
  lifecycle_commands {
    create = file("${path.module}/azure_quantum_workspace_scripts/create.sh")
    delete = file("${path.module}/azure_quantum_workspace_scripts/delete.sh")
  }

  environment = {
    AZURE_RESOURCE_GROUP        = resource.azurerm_resource_group.quantum_runner.name
    WORKSPACE_NAME = var.azure_workspace_name
    AZURE_LOCATION = var.azure_location
    AZURE_STORAGE_ACCOUNT = resource.azurerm_storage_account.quantum_results.name
  }
}

data "shell_script" "available_azure_runner_target" {
  lifecycle_commands {
    read = file("${path.module}/azure_quantum_targets/read.sh")
  }

  environment = {
    AZURE_RESOURCE_GROUP        = resource.azurerm_resource_group.quantum_runner.name
    WORKSPACE_NAME = var.azure_workspace_name
    AZURE_LOCATION = var.azure_location
  }

  depends_on = [
    resource.shell_script.azure_workspace
  ]
}

resource "shell_script" "azure_quantum_job" {
  lifecycle_commands {
    create = file("${path.module}/azure_quantum_job_scripts/create.sh")
    delete = file("${path.module}/azure_quantum_job_scripts/delete.sh")
  }

  environment = {
    AZURE_RESOURCE_GROUP        = resource.azurerm_resource_group.quantum_runner.name
    WORKSPACE_NAME = var.azure_workspace_name
    AZURE_LOCATION = var.azure_location
    AZURE_STORAGE_ACCOUNT = resource.azurerm_storage_account.quantum_results.name
    JOB_RUNNER_TARGET = var.azure_quantum_job_runner_target
    CIRCUIT_CONTENT_PATH = "${path.module}/example.qasm"
  }

  depends_on = [
    resource.shell_script.azure_workspace
  ]
}