terraform {
  required_version = "~> 1.8.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.2.0"
    }
    null = {
      source  = "hashicorp/null"
      version = "~> 3.2.0"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "~> 4.0.5"
    }
  }
}

provider "azurerm" {
  features {
  }
}

provider "null" {
}