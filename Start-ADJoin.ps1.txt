###################################################################
#	Powershell Device AD Join
#
#     This script will Bind this device to AD
#
#     02/14/2024 HVD. Initial script v. .01
###################################################################

# Get Credentials of user with bind permissions

Write-Host "Please enter the username and password when prompted"

Sleep 5

$creds = get-credential

# Execute Join operation

$computerName = (Get-ComputerInfo).csCaption

$domainName = "ad.uic.edu"

Write-Host "Computer $computerName will be joined to $domainName and restart"

Sleep 10

Add-Computer -DomainName $domainName -Credential $creds -Restart -Force