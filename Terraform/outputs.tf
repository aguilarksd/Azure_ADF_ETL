output "resource_group_name" {
  description = "The name of the created resource group."
  value       = azurerm_resource_group.project_rg.name
}

output "storage_account_name" {
  description = "The name of the Storage Account."
  value       = module.ingestion.storage_account_name
}

output "data_factory_name" {
  description = "The name of the Data Factory."
  value       = module.ingestion.data_factory_name
}

output "sql_server_fqdn" {
  description = "The fully qualified domain name (FQDN) of the SQL Server."
  value       = module.ingestion.sql_server_fqdn
}