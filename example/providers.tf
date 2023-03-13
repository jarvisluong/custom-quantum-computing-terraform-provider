terraform {
  required_providers {
    quantumrunners = {
      source = "hashicorp.com/edu/quantumrunners"
    }
    aws = {
      source  = "hashicorp/aws"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
    }
    local = {
      source = "hashcorp/local"
    }
    shell = {
      source = "scottwinkler/shell"
    }

  }
}
