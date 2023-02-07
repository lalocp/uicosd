Write-Host  -ForegroundColor Cyan "UIC Tech. Solutions: Windows Deployment process using OSDCloud."
Start-Sleep -Seconds 5
#Change Display Resolution for Virtual Machine
if ((Get-MyComputerModel) -match 'Virtual') {
    Write-Host  -ForegroundColor Cyan "Setting Display Resolution to 1600x"
    Set-DisRes 1600
}

#Make sure I have the latest OSD Content
Write-Host  -ForegroundColor Cyan "Updating the awesome OSD PowerShell Module"
Install-Module OSD -Force

Write-Host  -ForegroundColor Cyan "Importing the sweet OSD PowerShell Module"
Import-Module OSD -Force
 
#Start OSDCloud ZTI the RIGHT way
Write-Host  -ForegroundColor Cyan "Starting OSDCloud GUI"
Write-Host  -ForegroundColor Cyan "Choose your preferred version of Windows Enterprise"
Write-Host  -ForegroundColor Cyan "Very Important, to decrease the potential for a Blue Screen of Death crash"
Write-Host  -ForegroundColor Cyan "Choose Microsoft Update Catalog for the DriverPack"

Start-Sleep -Seconds 120
Start-OSDCloudGUI

write-host   -ForegroundColor cyan "Before pulling out the USB drive, shutdown the computer with this command"
write-host   -ForegroundColor cyan "wpeutil shutdown in a command prompt"
Start-Sleep  -Seconds 60
