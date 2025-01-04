# Change directory to Forcepoint Endpoint folder
Set-Location -Path "C:\Program Files\Websense\Websense Endpoint"
.\WDEUtil.exe -stop all -password "Your password"
sleep 20
# Reset WinHTTP Proxy Settings
Write-Host "Resetting WinHTTP Proxy Settings..."
Write-Host "======================================"

# Define the new PAC URL
$newPacUrl = "Your PAC url"

# Update the registry for AutoConfigURL
$registryKey = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings"
Set-ItemProperty -Path $registryKey -Name AutoConfigURL -Value $newPacUrl
Write-Host "Proxy URL updated successfully!"

# Uninstall Forcepoint DLP Endpoint
Write-Host "Attempting to uninstall Forcepoint DLP Endpoint..."
$ProductCode = Get-ChildItem "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall" -Recurse |
    Get-ItemProperty |
    Where-Object { $_.DisplayName -like "*FORCEPOINT ONE ENDPOINT*" } |
    Select-Object -ExpandProperty PSChildName -ErrorAction SilentlyContinue

if ($ProductCode) {
    $Passwords = @("password1", "password2", "Forcepoint", "password4", "password5")
    $LogFile = "C:\Temp\uninstall.log"
    New-Item -ItemType Directory -Path (Split-Path $LogFile) -Force -ErrorAction SilentlyContinue | Out-Null

    foreach ($Password in $Passwords) {
        Write-Host "Trying password: $Password"
        $Args = "/X`"$ProductCode`" /qn /norestart /l*v `"$LogFile`" XPSWD=`"$Password`""
        $Result = Start-Process "msiexec.exe" -ArgumentList $Args -Wait -PassThru

        if ($Result.ExitCode -eq 0) {
            Write-Host "Password Found: $Password" -ForegroundColor Green
            break
        }
    }

    if ($Result.ExitCode -ne 0) {
        Write-Host "Uninstallation failed with all provided passwords." -ForegroundColor Red
    }
} else {
    Write-Host "Forcepoint DLP Endpoint not found."
}

sleep 120
# Reapply Proxy Settings
#Write-Host "Reapplying WinHTTP Proxy Settings..."
#Write-Host "======================================"
#Set-ItemProperty -Path $registryKey -Name AutoConfigURL -Value $newPacUrl
#Write-Host "Proxy URL updated successfully!"

# Install Forcepoint Agent
Write-Host "Starting Forcepoint Agent installation..."
$InstallFile = "C:\Temp\FORCEPOINT-ONE-ENDPOINT-x64.exe"
$LogFile = "$env:USERPROFILE\ForcepointInstall.log"

# Ensure the Temp directory exists
if (!(Test-Path "C:\Temp")) {
    New-Item -ItemType Directory -Path "C:\Temp" -Force | Out-Null
}

# Check if installation file exists
if (Test-Path $InstallFile) {
    # Stop Forcepoint-related processes or services
    Get-Process | Where-Object { $_.Name -like "*Forcepoint*" -or $_.Name -like "*msiexec*" } | Stop-Process -Force -ErrorAction SilentlyContinue

    # Clear pending restart flags
    Remove-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update\RebootRequired" -ErrorAction SilentlyContinue
    Remove-Item -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\PendingFileRenameOperations" -ErrorAction SilentlyContinue

    # Install agent
    $InstallArgs = '/v"/qn WSCONTEXT=<inscert your WS>"'
    $Result = Start-Process -FilePath $InstallFile -ArgumentList $InstallArgs -Wait -PassThru

    if ($Result.ExitCode -eq 0) {
        Write-Host "Installation completed successfully." -ForegroundColor Green
        Write-Host "Log file located at: $LogFile"
    } elseif ($Result.ExitCode -eq 3010) {
        Write-Host "Installation completed but requires a reboot." -ForegroundColor Yellow
    } else {
        Write-Host "Installation failed. Exit Code: $($Result.ExitCode)" -ForegroundColor Red
        Write-Host "Check the log file for details: $LogFile"
    }
} else {
    Write-Host "Installation file not found at: $InstallFile" -ForegroundColor Red
}
