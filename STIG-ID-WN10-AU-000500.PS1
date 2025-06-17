<#
.SYNOPSIS
    This PowerShell script ensures that the maximum size of the Windows Application event log is at least 32768 KB (32 MB).

.NOTES
    Author          : Alex Martinez
    LinkedIn        : linkedin.com/in/lxmrtnz/
    GitHub          : github.com/lxmrtnz
    Date Created    : 2025-06-10
    Last Modified   : 2025-06-10
    Version         : 1.0
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : WN10-AU-000500

.TESTED ON
    Date(s) Tested  : 2025-06-10
    Tested By       : Alex Martinez
    Systems Tested  : Win10 22H2 (19045.5965)
    PowerShell Ver. : 5.1.19041.5965

.USAGE
    Put any usage instructions here.
    Example syntax:
    PS C:\> .\STIG-ID-WN10-AU-000500.ps1 
#>

# Define the registry path and value settings
$registryPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\EventLog\Application"
$valueName = "MaxSize"
$valueData = 32768

# Check if the registry path exists; if not, create it
if (-not (Test-Path $registryPath)) {
    New-Item -Path $registryPath -Force | Out-Null  # Create the key silently
}

# Set or update the MaxSize value
Set-ItemProperty -Path $registryPath -Name $valueName -Value $valueData

# Confirm to the user
Write-Host "Registry value '$valueName' set to '$valueData' at '$registryPath'." -ForegroundColor Green
