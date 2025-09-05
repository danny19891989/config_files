# Ensure script is run as Administrator
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Error "Please run this script as Administrator."
    exit
}

# Define paths
$customPath = "C:\custom"
$desktopPath = "$env:USERPROFILE\Desktop"
$launcherPath = "$customPath\launch_english.ps1"
$shortcutPath = "$desktopPath\win vim.lnk"
$iconPath = "$PSScriptRoot\custom.ico"

# Create C:\custom if missing
if (-not (Test-Path $customPath)) {
    New-Item -Path $customPath -ItemType Directory | Out-Null
    Write-Host "Created folder: $customPath"
} else {
    Write-Host "Folder already exists: $customPath"
}

# Copy AHK scripts
$ahkFiles = @("english.ahk", "persian.ahk")
foreach ($file in $ahkFiles) {
    $source = Join-Path $PSScriptRoot $file
    $target = Join-Path $customPath $file
    if (Test-Path $source) {
        Copy-Item -Path $source -Destination $target -Force
        Write-Host "Copied $file to $customPath"
    } else {
        Write-Warning "$file not found in script directory. Skipping..."
    }
}

# Create launch_english.ps1
$launcherScript = @'
Add-Type -AssemblyName PresentationFramework

$ahkExe = "C:\Program Files\AutoHotkey\AutoHotkey.exe"
if (-not (Test-Path $ahkExe)) {
    $ahkExe = "C:\Program Files (x86)\AutoHotkey\AutoHotkey.exe"
}
if (-not (Test-Path $ahkExe)) {
    [System.Windows.MessageBox]::Show("AutoHotkey.exe not found.")
    exit
}

$scriptPath = "C:\custom\english.ahk"

$running = Get-Process AutoHotkey -ErrorAction SilentlyContinue | Where-Object {
    $_.Path -eq $ahkExe -and $_.CommandLine -like "*english.ahk*"
}
foreach ($proc in $running) {
    try {
        Stop-Process -Id $proc.Id -Force
    } catch {
        [System.Windows.MessageBox]::Show("Could not stop process ID $($proc.Id)")
    }
}

Start-Process -FilePath $ahkExe -ArgumentList "`"$scriptPath`"" -Verb RunAs
'@
Set-Content -Path $launcherPath -Value $launcherScript -Force
Write-Host "Created launcher script: launch_english.ps1"

# Create desktop shortcut
$WshShell = New-Object -ComObject WScript.Shell
$shortcut = $WshShell.CreateShortcut($shortcutPath)
$shortcut.TargetPath = "powershell.exe"
$shortcut.Arguments = "-ExecutionPolicy Bypass -File `"$launcherPath`""
$shortcut.WorkingDirectory = $customPath
$shortcut.WindowStyle = 7
$shortcut.Description = "Launch english.ahk elevated"
if (Test-Path $iconPath) {
    $shortcut.IconLocation = $iconPath
}
$shortcut.Save()
Write-Host "Shortcut created: $shortcutPath"

# Register scheduled task
$taskName = "ElevatedAHK"
$action = New-ScheduledTaskAction -Execute "powershell.exe" -Argument "-ExecutionPolicy Bypass -File `"$launcherPath`""
$trigger = New-ScheduledTaskTrigger -AtLogOn
$principal = New-ScheduledTaskPrincipal -UserId "$env:USERNAME" -LogonType Interactive -RunLevel Highest

Register-ScheduledTask -TaskName $taskName -Action $action -Trigger $trigger -Principal $principal -Force
Write-Host "Scheduled task '$taskName' registered to run at logon"

# Add C:\custom to system PATH
$envPath = [Environment]::GetEnvironmentVariable("Path", "Machine")
if (-not ($envPath -split ";" | Where-Object { $_ -eq $customPath })) {
    [Environment]::SetEnvironmentVariable("Path", "$envPath;$customPath", "Machine")
    Write-Host "Added $customPath to system PATH"
} else {
    Write-Host "$customPath already in system PATH"
}

# Create english.cmd and persian.cmd
$cmdTemplate = @'
@echo off
powershell -WindowStyle Hidden -ExecutionPolicy Bypass -Command "Start-Process -FilePath 'C:\Program Files\AutoHotkey\AutoHotkey.exe' -ArgumentList '\"C:\custom\{0}.ahk\"' -Verb RunAs"
'@

Set-Content -Path "$customPath\english.cmd" -Value ($cmdTemplate -f "english") -Force
Set-Content -Path "$customPath\persian.cmd" -Value ($cmdTemplate -f "persian") -Force
Write-Host "Created english.cmd and persian.cmd for global use"
