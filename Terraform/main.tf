# Configure the Azure Provider
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}

provider "azurerm" {
  features {}
}

## 🚀 Resource Group for the Whole Project

resource "azurerm_resource_group" "project_rg" {
  name     = var.resource_group_name
  location = var.location_east
  tags = {
    Environment = "ProjectKevin"
  }
}

## 📦 Ingestion Module Call

module "ingestion" {
  source = "./modules/ingestion"

  resource_group_name          = azurerm_resource_group.project_rg.name
  resource_group_location_west = var.location_west
  resource_group_location_east = var.location_east
  sql_admin_username           = var.sql_admin_username
  sql_admin_password           = var.sql_admin_password
  entra_admin_username         = var.entra_admin_username  
  client_ip_address            = var.client_ip_address       
}