$signature = @"
[DllImport("user32.dll", SetLastError = true)]
public static extern bool SendMessageTimeout(IntPtr hWnd, uint Msg, UIntPtr wParam, string lParam,
    uint fuFlags, uint uTimeout, out UIntPtr lpdwResult);
"@

Add-Type -MemberDefinition $signature -Name "Win32SendMessageTimeout" -Namespace Win32

[Win32.Win32SendMessageTimeout]::SendMessageTimeout([IntPtr]::Zero, 0x1A, [UIntPtr]::Zero, "Environment",
    0x0000, 1000, [ref]([UIntPtr]::Zero)) | Out-Null

Write-Host "Environment variables refreshed."
