
# 1. Identify the Windows Partition
$OSDiskLetter = Get-PSDrive -PSProvider FileSystem | ForEach-Object {
    $Root = $_.Root
    if (Test-Path "$($Root)Windows\System32") { $Root.TrimEnd('\') }
} | Select-Object -First 1

# 2. Define your GitHub Minimal Driver Source
# Replace with your actual GitHub Raw URL
$GithubZipUrl = "https://github.com/lalocp/uicosd/raw/refs/heads/main/virtiobasic.zip"
$TempPath = "$OSDiskLetter\VirtioSetup"

# 3. Download and Inject
if (!(Test-Path $TempPath)) { New-Item -ItemType Directory -Path $TempPath -Force }

Invoke-WebRequest -Uri $GithubZipUrl -OutFile "$TempPath\min_drivers.zip"
Expand-Archive -Path "$TempPath\min_drivers.zip" -DestinationPath "$TempPath\Extracted" -Force

Write-Host "Injecting Boot Drivers..." -ForegroundColor Green
# Pointing to the extracted folder; -Recurse handles the subdirectories
Add-WindowsDriver -Path "$OSDiskLetter\" -Driver "$TempPath\Extracted" -Recurse -ForceUnsigned

# 4. Cleanup
#Remove-Item $TempPath -Recurse -Force
