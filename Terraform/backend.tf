terraform {
  required_providers {
    random = {
      source  = "hashicorp/random"
      version = "3.5.1"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.82.0"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 2.46.0"
    }
    github = {
      source  = "integrations/github"
      version = "~> 5.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.25.2"
    }
  }
  #initialise the backend
  backend "azurerm" {
    resource_group_name  = "tfstaterg01"
    storage_account_name = "tfstate01919804057"
    container_name       = "tfstate"
    key                  = "petstore.tfstate"
  }

}
provider "azurerm" {
  features {
  }
  subscription_id = "cb5b077c-3ef5-4b2e-83e5-490cc5ca0e19"
  client_id       = "078ab0d9-ed03-445a-816a-b3eb595f9238"
  client_secret   = "4Uy8Q~i0qzkjmqak2_CUmYT84qoQkUD.cw8NIc1Y"
  tenant_id       = "16b3c013-d300-468d-ac64-7eda0820b6d3"
}