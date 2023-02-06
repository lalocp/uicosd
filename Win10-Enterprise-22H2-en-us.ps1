Write-Host  -ForegroundColor Cyan "UIC Tech. Solutions OS Deployment using OSDCloud."
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
Write-Host  -ForegroundColor Cyan "Start OSDCloud with custom parameters"
Write-Host  -ForegroundColor Cyan "OS: Windows 10 Enterprise 22H2"

Start-OSDCloud -OSLanguage en-us -OSBuild 22H2 -OSEdition Enterprise -OSLicense Volume -ZTI -OSVersion 'Windows 10'

#Restart from WinPE
#Write-Host -ForegroundColor Cyan "Restarting in 20 seconds!"
Write-host  -ForegroundColor Cyan "Use this link to download the Lenovo M920q driver pack"
write-host  -ForegroundColor Cyan "https://download.lenovo.com/pccbbs/thinkcentre_drivers/tc_m720tsq-m920tsxq-p330tiny_w1064_2004_202007.exe"
Write-Host  -ForegroundColor Cyan "use 'wpeutil shutdown' and remove USB drive after power is off!"
Start-Sleep -Seconds 60
#wpeutil reboot
