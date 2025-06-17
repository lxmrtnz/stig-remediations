<#
.SYNOPSIS
    This PowerShell script ensures that the maximum size of the Security event log is at least 1024000 KB (1024 MB).

.NOTES
    Author          : Alex Martinez
    LinkedIn        : linkedin.com/in/lxmrtnz/
    GitHub          : github.com/lxmrtnz
    Date Created    : 2025-06-17
    Last Modified   : 2025-06-17
    Version         : 1.0
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : WN10-AU-000505

.TESTED ON
    Date(s) Tested  : 2025-06-17
    Tested By       : Alex Martinez
    Systems Tested  : Win10 22H2 (19045.5965)
    PowerShell Ver. : 5.1.19041.5965

.USAGE
    Put any usage instructions here.
    Example syntax:
    PS C:\> .\STIG-ID-WN10-AU-000505.ps1 
#>

# Define registry path and value settings
$registryPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\EventLog\Security"
$valueName = "MaxSize"
$requiredValue = 1024000  # Equivalent to 0x000fa000

# Create the registry path if it doesn't exist
if (-not (Test-Path $registryPath)) {
    New-Item -Path $registryPath -Force | Out-Null
    Write-Host "Created registry path: $registryPath" -ForegroundColor Yellow
}

# Get current value if it exists
$currentValue = Get-ItemProperty -Path $registryPath -Name $valueName -ErrorAction SilentlyContinue | Select-Object -ExpandProperty $valueName -ErrorAction SilentlyContinue

# Create or update the MaxSize value if needed
if ($null -eq $currentValue) {
    New-ItemProperty -Path $registryPath -Name $valueName -PropertyType DWord -Value $requiredValue -Force | Out-Null
    Write-Host "Created '$valueName' and set to $requiredValue KB." -ForegroundColor Yellow
} elseif ($currentValue -lt $requiredValue) {
    Set-ItemProperty -Path $registryPath -Name $valueName -Value $requiredValue
    Write-Host "Updated '$valueName' from $currentValue to $requiredValue KB." -ForegroundColor Yellow
} else {
    Write-Host "'$valueName' is already set to $currentValue KB (OK)." -ForegroundColor Green
}
