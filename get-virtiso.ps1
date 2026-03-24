# Invoke-Expression (Invoke-RestMethod 'https://raw.githubusercontent.com/lalocp/uicosd/refs/heads/main/get-virtiso.ps1')

# 1. Identify the Windows Partition Dynamically
$OSDiskLetter = Get-PSDrive -PSProvider FileSystem | ForEach-Object {
    $Root = $_.Root
    if (Test-Path "$($Root)Windows\System32") { $Root.TrimEnd('\') }
} | Select-Object -First 1

if ($null -eq $OSDiskLetter) {
    Write-Error "OS Partition not found!"
    return
}
Write-Host "Found OS Partition on $OSDiskLetter" -ForegroundColor Cyan

# 2. Define Direct ISO URL & Temp Location on the OS drive
# Version 0.1.285 is the latest stable version as of early 2026.
$VirtioIsoUrl = "https://github.com/lalocp/uicosd/raw/refs/heads/main/virtiobasic.zip"
$TempPath = "$OSDiskLetter\VirtioSetup"
$IsoPath = "$TempPath\virtio.iso"

# 3. Create Temp Directory and Download
if (!(Test-Path $TempPath)) { New-Item -ItemType Directory -Path $TempPath -Force | Out-Null }
Write-Host "Downloading ISO to $TempPath..." -ForegroundColor Yellow
Invoke-WebRequest -Uri $VirtioIsoUrl -OutFile $IsoPath

# 4. Mount ISO and Inject Drivers
Write-Host "Mounting ISO..." -ForegroundColor Yellow
$Mount = Mount-DiskImage -ImagePath $IsoPath -PassThru
$DriveLetter = ($Mount | Get-Volume).DriveLetter

Write-Host "Injecting drivers from $DriveLetter\..." -ForegroundColor Green
# This scans the mounted ISO for all .inf files and adds them to the offline image
Add-WindowsDriver -Path "$OSDiskLetter\" -Driver "$($DriveLetter):\" -Recurse -ForceUnsigned

# 5. Cleanup
Write-Host "Cleaning up..." -ForegroundColor Gray
Dismount-DiskImage -ImagePath $IsoPath
Remove-Item $TempPath -Recurse -Force

#Write-Host "Done. Rebooting in 10 seconds..." -ForegroundColor Cyan
#Start-Sleep -Seconds 10
#Restart-Computer -Force
