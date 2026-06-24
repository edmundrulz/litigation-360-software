Set-StrictMode -Version 2.0
$ErrorActionPreference = "Stop"

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$PmoRoot = Split-Path -Parent $ScriptDir
$RunStamp = Get-Date -Format "yyyyMMdd-HHmmss"
$RunReport = Join-Path $PmoRoot "02_REPORTS\MASTER-RUN-ALL-$RunStamp.md"

function Add-RunLine {
    param([string]$Text)

    Add-Content -Path $RunReport -Value $Text
}

function Run-Step {
    param(
        [string]$Name,
        [string]$ScriptName
    )

    $scriptPath = Join-Path $ScriptDir $ScriptName

    Write-Host ""
    Write-Host "------------------------------------------------------------" -ForegroundColor Cyan
    Write-Host "Running: $Name" -ForegroundColor Cyan
    Write-Host "Script: $scriptPath" -ForegroundColor Cyan
    Write-Host "------------------------------------------------------------" -ForegroundColor Cyan

    Add-RunLine ""
    Add-RunLine "## $Name"
    Add-RunLine ""
    Add-RunLine "Script: $scriptPath"

    if (!(Test-Path -Path $scriptPath)) {
        Write-Host "[FAIL] Missing script: $scriptPath" -ForegroundColor Red
        Add-RunLine "Status: FAIL"
        Add-RunLine "Reason: Missing script"
        return $false
    }

    & powershell -NoProfile -ExecutionPolicy Bypass -File $scriptPath -PmoRoot $PmoRoot
    $exitCode = $LASTEXITCODE

    if ($exitCode -eq 0 -or $null -eq $exitCode) {
        Write-Host "[PASS] $Name completed" -ForegroundColor Green
        Add-RunLine "Status: PASS"
        return $true
    }
    else {
        Write-Host "[FAIL] $Name failed with exit code $exitCode" -ForegroundColor Red
        Add-RunLine "Status: FAIL"
        Add-RunLine "ExitCode: $exitCode"
        return $false
    }
}

$utf8NoBom = New-Object System.Text.UTF8Encoding($false)
[System.IO.File]::WriteAllText($RunReport, "# LITIGATION 360 LEOS`r`n# PMO MASTER RUN ALL REPORT`r`n`r`nGenerated:`r`n$(Get-Date -Format "yyyy-MM-dd HH:mm:ss")`r`n", $utf8NoBom)

Write-Host "============================================================" -ForegroundColor Cyan
Write-Host "LITIGATION 360 LEOS - PMO MASTER RUN ALL" -ForegroundColor Cyan
Write-Host "============================================================" -ForegroundColor Cyan

$results = New-Object System.Collections.Generic.List[object]

$steps = @(
    [PSCustomObject]@{ Name = "Health Check"; Script = "04-HEALTH-CHECK.ps1" },
    [PSCustomObject]@{ Name = "Performance Monitor"; Script = "05-PERFORMANCE-MONITOR.ps1" },
    [PSCustomObject]@{ Name = "Dashboard Update"; Script = "06-UPDATE-DASHBOARD.ps1" },
    [PSCustomObject]@{ Name = "Status Report"; Script = "03-GENERATE-STATUS-REPORT.ps1" },
    [PSCustomObject]@{ Name = "Reminder Check"; Script = "07-REMINDER-CHECK.ps1" }
)

foreach ($step in $steps) {
    $ok = Run-Step -Name $step.Name -ScriptName $step.Script

    $results.Add([PSCustomObject]@{
        Step = $step.Name
        Script = $step.Script
        Status = if ($ok) { "PASS" } else { "FAIL" }
    })
}

$failures = @($results | Where-Object { $_.Status -eq "FAIL" })

Add-RunLine ""
Add-RunLine "# Final Summary"
Add-RunLine ""
foreach ($result in $results) {
    Add-RunLine "- [$($result.Status)] $($result.Step) - $($result.Script)"
}

Write-Host ""
Write-Host "============================================================" -ForegroundColor Cyan

if ($failures.Count -eq 0) {
    Write-Host "PMO TRACKING SYSTEM UPDATE COMPLETE - PASS" -ForegroundColor Green
    Add-RunLine ""
    Add-RunLine "Overall Status: PASS"
}
else {
    Write-Host "PMO TRACKING SYSTEM UPDATE COMPLETE - WITH FAILURES" -ForegroundColor Red
    Add-RunLine ""
    Add-RunLine "Overall Status: FAIL"
}

Write-Host "============================================================" -ForegroundColor Cyan
Write-Host "Dashboard:"
Write-Host "$PmoRoot\00_DASHBOARD\DASHBOARD.md"
Write-Host "Reports:"
Write-Host "$PmoRoot\02_REPORTS"
Write-Host "Master Run Report:"
Write-Host $RunReport

if ($failures.Count -gt 0) {
    exit 1
}

exit 0