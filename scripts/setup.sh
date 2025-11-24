#!/bin/bash

# --- 1. Hardcoded Variables (from your input) ---
RESOURCE_GROUP_NAME="KevinGrp"
SQL_ADMIN_USERNAME="Kevinadmin"
SQL_ADMIN_PASSWORD="Kevinpass."

# --- 2. Determine Terraform-Generated Resource Names ---
# The Terraform prefix is the first 3 characters of the resource group name, lowercased.
RG_PREFIX=$(echo "$RESOURCE_GROUP_NAME" | tr '[:upper:]' '[:lower:]' | cut -c 1-3)
# Based on your Terraform: serv{prefix} and DB{prefix}
SQL_SERVER_NAME="serv${RG_PREFIX}"
SQL_DATABASE_NAME="DB${RG_PREFIX}"
SQL_SCRIPT_FILE="Terraform/assets/ingestion/db_setup.sql"

echo "Attempting to connect to Server: ${SQL_SERVER_NAME} / Database: ${SQL_DATABASE_NAME}"
echo "Resource Group: ${RESOURCE_GROUP_NAME}"
echo "SQL Script to execute: ${SQL_SCRIPT_FILE}"

# --- 3. Fetch the Fully Qualified Domain Name (FQDN) using Azure CLI ---
echo ""
echo "Fetching SQL Server FQDN..."
SQL_SERVER_FQDN=$(az sql server show \
  --name "$SQL_SERVER_NAME" \
  --resource-group "$RESOURCE_GROUP_NAME" \
  --query "fullyQualifiedDomainName" \
  --output tsv 2>/dev/null)

if [ -z "$SQL_SERVER_FQDN" ]; then
  echo "❌ Error: Could not retrieve SQL Server FQDN."
  echo "   Ensure the server name ('${SQL_SERVER_NAME}') and resource group ('${RESOURCE_GROUP_NAME}') are correct and fully deployed."
  exit 1
fi

echo "✅ FQDN Retrieved: ${SQL_SERVER_FQDN}"

# --- 4. Execute SQL Script using sqlcmd ---
echo ""
echo "Executing SQL commands via sqlcmd..."
# The -S, -d, -U, and -P options are used to connect and authenticate.
# Replace the path with the location you found on your machine!
python "C:\Users\Kevin Aguilar\miniconda3\Scripts\mssql-cli" \
          -S "$SQL_SERVER_FQDN" \
          -d "$SQL_DATABASE_NAME" \
          -U "$SQL_ADMIN_USERNAME" \
          -P "$SQL_ADMIN_PASSWORD" \
          -i "$SQL_SCRIPT_FILE"

# --- 5. Check the Exit Status ---
if [ $? -eq 0 ]; then
  echo ""
  echo "✅ Database schema setup (CREATE TABLE & INSERT) completed successfully."
else
  echo ""
  echo "❌ Error executing sqlcmd. Check your firewall rules, credentials, and the '${SQL_SCRIPT_FILE}' content."
  echo "   (Make sure 'sqlcmd' is installed and available in your PATH)."
fi