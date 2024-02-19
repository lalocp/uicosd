###################################################################
#     Powershell Device Rename
#
#     This script will disable some prompts for OOBE, including
#     setting the DataCollection "AllowTelemetry" property to 0
#     in the registry.
#
#     02/14/2024 HVD. Initial script v. .01
###################################################################

# Disable Privacy
WRITE-HOST "Disabling Privacy Consent..."
New-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\OOBE" -Name "PrivacyConsentStatus" -PropertyType DWORD -Value 1 -Force | out-null

# Disable OOBE
WRITE-HOST "Disabling OOBE..."
New-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\OOBE" -Name "SkipMachineOOBE" -PropertyType DWORD -Value 1 -Force | out-null
New-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\OOBE" -Name "LaunchUserOOBE" -PropertyType DWORD -Value 0 -Force | out-null

# Disable Telemetry
WRITE-HOST "Disabling Telemetry..."
New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection" -Name "AllowTelemetry" -PropertyType DWORD -Value 0 -Force| out-null

# Rename Computer
$newname = Read-Host "Please enter the new name of the computer"

sleep 2
WRITE-HOST "The computer will be renamed to $($newname) and restart in 5 seconds."
WRITE-HOST "On reboot, the computer may automatically login as defaultuser0 with admin privileges."
WRITE-HOST "Press control C to cancel"

Sleep 8

Rename-Computer -NewName $newname -Force -Restart
