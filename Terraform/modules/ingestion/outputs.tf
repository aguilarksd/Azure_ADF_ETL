output "storage_account_name" {
  description = "The name of the Storage Account."
  value       = azurerm_storage_account.storage.name
}

output "data_factory_name" {
  description = "The name of the Data Factory."
  value       = azurerm_data_factory.data_factory.name
}

output "sql_server_fqdn" {
  description = "The FQDN of the created SQL Server."
  value       = azurerm_mssql_server.sql_server.fully_qualified_domain_name
}