<#
.SYNOPSIS
    This PowerShell script ensures that passwords must, at a minimum, be 14 characters.

.NOTES
    Author          : Alex Martinez
    LinkedIn        : linkedin.com/in/lxmrtnz/
    GitHub          : github.com/lxmrtnz
    Date Created    : 2025-06-17
    Last Modified   : 2025-06-17
    Version         : 1.0
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : WN10-AC-000035

.TESTED ON
    Date(s) Tested  : 2025-06-17
    Tested By       : Alex Martinez
    Systems Tested  : Win10 22H2 (19045.5965)
    PowerShell Ver. : 5.1.19041.5965

.USAGE
    Put any usage instructions here.
    Example syntax:
    PS C:\> .\STIG-ID-WN10-AC-000035.ps1 
#>

# Set the minimum password length to 14 characters

$minLength = 14

# Use the secedit tool to export current security settings
$tempInf = "$env:TEMP\secpol.inf"
$tempLog = "$env:TEMP\secpol.log"

secedit /export /cfg $tempInf /quiet

# Read the exported config file
$config = Get-Content $tempInf

# Check if the line exists and replace it or append it
if ($config -match "^MinimumPasswordLength") {
    $config = $config -replace "^MinimumPasswordLength\s*=\s*\d+", "MinimumPasswordLength = $minLength"
} else {
    $config += "MinimumPasswordLength = $minLength"
}

# Save the modified config back
$config | Set-Content $tempInf

# Apply the updated settings
secedit /configure /db secedit.sdb /cfg $tempInf /log $tempLog /quiet

# Clean up
Remove-Item $tempInf -ErrorAction SilentlyContinue
Remove-Item $tempLog -ErrorAction SilentlyContinue

Write-Host "Minimum password length set to $minLength characters." -ForegroundColor Green
