provider "shell" {
}

resource "shell_script" "azure_job" {
  lifecycle_commands {
    create = file("${path.module}/azure_scripts/create.sh")
    read   = file("${path.module}/azure_scripts/read.sh")
    update = file("${path.module}/azure_scripts/update.sh")
    delete = file("${path.module}/azure_scripts/delete.sh")
  }

  environment = {
    NAME        = "HELLO-WORLD"
    DESCRIPTION = "description"
  }
}