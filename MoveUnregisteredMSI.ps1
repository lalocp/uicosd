# 1. Initialize Windows Installer COM Object
$com = New-Object -ComObject WindowsInstaller.Installer
$reg = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::OrdinalIgnoreCase)

foreach ($p in$com.Products) {
    try {
        $pkg = $com.ProductInfo($p, "LocalPackage")
        if ($pkg) { [void]$reg.Add($pkg) }
    } catch {}
}

# 2. Collect Orphaned Files & Extract Product Names
$files = Get-ChildItem "C:\Windows\Installer" -Include *.msi, *.msp -Recurse -Force -ErrorAction SilentlyContinue
$orphans = [System.Collections.Generic.List[PSCustomObject]]::new()$bytes = 0

foreach ($f in$files) {
    if (-not $reg.Contains($f.FullName)) {$pName = "Unknown / Unreadable"
        if ($f.Extension -eq ".msi") {
            try {
                $db = $com.OpenDatabase($f.FullName, 0)
                $view =$db.OpenView("SELECT `Value` FROM `Property` WHERE `Property`='ProductName'")
                $view.Execute()
                $rec =$view.Fetch()
                if ($rec) { $pName =$rec.StringData(1) }
            } catch {}
            finally {
                if ($rec)  { [System.Runtime.InteropServices.Marshal]::ReleaseComObject($rec) | Out-Null }
                if ($view) { [System.Runtime.InteropServices.Marshal]::ReleaseComObject($view) | Out-Null }
                if ($db)   { [System.Runtime.InteropServices.Marshal]::ReleaseComObject($db) | Out-Null }
            }
        } else {
            $pName = "Patch File (.msp)"
        }

        $bytes +=$f.Length
        $orphans.Add([PSCustomObject]@{
            FullName    = $f.FullName
            FileName    = $f.Name
            SizeMB      = [math]::Round($f.Length / 1MB, 2)
            ProductName = $pName
        })
    }
}

[System.Runtime.InteropServices.Marshal]::ReleaseComObject($com) | Out-Null

# 3. Display Top Offenders Summary & Prompt
if ($orphans.Count -eq 0) {
    Write-Host "`nNo orphaned installer files found!" -ForegroundColor Green
} else {
    Write-Host "`n================ TOP ORPHANED OFFENDERS ================" -ForegroundColor Yellow
    $orphans | Group-Object ProductName | ForEach-Object {
        [PSCustomObject]@{
            "Product Name"    = $_.Name
            "Count"           = $_.Count
            "Total Size (GB)" = [math]::Round(($_.Group | Measure-Object SizeMB -Sum).Sum / 1024, 2)
        }
    } | Sort-Object "Total Size (GB)" -Descending | Format-Table -AutoSize

    $totalGB = [math]::Round($bytes / 1GB, 2)
    Write-Host "================ SUMMARY ================" -ForegroundColor Cyan
    Write-Host "Total Orphaned Files Found : $($orphans.Count)"
    Write-Host "Total Reclaimable Space    : $totalGB GB" -ForegroundColor Green
    Write-Host "=========================================`n"

    $confirm = Read-Host "Do you want to PERMANENTLY DELETE these orphaned files to reclaim $totalGB GB? (Y/N)"
    if ($confirm -eq 'Y' -or $confirm -eq 'y') {
        Write-Host "`nStopping msiexec tasks..." -ForegroundColor Yellow
        Get-Process -Name "msiexec" -ErrorAction SilentlyContinue | Stop-Process -Force -ErrorAction SilentlyContinue

        Write-Host "Deleting orphaned files..." -ForegroundColor Cyan
        $deleted = 0
        foreach ($o in$orphans) {
            try {
                Remove-Item -Path $o.FullName -Force -ErrorAction Stop$deleted++
            } catch {}
        }
        Write-Host "`nDone! Successfully removed $deleted files." -ForegroundColor Green
    } else {
        Write-Host "`nOperation cancelled. No files were deleted." -ForegroundColor Yellow
    }
}
