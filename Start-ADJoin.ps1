###################################################################
#     Powershell Device AD Join
#
#     This script will Bind this device to AD
#
#     02/14/2024 HVD. Initial script v. .01
###################################################################

# Add a local admin account
net user lansoft /add 
net localgroup administrators lansoft /add

# Remove Autologon
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" -Name "AutoAdminLogon" -Value 0 -Force | out-null
Clear-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" -Name "DefaultUserName" -Force | out-null

# Install pswindowsupdate to update windows
Install-Module -Name PSWindowsUpdate -Force
Import-Module PSWindowsUpdate -Force
Get-WindowsUpdate -Severity Important -Install -Download -IgnoreReboot

# Get Credentials of user with bind permissions
Write-Host "Please enter the username and password when prompted"
$creds = get-credential

# Execute Join operation
$computerName = (Get-ComputerInfo).csCaption
$domainName = "ad.uic.edu"
Write-Host "Computer $($computerName) will be joined to $domainName"
Sleep 1
Add-Computer -DomainName $domainName -Credential $creds -Force

# Remove defaultuser0
net user defaultuser0 /delete
Write-Host "Restarting computer in 5 seconds"
sleep 5
Restart-Computer -force
