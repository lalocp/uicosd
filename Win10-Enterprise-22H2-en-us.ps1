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

# Make sure I have the latest OSD Content

Write-Host -ForegroundColor Cyan "Updating the awesome OSD PowerShell Module"

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

Write-Host  -ForegroundColor Cyan "Starting OSDCloud GUI"
Write-Host  -ForegroundColor Cyan "Choose your preferred version of Windows Enterprise"
Write-Host  -ForegroundColor Cyan "Very Important, to decrease the potential for a Blue Screen of Death crash"
Write-Host  -ForegroundColor Cyan "Choose Microsoft Update Catalog for the DriverPack"

Start-OSDCloudGUI -Brand "UIC Technology Solutions Computer Labs"
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

Start-Sleep -Seconds 30
