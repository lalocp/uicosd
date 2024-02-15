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

New-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\OOBE" -Name "PrivacyConsentStatus" -PropertyType DWORD -Value 1 -Force

# Disable OOBE

WRITE-HOST "Disabling OOBE..."

New-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\OOBE" -Name "SkipMachineOOBE" -PropertyType DWORD -Value 1 -Force

# Disable Telemetry

WRITE-HOST "Disabling Telemetry..."

New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection" -Name "AllowTelemetry" -PropertyType DWORD -Value 0 -Force

# Rename Computer

$newname = Read-Host "Please enter the new name of the computer"

WRITE-HOST "The computer will be renamed to $newname and restart in 10 seconds."
WRITE-HOST "Press control C to cancel"

Sleep 15

Rename-Computer -NewName $newname -Force -Restart

