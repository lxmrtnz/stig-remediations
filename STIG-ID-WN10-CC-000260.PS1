<#
.SYNOPSIS
    This PowerShell script ensures that the minimum pin length is set to 6.

.NOTES
    Author          : Alex Martinez
    LinkedIn        : linkedin.com/in/lxmrtnz/
    GitHub          : github.com/lxmrtnz
    Date Created    : 2025-06-17
    Last Modified   : 2025-06-17
    Version         : 1.0
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : WN10-CC-000260

.TESTED ON
    Date(s) Tested  : 2025-06-17
    Tested By       : Alex Martinez
    Systems Tested  : Win10 22H2 (19045.5965)
    PowerShell Ver. : 5.1.19041.5965

.USAGE
    Put any usage instructions here.
    Example syntax:
    PS C:\> .\STIG-ID-WN10-CC-000260.ps1 
#>

# Define registry path and required values
$registryPath = "HKLM:\SOFTWARE\Policies\Microsoft\PassportForWork\PINComplexity"
$valueName = "MinimumPINLength"
$requiredValue = 6

# Create the registry key if it doesn't exist
if (-not (Test-Path $registryPath)) {
    New-Item -Path $registryPath -Force | Out-Null
}

# Get current value if it exists
$currentValue = (Get-ItemProperty -Path $registryPath -Name $valueName -ErrorAction SilentlyContinue).$valueName

# If the value is missing or less than required, set it
if ($null -eq $currentValue -or $currentValue -lt $requiredValue) {
    Set-ItemProperty -Path $registryPath -Name $valueName -Value $requiredValue -Type DWord
    Write-Host "'$valueName' set to $requiredValue at '$registryPath'." -ForegroundColor Green
} else {
    Write-Host "'$valueName' already set to $currentValue (compliant)." -ForegroundColor Yellow
}
