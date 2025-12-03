
$SQLScriptFile = "Terraform/assets/ingestion/db_schema_drop.sql"
$SQLScriptFile2 = "Terraform/assets/ingestion/db_schema.sql"
$SQLScriptFile3 = "Terraform/assets/ingestion/db_orders.sql"

# --- 4. Execute SQL Script using Invoke-Sqlcmd ---
Write-Host "Executing script $SQLScriptFile on database $env:DatabaseName..."

try {
    Invoke-Sqlcmd -ServerInstance $env:SQLServerFQDN `
                  -Database $env:DatabaseName `
                  -Username $env:SQLAdminUser `
                  -Password $env:SQLAdminPass `
                  -InputFile $SQLScriptFile `
                  -ConnectionTimeout 60

    Write-Host ""
    Write-Host "✅ Database schema drop completed successfully"
}
catch {
    Write-Error "❌ Error executing Invoke-Sqlcmd: $($_.Exception.Message)"
    Write-Host "Please check your firewall rules, SQL admin password, and the db_schema_drop.sql file content."
    exit 1
}

# --- 5. Execute SQL Script using Invoke-Sqlcmd ---
Write-Host "Executing script $SQLScriptFile2 on database $env:DatabaseName..."

try {
    Invoke-Sqlcmd -ServerInstance $env:SQLServerFQDN `
                  -Database $env:DatabaseName `
                  -Username $env:SQLAdminUser `
                  -Password $env:SQLAdminPass `
                  -InputFile $SQLScriptFile2 `
                  -ConnectionTimeout 60

    Write-Host ""
    Write-Host "✅ Database schema setup completed successfully"
}
catch {
    Write-Error "❌ Error executing Invoke-Sqlcmd: $($_.Exception.Message)"
    Write-Host "Please check your firewall rules, SQL admin password, and the db_schema.sql file content."
    exit 1
}

# --- 6. Execute SQL Script using Invoke-Sqlcmd ---
Write-Host "Executing script $SQLScriptFile3 on database $env:DatabaseName..."

try {
    Invoke-Sqlcmd -ServerInstance $env:SQLServerFQDN `
                  -Database $env:DatabaseName `
                  -Username $env:SQLAdminUser `
                  -Password $env:SQLAdminPass `
                  -InputFile $SQLScriptFile3 `
                  -ConnectionTimeout 60

    Write-Host ""
    Write-Host "✅ Database orders setup completed successfully"
}
catch {
    Write-Error "❌ Error executing Invoke-Sqlcmd: $($_.Exception.Message)"
    Write-Host "Please check your firewall rules, SQL admin password, and the db_orders.sql file content."
    exit 1
}