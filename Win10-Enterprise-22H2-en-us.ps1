Write-Host ""
Write-Host ""
Write-Host ""
Write-Host -ForegroundColor Yellow -BackgroundColor REd "EAS Tech. Solutions: Windows Deployment process using OSDCloud."
Write-Host ""
Write-Host ""
# Change Display Resolution for Virtual Machine
try {
    if ((Get-MyComputerModel) -like '*Virtual*') {
        try {
        if (Set-DisRes 1600 -Verbose:$false | out-null){
                Write-Host  -ForegroundColor Cyan "Setting Display Resolution to 1600x"
                }
        }
        catch {
             $error | out-null
             }
    }
}
catch {
      $error | out-null
}

#Make sure I have the latest OSD Content

Write-Host  -ForegroundColor Cyan "Updating the awesome OSD PowerShell Module"

try {
    if (Install-Module OSD -Force -ErrorAction SilentlyContinue -Verbose:$false | out-null) {
          Write-Host -ForegroundColor Cyan "Updating the awesome OSD PowerShell Module"
          if (Import-Module OSD -Force -ErrorAction SilentlyContinue -Verbose:$false | out-null) {
            Write-Host -ForegroundColor Cyan "Importing the sweet OSD PowerShell Module"
            }
        }
    }
catch {
        $error | out-null
    } 
#Start OSDCloud ZTI the RIGHT way

Write-Host -ForegroundColor Yellow -BackgroundColor REd "Starting OSDCloud... This will completely erase the local hard drive. Press control C to cancel..."
Write-Host -ForegroundColor Yellow -BackgroundColor REd ""
Start-Sleep -Seconds 5
Write-Host -ForegroundColor Yellow -BackgroundColor REd "Installing Windows 10 22H2 Enterprise"
Start-Sleep -Seconds 2

Start-OSDCloud GUI -Brand "UIC Technology Solutions Computer Labs"

Write-Host  -ForegroundColor Cyan " "
Write-Host  -ForegroundColor Cyan " "
Write-Host  -ForegroundColor Cyan "use 'wpeutil shutdown' and remove USB drive after power is off!"
Write-Host  -ForegroundColor Cyan " "
Write-Host  -ForegroundColor Cyan " "
Write-Host  -ForegroundColor Cyan " "
Write-Host  -ForegroundColor Cyan " "
Start-Sleep -Seconds 30
