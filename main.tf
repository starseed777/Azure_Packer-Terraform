terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=2.46.0"
    }
  }
}


provider "azurerm" {
  features {}
}


terraform {
  backend "azurerm" {
    subscription_id      = "63819f8f-0d1e-4647-a036-8ec547e4c564"
    resource_group_name  = "terraform"
    storage_account_name = "blobjawnt"
    container_name       = "blobjawnt"
    key                  = "terraform.tfstate"
  }
}

module "vnet" {
  source = "./vnetmod"
}



