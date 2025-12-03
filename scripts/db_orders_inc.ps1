$SQLScriptFile = "Terraform/assets/ingestion/db_orders_inc.sql"


Write-Host "Executing script $SQLScriptFile on database $env:DatabaseName..."

try {
    Invoke-Sqlcmd -ServerInstance $env:SQLServerFQDN `
                  -Database $env:DatabaseName `
                  -Username $env:SQLAdminUser `
                  -Password $env:SQLAdminPass `
                  -InputFile $SQLScriptFile `
                  -ConnectionTimeout 60

    Write-Host ""
    Write-Host "✅ Database orders load completed successfully"
}
catch {
    Write-Error "❌ Error executing Invoke-Sqlcmd: $($_.Exception.Message)"
    Write-Host "Please check your firewall rules, SQL admin password, and the db_orders_inc.sql file content."
    exit 1
}
