Get-PnpDevice -ClassName Mouse | ForEach-Object {
    Disable-PnpDevice -InstanceId $_.InstanceId -Confirm:$false
    Enable-PnpDevice -InstanceId $_.InstanceId -Confirm:$false
}
