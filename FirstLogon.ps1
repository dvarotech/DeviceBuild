powercfg /change standby-timeout-ac 0
powercfg /change monitor-timeout-ac 0
powercfg /change hibernate-timeout-ac 0


Add-AppxPackage -RegisterByFamilyName -MainPackage Microsoft.DesktopAppInstaller_8wekyb3d8bbwe
Add-AppPackage -path "https://cdn.winget.microsoft.com/cache/source.msix."
Add-AppPackage -path "https://aka.ms/getwinget"
Install-PackageProvider -Name NuGet -Force -Scope CurrentUser
Install-Module -Name PowerShellGet -Force -AllowClobber
Install-Module -Name PSWindowsUpdate -Force -Scope CurrentUser
Import-Module PSWindowsUpdate

cls

winget install Dell.CommandUpdate.Universal --accept-source-agreements --accept-package-agreements -e
Start-Sleep -Seconds 2
cd "C:\Program Files\Dell\CommandUpdate"
.\dcu-cli.exe /scan
Start-Sleep -Seconds 180
.\dcu-cli.exe /applyUpdates
Write-Host "Dell device updates applied." -ForegroundColor Green

usoclient StartScan
usoclient StartInstall
Install-PackageProvider -Name NuGet -Force -Scope CurrentUser
Install-Module -Name PowerShellGet -Force -AllowClobber
Install-Module -Name PSWindowsUpdate -Force -Scope CurrentUser
Import-Module PSWindowsUpdate
Get-WindowsUpdate
Install-WindowsUpdate -AcceptAll
Write-Host "Windows Updates installed successfully." -ForegroundColor Green

winget install Greenshot.Greenshot --accept-source-agreements --accept-package-agreements -e
taskkill /F /IM msedge.exe
taskkill /F /IM Greenshot.exe
winget install Microsoft.Edge --accept-source-agreements --accept-package-agreements -e
winget install Google.Chrome --accept-source-agreements --accept-package-agreements -e
winget install Mozilla.Firefox --accept-source-agreements --accept-package-agreements -e
winget install Microsoft.Teams --accept-source-agreements --accept-package-agreements -e
winget install Adobe.Acrobat.Reader.64-bit --accept-source-agreements --accept-package-agreements -e
winget install 7zip.7zip --accept-source-agreements --accept-package-agreements -e
winget install WatchGuard.MobileVPNWithSSLClient --accept-source-agreements --accept-package-agreements -e
winget install VideoLAN.VLC --accept-source-agreements --accept-package-agreements -e
winget install Microsoft.OneDrive --accept-source-agreements --accept-package-agreements -e
winget install Microsoft.Office --accept-source-agreements --accept-package-agreements -e

powercfg /change standby-timeout-ac 60
powercfg /change monitor-timeout-ac 60
powercfg /change hibernate-timeout-ac 60


Start-Process "sysdm.cpl"

Add-Type -AssemblyName System.Windows.Forms
[System.Windows.Forms.MessageBox]::Show("The installation has been successfully completed. Please join the computer to the Domain and log in the user to finalise the setup.", "Installation Complete", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Information)

