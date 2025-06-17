<#
.SYNOPSIS
    This PowerShell script ensures that users will be prompted for a password on resume from sleep (on battery).

.NOTES
    Author          : Alex Martinez
    LinkedIn        : linkedin.com/in/lxmrtnz/
    GitHub          : github.com/lxmrtnz
    Date Created    : 2025-06-17
    Last Modified   : 2025-06-17
    Version         : 1.0
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : WN10-CC-000145

.TESTED ON
    Date(s) Tested  : 2025-06-17
    Tested By       : Alex Martinez
    Systems Tested  : Win10 22H2 (19045.5965)
    PowerShell Ver. : 5.1.19041.5965

.USAGE
    Put any usage instructions here.
    Example syntax:
    PS C:\> .\STIG-ID-WN10-CC-000145.ps1 
#>

# Define registry path and required value
$registryPath = "HKLM:\SOFTWARE\Policies\Microsoft\Power\PowerSettings\0e796bdb-100d-47d6-a2d5-f7d2daa51f51"
$valueName = "DCSettingIndex"
$requiredValue = 1

# Create the registry path if it doesn't exist
if (-not (Test-Path $registryPath)) {
    New-Item -Path $registryPath -Force | Out-Null
}

# Check if the value exists
$currentValue = Get-ItemProperty -Path $registryPath -Name $valueName -ErrorAction SilentlyContinue

# Set the value if it doesn't exist or is incorrect
if ($null -eq $currentValue -or $currentValue.$valueName -ne $requiredValue) {
    Set-ItemProperty -Path $registryPath -Name $valueName -Value $requiredValue -Type DWord
    Write-Host "DCSettingIndex set to $requiredValue at '$registryPath'." -ForegroundColor Green
} else {
    Write-Host "DCSettingIndex already set correctly at '$registryPath'." -ForegroundColor Yellow
}
