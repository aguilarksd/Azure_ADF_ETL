# Data source to retrieve the identity of the user running Terraform. 
# This is needed to get the Object ID for the Entra ID Admin setup.
data "azurerm_client_config" "current" {}

## 💾 Storage Account (East US) - kevingstorage (ADLS Gen2)

resource "azurerm_storage_account" "storage" {
  name                     = "stor${substr(lower(var.resource_group_name), 0, 3)}" 
  resource_group_name      = var.resource_group_name
  location                 = var.resource_group_location_east
  account_tier             = "Standard"
  account_replication_type = "LRS"
  account_kind             = "StorageV2"
  is_hns_enabled           = true
}
## 🏭 Data Factory (V2) (East US) - kevingdf

resource "azurerm_data_factory" "data_factory" {
  name                = "df${substr(lower(var.resource_group_name), 0, 3)}"
  resource_group_name = var.resource_group_name
  location            = var.resource_group_location_east
}

# 💻 SQL Server (West US 2) - kevinserv (SQL & Entra ID Auth)

resource "azurerm_mssql_server" "sql_server" {
  name                         = "serv${substr(lower(var.resource_group_name), 0, 3)}"
  resource_group_name          = var.resource_group_name
  location                     = var.resource_group_location_west
  version                      = "12.0"
  administrator_login          = var.sql_admin_username
  administrator_login_password = var.sql_admin_password
  # Microsoft Entra (formerly Azure AD) Authentication
  azuread_administrator {
    login_username = var.entra_admin_username
    object_id      = data.azurerm_client_config.current.object_id
  }
}

## 📊 SQL Database 

resource "azurerm_mssql_database" "sql_database" {
  name                        = "DB${substr(lower(var.resource_group_name), 0, 3)}"
  server_id                   = azurerm_mssql_server.sql_server.id
  sku_name                    = "GP_S_Gen5_1" 
  zone_redundant              = false
  max_size_gb                 = 1
  auto_pause_delay_in_minutes = 60
  min_capacity                = 0.5 
}

## 🛡️ SQL Server Firewall Rules (Public Endpoint Access)

# Rule 1: Allow Azure Services and Resources to Access Server
resource "azurerm_mssql_firewall_rule" "allow_azure_services" {
  name                = "AllowAzureServices"
  server_id           = azurerm_mssql_server.sql_server.id
  start_ip_address    = "0.0.0.0"
  end_ip_address      = "0.0.0.0"
}

# Rule 2: Add Current Client IP Address - CORRECTED RESOURCE TYPE AND ARGUMENTS
resource "azurerm_mssql_firewall_rule" "allow_client_ip" { 
  name                = "AllowClientIP"
  server_id           = azurerm_mssql_server.sql_server.id
  start_ip_address    = var.client_ip_address
  end_ip_address      = var.client_ip_address
}
