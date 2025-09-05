@echo off
:: Check for elevation
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo Requesting administrative privileges...
    powershell -Command "Start-Process '%~f0' -Verb RunAs"
    exit /b
)

:: Run the PowerShell script
powershell -ExecutionPolicy Bypass -File "%SystemRoot%\System32\refresh_system_env.ps1"
