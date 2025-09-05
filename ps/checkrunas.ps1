$isAdministrator = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

if ($isAdministrator) {
    Write-Host "The current PowerShell session is running with Administrator privileges."
} else {
    Write-Host "The current PowerShell session is NOT running with Administrator privileges."
}