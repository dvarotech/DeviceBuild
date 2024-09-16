# Starting the script with a descriptive message
Write-Host "Starting Internal IT - Windows 11 End User Device Configuration." -ForegroundColor White

# Check if running as Administrator
If (-Not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator"))
{
    Write-Host "This script requires Administrator privileges. Please run as Administrator." -ForegroundColor Red
}
################################################################################################################
# Never Sleep and Display to Stay On (Plugged In)
Write-Host "Configuring power options to prevent sleep and display timeout when plugged in." -ForegroundColor Yellow
powercfg -change -standby-timeout-ac 0
powercfg -change -monitor-timeout-ac 0
Write-Host "Power options successfully configured." -ForegroundColor Green
################################################################################################################

# Fast Startup
Write-Host "Disabling Fast Startup for improved system performance." -ForegroundColor Yellow
$fastStartupKeyPath = "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Power"
$valueName = "HiberbootEnabled"
Set-ItemProperty -Path $fastStartupKeyPath -Name $valueName -Value 0
Write-Host "Fast Startup has been successfully disabled." -ForegroundColor Green
################################################################################################################

# Get a list of all network adapters and disable IPv6
Write-Host "Disabling IPv6 on all network adapters." -ForegroundColor Yellow
$adapters = Get-NetAdapter
foreach ($adapter in $adapters) {
   # Get the adapter's interface index
   $interfaceIndex = $adapter.InterfaceIndex
   Disable-NetAdapterBinding -Name $adapter.Name -ComponentID ms_tcpip6
}
Write-Host "IPv6 has been disabled on all network adapters." -ForegroundColor Green
################################################################################################################

# Winget configuration
Write-Host "Configuring Winget and enabling Microsoft Store for application installations." -ForegroundColor Yellow
Add-AppxPackage -RegisterByFamilyName -MainPackage Microsoft.DesktopAppInstaller_8wekyb3d8bbwe
Add-AppPackage -path "https://cdn.winget.microsoft.com/cache/source.msix."
Add-AppPackage -path "https://aka.ms/getwinget"
Write-Host "Winget has been successfully configured." -ForegroundColor Green

# List of applications to install
Write-Host "Installing applications: Edge, Chrome, and Firefox." -ForegroundColor Yellow
$apps = @(
    "Dell.CommandUpdate.Universal",
    "Microsoft.Edge",
    "Google.Chrome",
    "Mozilla.Firefox",
    "Greenshot.Greenshot",
    "Microsoft.Teams",
    "Adobe.Acrobat.Reader.64-bit",
    "7zip.7zip",
    "WatchGuard.MobileVPNWithSSLClient",
    "VideoLAN.VLC",
    "Microsoft.OneDrive",
    "Microsoft.Office"
)

# Loop through the apps and install each one
foreach ($app in $apps) {
    Write-Host "Installing $app..." -ForegroundColor Cyan
    try {
        winget install $app --accept-source-agreements --accept-package-agreements -e
        Write-Host "$app successfully installed." -ForegroundColor Green
    } catch {
        Write-Warning ("Failed to install {0}: {1}" -f $app, $_)
    }
}
Write-Host "All specified applications have been installed." -ForegroundColor Green
################################################################################################################

# Runs Dell updates

Write-Host "Initiating Dell Command Update to scan and apply updates." -ForegroundColor Yellow
& "C:\Program Files\Dell\CommandUpdate\dcu-cli.exe" /importsettings="D:\DellUpdateSettings.xml"
& "C:\Program Files\Dell\CommandUpdate\dcu-cli.exe" /importsettings="D:\DellUpdateSettings.xml"
& "C:\Program Files\Dell\CommandUpdate\dcu-cli.exe" /scan -outputLog="D:\DellUpdateLog.log"
& "C:\Program Files\Dell\CommandUpdate\dcu-cli.exe" /applyUpdates -autoSuspendBitLocker=enable 
& "C:\Program Files\Dell\CommandUpdate\dcu-cli.exe" /scan
& "C:\Program Files\Dell\CommandUpdate\dcu-cli.exe" /applyUpdates /quiet

################################################################################################################

# Check & install Windows updates.
Write-Host "Checking for and installing Windows updates." -ForegroundColor Yellow
usoclient StartScan
usoclient StartInstall
Install-PackageProvider -Name NuGet -Force -Scope CurrentUser
Install-Module -Name PowerShellGet -Force -AllowClobber
Install-Module -Name PSWindowsUpdate -Force -Scope CurrentUser
Import-Module PSWindowsUpdate
Get-WindowsUpdate
Install-WindowsUpdate -AcceptAll
Write-Host "Windows updates have been successfully installed." -ForegroundColor Green
################################################################################################################

# Open System Properties for hostname change and domain join
Write-Host "Opening System Properties for hostname change and domain join." -ForegroundColor Yellow
Start-Process "sysdm.cpl"

# Wait for System Properties window to open
Start-Sleep -Seconds 2

# Automate opening the 'Computer Name/Domain Changes' dialog box using SendKeys
Add-Type -AssemblyName System.Windows.Forms
[System.Windows.Forms.SendKeys]::SendWait("{TAB}")  # Switch to the next tab
[System.Windows.Forms.SendKeys]::SendWait("{RIGHT}")  # Navigate to the 'Computer Name' tab
Start-Sleep -Milliseconds 500  # Wait a moment
[System.Windows.Forms.SendKeys]::SendWait("{TAB}{ENTER}")  # Press 'Change...' button

# Wait for the window to fully open
Start-Sleep -Seconds 5
################################################################################################################

# To enable UAC
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Name "EnableLUA" -Value 1
################################################################################################################
# Final message indicating installation completion
Write-Host "The installation is complete. Please join the computer to the Domain and log on the user to complete setup." -ForegroundColor Green
