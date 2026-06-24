param(
    [string]$PmoRoot = ""
)

Set-StrictMode -Version 2.0
$ErrorActionPreference = "Stop"

if ([string]::IsNullOrWhiteSpace($PmoRoot)) {
    $ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
    $PmoRoot = Split-Path -Parent $ScriptDir
}

function Add-Audit {
    param(
        [string]$Action,
        [string]$Status,
        [string]$Detail
    )

    $audit = Join-Path $PmoRoot "09_AUDIT_LOGS\AUDIT_TRAIL.csv"

    if (!(Test-Path -Path (Split-Path $audit -Parent))) {
        New-Item -ItemType Directory -Path (Split-Path $audit -Parent) -Force | Out-Null
    }

    $row = [PSCustomObject]@{
        Timestamp = (Get-Date -Format "yyyy-MM-dd HH:mm:ss")
        Action    = $Action
        Status    = $Status
        Detail    = $Detail
        Script    = "05-PERFORMANCE-MONITOR.ps1"
        User      = $env:USERNAME
    }

    if (Test-Path -Path $audit) {
        $row | Export-Csv -Path $audit -NoTypeInformation -Append
    }
    else {
        $row | Export-Csv -Path $audit -NoTypeInformation
    }
}

try {
    if (!(Test-Path -Path $PmoRoot)) {
        throw "PMO root not found: $PmoRoot"
    }

    $stamp = Get-Date -Format "yyyyMMdd-HHmmss"
    $healthFolder = Join-Path $PmoRoot "13_HEALTH_CHECKS"

    if (!(Test-Path -Path $healthFolder)) {
        New-Item -ItemType Directory -Path $healthFolder -Force | Out-Null
    }

    $csvPath = Join-Path $healthFolder "PERFORMANCE-MONITOR-$stamp.csv"
    $mdPath  = Join-Path $healthFolder "PERFORMANCE-MONITOR-$stamp.md"

    $rows = New-Object System.Collections.Generic.List[object]

    # ------------------------------------------------------------
    # DRIVE METRICS
    # ------------------------------------------------------------

    try {
        $drives = Get-PSDrive -PSProvider FileSystem

        foreach ($drive in $drives) {
            $usedGB = if ($null -ne $drive.Used) { [math]::Round(($drive.Used / 1GB), 2) } else { 0 }
            $freeGB = if ($null -ne $drive.Free) { [math]::Round(($drive.Free / 1GB), 2) } else { 0 }

            $rows.Add([PSCustomObject]@{
                Timestamp = (Get-Date -Format "yyyy-MM-dd HH:mm:ss")
                Type      = "Drive"
                Name      = $drive.Name
                Metric1   = "UsedGB"
                Value1    = $usedGB
                Metric2   = "FreeGB"
                Value2    = $freeGB
                Status    = "PASS"
                Notes     = "Drive metric collected"
            })
        }
    }
    catch {
        $rows.Add([PSCustomObject]@{
            Timestamp = (Get-Date -Format "yyyy-MM-dd HH:mm:ss")
            Type      = "Drive"
            Name      = "DriveMetricCollection"
            Metric1   = "Error"
            Value1    = ""
            Metric2   = ""
            Value2    = ""
            Status    = "WARN"
            Notes     = $_.Exception.Message
        })
    }

    # ------------------------------------------------------------
    # PROCESS METRICS
    # Safe replacement for Sort-Object CPU.
    # Some Windows processes return CPU data in a way that can break
    # direct CPU sorting. This calculates CPUSeconds safely.
    # ------------------------------------------------------------

    try {
        $safeProcesses = New-Object System.Collections.Generic.List[object]

        foreach ($process in (Get-Process)) {
            $cpuSeconds = 0
            $workingSetMB = 0

            try {
                if ($null -ne $process.TotalProcessorTime) {
                    $cpuSeconds = [math]::Round($process.TotalProcessorTime.TotalSeconds, 2)
                }
            }
            catch {
                $cpuSeconds = 0
            }

            try {
                if ($null -ne $process.WorkingSet64) {
                    $workingSetMB = [math]::Round(($process.WorkingSet64 / 1MB), 2)
                }
            }
            catch {
                $workingSetMB = 0
            }

            $safeProcesses.Add([PSCustomObject]@{
                ProcessName  = $process.ProcessName
                Id           = $process.Id
                CPUSeconds   = $cpuSeconds
                WorkingSetMB = $workingSetMB
            })
        }

        $topProcesses = $safeProcesses |
            Sort-Object -Property CPUSeconds -Descending |
            Select-Object -First 10

        foreach ($process in $topProcesses) {
            $rows.Add([PSCustomObject]@{
                Timestamp = (Get-Date -Format "yyyy-MM-dd HH:mm:ss")
                Type      = "Process"
                Name      = "$($process.ProcessName) [$($process.Id)]"
                Metric1   = "CPUSeconds"
                Value1    = $process.CPUSeconds
                Metric2   = "WorkingSetMB"
                Value2    = $process.WorkingSetMB
                Status    = "PASS"
                Notes     = "Top process metric collected safely"
            })
        }
    }
    catch {
        $rows.Add([PSCustomObject]@{
            Timestamp = (Get-Date -Format "yyyy-MM-dd HH:mm:ss")
            Type      = "Process"
            Name      = "ProcessMetricCollection"
            Metric1   = "Error"
            Value1    = ""
            Metric2   = ""
            Value2    = ""
            Status    = "WARN"
            Notes     = $_.Exception.Message
        })
    }

    # ------------------------------------------------------------
    # EXPORT RESULTS
    # ------------------------------------------------------------

    if ($rows.Count -eq 0) {
        $rows.Add([PSCustomObject]@{
            Timestamp = (Get-Date -Format "yyyy-MM-dd HH:mm:ss")
            Type      = "System"
            Name      = "PerformanceMonitor"
            Metric1   = "Result"
            Value1    = "No metrics collected"
            Metric2   = ""
            Value2    = ""
            Status    = "WARN"
            Notes     = "No rows generated"
        })
    }

    $rows | Export-Csv -Path $csvPath -NoTypeInformation

    $warnCount = @($rows | Where-Object { $_.Status -eq "WARN" }).Count
    $passCount = @($rows | Where-Object { $_.Status -eq "PASS" }).Count
    $overallStatus = if ($passCount -gt 0) { "PASS" } else { "WARN" }

    $summaryLines = ($rows | Select-Object -First 25 | ForEach-Object {
        "- [$($_.Status)] $($_.Type): $($_.Name) | $($_.Metric1): $($_.Value1) | $($_.Metric2): $($_.Value2) | $($_.Notes)"
    }) -join "`r`n"

    $content = @"
# LITIGATION 360 LEOS
# PERFORMANCE MONITOR REPORT

Generated:
$(Get-Date -Format "yyyy-MM-dd HH:mm:ss")

PMO Root:
$PmoRoot

Overall Status:
$overallStatus

PASS Rows:
$passCount

WARN Rows:
$warnCount

CSV Output:
$csvPath

---

# Summary

$summaryLines

---

# Notes

This report uses safe CPUSeconds calculation instead of direct Sort-Object CPU.

This avoids the previous Windows process CPU sorting error.
"@

    $utf8NoBom = New-Object System.Text.UTF8Encoding($false)
    [System.IO.File]::WriteAllText($mdPath, $content, $utf8NoBom)

    Add-Audit -Action "Performance monitor executed" -Status $overallStatus -Detail $csvPath

    Write-Host "[PASS] Performance monitor report created:" -ForegroundColor Green
    Write-Host $csvPath
    Write-Host $mdPath

    exit 0
}
catch {
    $failureFolder = Join-Path $PmoRoot "13_HEALTH_CHECKS"
    if (!(Test-Path -Path $failureFolder)) {
        New-Item -ItemType Directory -Path $failureFolder -Force | Out-Null
    }

    $failurePath = Join-Path $failureFolder ("PERFORMANCE-MONITOR-FAIL-" + (Get-Date -Format "yyyyMMdd-HHmmss") + ".md")

    $content = @"
# PERFORMANCE MONITOR FAILURE

Generated:
$(Get-Date -Format "yyyy-MM-dd HH:mm:ss")

Status:
FAIL

Error:
$($_.Exception.Message)

Script:
05-PERFORMANCE-MONITOR.ps1
"@

    $utf8NoBom = New-Object System.Text.UTF8Encoding($false)
    [System.IO.File]::WriteAllText($failurePath, $content, $utf8NoBom)

    Add-Audit -Action "Performance monitor failed" -Status "FAIL" -Detail $failurePath

    Write-Host "[FAIL] Performance monitor failed:" -ForegroundColor Red
    Write-Host $failurePath
    Write-Host $_.Exception.Message -ForegroundColor Red

    exit 1
}