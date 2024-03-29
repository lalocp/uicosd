Write-Host  -ForegroundColor Cyan "UIC Tech. Solutions: Windows Deployment process using OSDCloud."
Start-Sleep -Seconds 2
#Change Display Resolution for Virtual Machine

try {
    if ((Get-MyComputerModel) -match 'Virtual') {
        Write-Host  -ForegroundColor Cyan "Setting Display Resolution to 1600x"
        Set-DisRes 1600
    }
}
catch {
      $error | out-null
}

#Make sure I have the latest OSD Content
Write-Host  -ForegroundColor Cyan "Updating the awesome OSD PowerShell Module"
try {
    if (Install-Module OSD -Force -ErrorAction SilentlyContinue -Verbose:$false | out-null) {
        Write-Host  -ForegroundColor Cyan "Importing the sweet OSD PowerShell Module"
        Import-Module OSD -Force -ErrorAction SilentlyContinue -Verbose:$false |out-null
        }
    }
catch {
        $error | out-null
    }
#Start OSDCloud ZTI the RIGHT way
Write-Host  -ForegroundColor Cyan "Starting OSDCloud GUI"
Write-Host  -ForegroundColor Cyan "If you see an Autopilot json file selected, unselect it."
Write-Host  -ForegroundColor Cyan "Choose your preferred version of Windows Enterprise"
Write-Host  -ForegroundColor Cyan "Very Important, to decrease the potential for a Blue Screen of Death crash"
Write-Host  -ForegroundColor Cyan "Choose Microsoft Update Catalog for the DriverPack"

Start-Sleep -Seconds 15
Start-OSDCloudGUI

write-host   -ForegroundColor cyan "Before pulling out the USB drive, shutdown the computer with this command"
write-host   -ForegroundColor cyan "wpeutil shutdown in a command prompt"
Start-Sleep  -Seconds 5
