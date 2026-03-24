$mouse = Get-WmiObject Win32_PnPEntity | Where-Object { $_.Service -eq 'mouhid' -or $_.Name -like "*mouse*" }
$mouse.Disable()
Start-Sleep -s 2
$mouse.Enable()
$m = Get-WmiObject Win32_PnPEntity | Where-Object { $_.Service -eq "i8042prt" -or $_.Service -eq "mouclass" }
if ($m) { $m | ForEach-Object { $_.Disable(); Start-Sleep 1; $_.Enable() } }
