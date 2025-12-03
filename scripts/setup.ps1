# setup.ps1
# ==============================================================================
# DESCRIPTION: Fetches Azure SQL Server details using Azure CLI and executes
#              the SQL setup file using native PowerShell command (Invoke-Sqlcmd).
# ==============================================================================

# --- 1. Define Variables ---
# Values from your input:
$env:ResourceGroupName = "KevinGrp"
$env:SQLAdminUser = "Kevinadmin"
$env:SQLAdminPass = "Kevinpass."

# Generated names based on Terraform logic:
$env:RGPrefix = $env:ResourceGroupName.Substring(0, 3).ToLower() # Calculates "kev"
$env:SQLServerName = "serv$env:RGPrefix"                         # e.g., servkev
$env:DatabaseName = "DB$env:RGPrefix"                            # e.g., DBkev

# --- 2. Check Prerequisites ---
if (-not (Get-Module -Name SqlServer -ListAvailable)) {
    Write-Error "The 'SqlServer' PowerShell module is not installed. Please run: Install-Module -Name SqlServer -Scope CurrentUser"
    exit 1
}

# --- 3. Fetch FQDN using Azure CLI ('az') ---
Write-Host "Fetching FQDN for server $env:SQLServerName in $env:ResourceGroupName..."
# NOTE: You must be logged into 'az login' before running this script
$env:SQLServerFQDN = (az sql server show -n $env:SQLServerName -g $env:ResourceGroupName --query "fullyQualifiedDomainName" -o tsv 2>$null)

if (-not $env:SQLServerFQDN) {
    Write-Error "Could not retrieve SQL Server FQDN. Ensure 'az login' is complete and the server is deployed."
    exit 1
}

Write-Host "✅ FQDN Retrieved: $env:SQLServerFQDN"