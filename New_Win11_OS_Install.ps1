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

# Update OSD with latest content

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
# Start OSDCloud ZTI the RIGHT way
Write-Host -ForegroundColor Yellow -BackgroundColor REd "Starting OSDCloud... This will completely erase the local hard drive. Press control C to cancel..."
Write-Host -ForegroundColor Yellow -BackgroundColor REd ""
Start-Sleep -Seconds 10
Write-Host -ForegroundColor Yellow -BackgroundColor REd "Installing Windows 10 22H2 Enterprise"
Start-Sleep -Seconds 5
#Start-OSDCloud -OSLanguage en-us -OSBuild 22H2 -OSEdition Enterprise -OSLicense Volume -ZTI -OSVersion 'Windows 11' -Manufacturer None -Product None
Write-Host  ""
# Add support for message boxes
    Add-Type -AssemblyName PresentationCore,PresentationFramework
# Display message about shutdown and removing flash drive

[void][System.Windows.MessageBox]::Show('                             !!! ATTENTION - PLEASE READ !!!
Before disconnecting the USB drive, shutdown the computer by typing
                                      WPEUTIL SHUTDOWN
in the command prompt window after clicking OK.')
Start-Sleep -Seconds 1
start-process -FilePath "$env:comspec" -Argumentlist "/k color e4 & echo type: 'wpeutil shutdown' without quotes, to shutdown this computer."
