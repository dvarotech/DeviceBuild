# Variables
$TempDir = "C:\Temp"
$WebClient = New-Object System.Net.WebClient
$URL = 'https://go.microsoft.com/fwlink/?LinkID=799445 '
$File = "$($TempDir)\Windows10Upgrade9252.exe"

# Process
If(!(Test-Path -Path $TempDir)) { New-Item -ItemType Directory -Path $TempDir }
$WebClient.DownloadFile($URL,$File)
Start-Process -FilePath $File -ArgumentList '/quietinstall /skipeula /auto upgrade /copylogs $TempDir'
