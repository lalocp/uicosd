# Invoke-Expression (Invoke-RestMethod 'https://raw.githubusercontent.com/lalocp/uicosd/refs/heads/main/Install-VirtIO.ps1')#
# Invoke-Expression (Invoke-RestMethod 'https://raw.githubusercontent.com/lalocp/uicosd/refs/heads/main/get-virtiso.ps1')
# $GithubZipUrl = "https://github.com/lalocp/uicosd/raw/refs/heads/main/virtiobasic.zip"

# 1. Disable the blue progress bar for faster downloads
$ProgressPreference = 'SilentlyContinue'

# 2. Identify the Windows Partition Dynamically
$OSDiskLetter = Get-PSDrive -PSProvider FileSystem | ForEach-Object {
    $Root = $_.Root
    if (Test-Path "$($Root)Windows\System32") { $Root.TrimEnd('\') }
} | Select-Object -First 1

if ($null -eq $OSDiskLetter) {
    Write-Error "OS Partition not found!"
    return
}
Write-Host "Found OS Partition on $OSDiskLetter" -ForegroundColor Cyan

# 3. Define Download & Temp Locations on the OS drive
$GithubZipUrl = "https://github.com/lalocp/uicosd/raw/refs/heads/main/virtiobasic.zip"
$TempPath = "$OSDiskLetter\VirtioSetup"
$ExtractPath = "$TempPath\Extracted"

# 4. Create Temp Directory and Download using Basic Parsing
if (!(Test-Path $TempPath)) { New-Item -ItemType Directory -Path $TempPath -Force | Out-Null }

Write-Host "Downloading drivers..." -ForegroundColor Yellow
# -UseBasicParsing prevents IE engine dependency errors
Invoke-WebRequest -Uri $GithubZipUrl -OutFile "$TempPath\min_drivers.zip" -UseBasicParsing

# 5. Extract Drivers
Write-Host "Extracting drivers..." -ForegroundColor Yellow
Expand-Archive -Path "$TempPath\min_drivers.zip" -DestinationPath $ExtractPath -Force

# 6. Inject Drivers (Filtered for macOS metadata)
Write-Host "Injecting drivers into $OSDiskLetter\..." -ForegroundColor Green

# We skip "__MACOSX" folders and "._" files created by macOS
Get-ChildItem -Path $ExtractPath -Filter "*.inf" -Recurse | 
    Where-Object { $_.FullName -notmatch "__MACOSX" -and $_.Name -notlike "._*" } | 
    ForEach-Object {
        Write-Host "Adding: $($_.Name)" -ForegroundColor Gray
        # Using the specific full path to the .inf file
        Add-WindowsDriver -Path "$OSDiskLetter\" -Driver $_.FullName -ForceUnsigned
    }

# 7. Cleanup and Reboot
Write-Host "Cleaning up $TempPath..." -ForegroundColor Gray
Remove-Item $TempPath -Recurse -Force

#Write-Host "ZTI Workflow Complete. Rebooting in 10 seconds..." -ForegroundColor Cyan
#Start-Sleep -Seconds 10
#Restart-Computer -Force
