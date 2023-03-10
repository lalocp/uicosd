Write-Host  -ForegroundColor Cyan "UIC Tech. Solutions: Windows Deployment process using OSDCloud."
Start-Sleep -Seconds 1
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

try {
    if (Install-Module OSD -Force -ErrorAction SilentlyContinue -Verbose:$false | out-null) {
          Write-Host  -ForegroundColor Cyan "Updating the awesome OSD PowerShell Module"
          if (Import-Module OSD -Force -ErrorAction SilentlyContinue -Verbose:$false |out-null) {
            Write-Host  -ForegroundColor Cyan "Importing the sweet OSD PowerShell Module"
            }
        }
    }
catch {
        $error | out-null
    } 
#Start OSDCloud ZTI the RIGHT way
Write-Host  -ForegroundColor Cyan "Starting OSDCloud... This will completely erase the local hard drive. Press control C to cancel..."

Start-Sleep 10

Write-Host  -ForegroundColor Cyan "Installing Windows 10 22H2 Enterprise"

Start-Sleep -Seconds 5

Start-OSDCloud -OSLanguage en-us -OSBuild 22H2 -OSEdition Enterprise -OSLicense Volume -ZTI -OSVersion 'Windows 10' -Manufacturer None -Product None

write-host ""
write-host -ForegroundColor Yellow "ATTENTION - PLEASE READ"
write-host -ForegroundColor cyan "Before booting the new Windows Install, remove the USB drive after first shutting down the computer."
write-host ""
write-host -ForegroundColor cyan "Before disconnecting the USB drive, shutdown the computer using the following command in the black"
write-host -Foregroundcolor cyan -NoNewline "'command' window after this blue window closes:"
write-host -ForegroundColor RED  -NoNewlin " wpeutil shutdown"
write-host ""
Start-Sleep  -Seconds 10
