###################################################################
#	Powershell Device AD Join
#
#     This script will Bind this device to AD
#
#     02/14/2024 HVD. Initial script v. .01
###################################################################

# Add a local admin account
net user lansoft /add
net localgroup administrators lansoft /add

# Get Credentials of user with bind permissions
Write-Host "Please enter the username and password when prompted"
Sleep 5

$creds = get-credential

# Execute Join operation
$computerName = (Get-ComputerInfo).csCaption
$domainName = "ad.uic.edu"
Write-Host "Computer $computerName will be joined to $domainName"
Sleep 2
Add-Computer -DomainName $domainName -Credential $creds -Force

# Remove defaultuser0
net user defaultuser0 /delete
Write-Host "Restarting computer in 10 seconds"
sleep 10
Restart-Computer -force
