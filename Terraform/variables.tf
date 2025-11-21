variable "resource_group_name" {
  description = "Name for the main resource group."
  type        = string
}

variable "location_west" {
  description = "The location for resources in the West US 2 region."
  type        = string
}

variable "location_east" {
  description = "The location for resources in the East US region."
  type        = string
}

variable "sql_admin_username" {
  description = "Administrator username for the SQL Server."
  type        = string
}

variable "sql_admin_password" {
  description = "Administrator password for the SQL Server."
  type        = string
  sensitive   = true 
}

variable "entra_admin_username" {
  description = "Microsoft Entra (formerly Azure AD) administrator UPN."
  type        = string
}

variable "client_ip_address" {
  description = "Your current public IP address to be added to the SQL Firewall. Format: X.X.X.X"
  type        = string
}