# 1. Define Download & Temp Locations (WinPE uses X: as RAM disk)
$VirtioZipUrl = "https://fedorapeople.org"
$TempPath = "X:\VirtioSetup"
$ExtractPath = "$TempPath\Extracted"

# 2. Identify the Windows Partition Dynamically
# We look for the drive containing \Windows\System32 since drive letters shift in WinPE.
$OSDiskLetter = Get-PSDrive -PSProvider FileSystem | ForEach-Object {
    $Root = $_.Root
    if (Test-Path "$($Root)Windows\System32") { $Root.TrimEnd('\') }
} | Select-Object -First 1

if ($null -eq $OSDiskLetter) {
    Write-Error "OS Partition not found! Ensure the Windows image was applied first."
    return
}
Write-Host "Found OS Partition on $OSDiskLetter" -ForegroundColor Cyan

# 3. Download & Extract VirtIO Drivers
if (!(Test-Path $TempPath)) { New-Item -ItemType Directory -Path $TempPath }
Write-Host "Downloading latest VirtIO drivers from FedoraPeople..." -ForegroundColor Yellow
Invoke-WebRequest -Uri $VirtioZipUrl -OutFile "$TempPath\virtio.zip"

Write-Host "Extracting drivers..." -ForegroundColor Yellow
Expand-Archive -Path "$TempPath\virtio.zip" -DestinationPath $ExtractPath -Force

# 4. Inject Drivers into Offline Image
Write-Host "Injecting drivers into $OSDiskLetter\..." -ForegroundColor Green
# Recurse through extracted folders to find all .inf files (SCSI, Net, etc.)
Get-ChildItem -Path $ExtractPath -Filter "*.inf" -Recurse | ForEach-Object {
    Write-Host "Adding: $($_.Name)"
    Add-WindowsDriver -Path "$OSDiskLetter\" -Driver $_.FullName -ForceUnsigned
}

# 5. Cleanup and Automatic Reboot
Write-Host "Cleaning up temp files..." -ForegroundColor Gray
Remove-Item $TempPath -Recurse -Force

# Write-Host "ZTI Workflow Complete. Rebooting in 10 seconds..." -ForegroundColor Cyan
#Start-Sleep -Seconds 10
#Restart-Computer -Force
