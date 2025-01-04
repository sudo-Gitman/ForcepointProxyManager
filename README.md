# Forcepoint Proxy Management and Endpoint Deployment Script

This repository contains a PowerShell script for managing proxy settings, uninstalling existing Forcepoint One Endpoint software, and installing a new version of the endpoint. The script automates key steps, including registry updates, multi-password uninstallation attempts, and system preparation for installation.

## Features

- **Proxy Management**:
  - Resets WinHTTP proxy settings.
  - Updates AutoConfigURL in the registry with the new PAC URL.
- **Multi-Password Uninstallation**:
  - Detects installed Forcepoint DLP Endpoint software.
  - Attempts multiple admin passwords for uninstallation.
  - Logs successful password for future use.
- **System Preparation**:
  - Clears pending restart flags from the Windows Update registry.
  - Ensures system readiness before initiating the installation.
- **Installation Management**:
  - Installs Forcepoint One Endpoint software with custom arguments.
  - Verifies installation success and logs results.

## Prerequisites

- **PowerShell**: Ensure you run the script using Windows PowerShell with administrative privileges.
- **Dependencies**:
  - Correct PAC URL for proxy settings.
  - Admin passwords for Forcepoint uninstallation.
  - Access to the Forcepoint installer executable.
  - Write permissions for specified paths.

## How to Use

1. **Clone or Download** the repository to your local machine.
2. **Customize the Script**:
   - Replace `Your PAC url` with the appropriate PAC URL for your environment.
   - Update the `Passwords` array with potential admin passwords.
   - Replace `Your password` with the actual admin password for Forcepoint operations.
   - Adjust file paths as necessary.
3. **Run the Script**:
   Open a PowerShell terminal as an administrator and execute:
   ```powershell
   .\ForcepointProxyManagement.ps1
   ```
4. **Monitor Output**:
   Follow the on-screen messages to track progress and reboot if prompted.

## File Structure

- **Proxy Settings**:
  - Registry Key: `HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings`
  - PAC URL: Defined in the script.
- **Uninstallation Log**: `C:\Temp\uninstall.log`
- **Installer File**: `C:\Temp\FORCEPOINT-ONE-ENDPOINT-x64.exe`
- **Installation Log**: `C:\Users\<Username>\ForcepointInstall.log`

## Notes

- Test the script in a non-production environment before deploying to production systems.
- Ensure all required permissions and dependencies are met for smooth execution.
- Proxy settings and installation will only proceed after successful uninstallation.

## License

This project is licensed under the MIT License. See the `LICENSE` file for details.

## Author

Developed by Sreerag. For feedback or contributions, please visit https://github.com/sudo-Gitman.

---

**Disclaimer**: Use this script at your own risk. Verify its behavior in a controlled environment before deploying in production.

