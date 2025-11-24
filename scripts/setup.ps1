# setup.ps1
# ==============================================================================
# DESCRIPTION: Fetches Azure SQL Server details using Azure CLI and executes
#              the SQL setup file using native PowerShell command (Invoke-Sqlcmd).
# ==============================================================================

# --- 1. Define Variables ---
# Values from your input:
$ResourceGroupName = "KevinGrp"
$SQLAdminUser = "Kevinadmin"
$SQLAdminPass = "Kevinpass."

# >> CHANGE HERE: Define the correct path to your SQL file
$SQLScriptFile = "Terraform/assets/ingestion/db_schema_drop.sql"
$SQLScriptFile2 = "Terraform/assets/ingestion/db_schema.sql"
$SQLScriptFile3 = "Terraform/assets/ingestion/db_orders.sql"

# Generated names based on Terraform logic:
$RGPrefix = $ResourceGroupName.Substring(0, 3).ToLower() # Calculates "kev"
$SQLServerName = "serv$RGPrefix"                         # e.g., servkev
$DatabaseName = "DB$RGPrefix"                            # e.g., DBkev

# --- 2. Check Prerequisites ---
if (-not (Get-Module -Name SqlServer -ListAvailable)) {
    Write-Error "The 'SqlServer' PowerShell module is not installed. Please run: Install-Module -Name SqlServer -Scope CurrentUser"
    exit 1
}

# --- 3. Fetch FQDN using Azure CLI ('az') ---
Write-Host "Fetching FQDN for server $SQLServerName in $ResourceGroupName..."
# NOTE: You must be logged into 'az login' before running this script
$SQLServerFQDN = (az sql server show -n $SQLServerName -g $ResourceGroupName --query "fullyQualifiedDomainName" -o tsv 2>$null)

if (-not $SQLServerFQDN) {
    Write-Error "Could not retrieve SQL Server FQDN. Ensure 'az login' is complete and the server is deployed."
    exit 1
}

Write-Host "✅ FQDN Retrieved: $SQLServerFQDN"

# --- 4. Execute SQL Script using Invoke-Sqlcmd ---
Write-Host "Executing script $SQLScriptFile on database $DatabaseName..."

try {
    Invoke-Sqlcmd -ServerInstance $SQLServerFQDN `
                  -Database $DatabaseName `
                  -Username $SQLAdminUser `
                  -Password $SQLAdminPass `
                  -InputFile $SQLScriptFile `
                  -ConnectionTimeout 60

    Write-Host ""
    Write-Host "✅ Database schema setup completed successfully using Invoke-Sqlcmd."
}
catch {
    Write-Error "❌ Error executing Invoke-Sqlcmd: $($_.Exception.Message)"
    Write-Host "Please check your firewall rules, SQL admin password, and the db_setup.sql file content."
    exit 1
}

# --- 5. Execute SQL Script using Invoke-Sqlcmd ---
Write-Host "Executing script $SQLScriptFile2 on database $DatabaseName..."

try {
    Invoke-Sqlcmd -ServerInstance $SQLServerFQDN `
                  -Database $DatabaseName `
                  -Username $SQLAdminUser `
                  -Password $SQLAdminPass `
                  -InputFile $SQLScriptFile2 `
                  -ConnectionTimeout 60

    Write-Host ""
    Write-Host "✅ Database schema setup completed successfully using Invoke-Sqlcmd."
}
catch {
    Write-Error "❌ Error executing Invoke-Sqlcmd: $($_.Exception.Message)"
    Write-Host "Please check your firewall rules, SQL admin password, and the db_setup.sql file content."
    exit 1
}

# --- 6. Execute SQL Script using Invoke-Sqlcmd ---
Write-Host "Executing script $SQLScriptFile3 on database $DatabaseName..."

try {
    Invoke-Sqlcmd -ServerInstance $SQLServerFQDN `
                  -Database $DatabaseName `
                  -Username $SQLAdminUser `
                  -Password $SQLAdminPass `
                  -InputFile $SQLScriptFile3 `
                  -ConnectionTimeout 60

    Write-Host ""
    Write-Host "✅ Database schema setup completed successfully using Invoke-Sqlcmd."
}
catch {
    Write-Error "❌ Error executing Invoke-Sqlcmd: $($_.Exception.Message)"
    Write-Host "Please check your firewall rules, SQL admin password, and the db_setup.sql file content."
    exit 1
}