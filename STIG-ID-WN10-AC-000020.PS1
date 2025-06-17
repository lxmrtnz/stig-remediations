<#
.SYNOPSIS
    This PowerShell script ensures that password history will be configured to 24 passwords remembered.

.NOTES
    Author          : Alex Martinez
    LinkedIn        : linkedin.com/in/lxmrtnz/
    GitHub          : github.com/lxmrtnz
    Date Created    : 2025-06-17
    Last Modified   : 2025-06-17
    Version         : 1.0
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : WN10-AC-000020

.TESTED ON
    Date(s) Tested  : 2025-06-17
    Tested By       : Alex Martinez
    Systems Tested  : Win10 22H2 (19045.5965)
    PowerShell Ver. : 5.1.19041.5965

.USAGE
    Put any usage instructions here.
    Example syntax:
    PS C:\> .\STIG-ID-WN10-AC-000020.ps1 
#>

# Set the "Enforce password history" policy to 24 passwords remembered

$passwordHistory = 24

# Paths for temp files
$tempInf = "$env:TEMP\secpol.inf"
$tempLog = "$env:TEMP\secpol.log"

# Export current security settings
secedit /export /cfg $tempInf /quiet

# Read the .inf file into a variable
$config = Get-Content $tempInf

# Check if policy already exists and modify or add accordingly
if ($config -match "^PasswordHistorySize") {
    $config = $config -replace "^PasswordHistorySize\s*=\s*\d+", "PasswordHistorySize = $passwordHistory"
} else {
    $config += "PasswordHistorySize = $passwordHistory"
}

# Save updated config
$config | Set-Content $tempInf

# Apply updated policy
secedit /configure /db secedit.sdb /cfg $tempInf /log $tempLog /quiet

# Clean up temp files
Remove-Item $tempInf -ErrorAction SilentlyContinue
Remove-Item $tempLog -ErrorAction SilentlyContinue

Write-Host "Password history policy set to remember $passwordHistory passwords." -ForegroundColor Green
