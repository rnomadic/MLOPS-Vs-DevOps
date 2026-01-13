# Define the provider and required versions
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
  
  # Configure the remote backend using Azure Blob Storage
  backend "azurerm" {
    resource_group_name  = "rg-tfstate"
    storage_account_name = "tfstatestorageacct" # Must be globally unique
    container_name       = "tfstate-container"
    key                  = "mlops/production.tfstate" # The path to the state file
  }
}

# Configure the Azure provider
provider "azurerm" {
  features {}
}

# Central resource group
resource "azurerm_resource_group" "mlops" {
  name     = "rg-mlops-env-prod"
  location = "East US"
}