net session >nul 2>&1
if %errorlevel% == 0 (
    echo You are running CMD as Administrator.
) else (
    echo CMD is NOT running with elevated privileges.
)