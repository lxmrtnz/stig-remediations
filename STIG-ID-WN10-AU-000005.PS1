<#
.SYNOPSIS
    This PowerShell script ensures that the account lockout duration is 15 min or greater.

.NOTES
    Author          : Alex Martinez
    LinkedIn        : linkedin.com/in/lxmrtnz/
    GitHub          : github.com/lxmrtnz
    Date Created    : 2025-06-17
    Last Modified   : 2025-06-17
    Version         : 1.0
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : WN10-AC-000005

.TESTED ON
    Date(s) Tested  : 2025-06-17
    Tested By       : Alex Martinez
    Systems Tested  : Win10 22H2 (19045.5965)
    PowerShell Ver. : 5.1.19041.5965

.USAGE
    Put any usage instructions here.
    Example syntax:
    PS C:\> .\STIG-ID-WN10-AC-000005.ps1 
#>

# Set the account lockout duration to 15 minutes

$lockoutDuration = 15

# Use the secedit tool to export current security settings
$tempInf = "$env:TEMP\secpol.inf"
$tempLog = "$env:TEMP\secpol.log"

secedit /export /cfg $tempInf /quiet

# Read the exported config file
$config = Get-Content $tempInf

# Check if the line exists and replace it or append it
if ($config -match "^LockoutDuration") {
    $config = $config -replace "^LockoutDuration\s*=\s*\d+", "LockoutDuration = $lockoutDuration"
} else {
    $config += "LockoutDuration = $lockoutDuration"
}

# Save the modified config back
$config | Set-Content $tempInf

# Apply the updated settings
secedit /configure /db secedit.sdb /cfg $tempInf /log $tempLog /quiet

# Clean up
Remove-Item $tempInf -ErrorAction SilentlyContinue
Remove-Item $tempLog -ErrorAction SilentlyContinue

Write-Host "Account lockout duration set to $lockoutDuration minutes." -ForegroundColor Green
