$mouse = Get-WmiObject Win32_PnPEntity | Where-Object { $_.Service -eq 'mouhid' -or $_.Name -like "*mouse*" }
$mouse.Disable()
Start-Sleep -s 2
$mouse.Enable()
