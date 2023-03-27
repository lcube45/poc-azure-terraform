terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.49.0"
    }
  }
  backend "azurerm" {
      resource_group_name  = "rg-poc-azure"
      storage_account_name = "tfstatepocazure"
      container_name       = "tfstate"
      key                  = "terraform.tfstate"
  }

}

provider "azurerm" {
  features {}
}