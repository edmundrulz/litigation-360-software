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
    param([string]$Action,[string]$Status,[string]$Detail)
    $audit = Join-Path $PmoRoot "09_AUDIT_LOGS\AUDIT_TRAIL.csv"
    $row = [PSCustomObject]@{
        Timestamp=(Get-Date -Format "yyyy-MM-dd HH:mm:ss")
        Action=$Action
        Status=$Status
        Detail=$Detail
        Script="04-HEALTH-CHECK.ps1"
        User=$env:USERNAME
    }
    $row | Export-Csv -Path $audit -NoTypeInformation -Append
}

$stamp = Get-Date -Format "yyyyMMdd-HHmmss"
$report = Join-Path $PmoRoot "13_HEALTH_CHECKS\HEALTH-CHECK-$stamp.md"

$requiredFolders = @(
    "00_DASHBOARD","01_DATABASE","02_REPORTS","03_SOPS","04_CHECKLISTS",
    "05_APPROVALS","06_CHANGE_LOG","07_RISKS_BLOCKERS","08_KPI_METRICS",
    "09_AUDIT_LOGS","10_CONFIG","11_ROLLBACK","12_REMINDERS","13_HEALTH_CHECKS",
    "14_TEMPLATES","15_ARCHIVE","scripts"
)

$requiredFiles = @(
    "01_DATABASE\TASKS.csv",
    "01_DATABASE\MILESTONES.csv",
    "01_DATABASE\RISKS_BLOCKERS.csv",
    "01_DATABASE\APPROVALS.csv",
    "01_DATABASE\CHANGE_LOG.csv",
    "01_DATABASE\KPI_METRICS.csv",
    "09_AUDIT_LOGS\AUDIT_TRAIL.csv",
    "10_CONFIG\PMO-CONFIG.json",
    "03_SOPS\SOP-PMO-TRACKING.md",
    "03_SOPS\SOP-VERIFICATION-VALIDATION.md",
    "03_SOPS\SOP-TESTING-PROCEDURE.md",
    "04_CHECKLISTS\MASTER-COMPLIANCE-CHECKLIST.md",
    "05_APPROVALS\SIGNOFF-AND-APPROVAL-WORKFLOW.md"
)

$folderResults = foreach ($folder in $requiredFolders) {
    $path = Join-Path $PmoRoot $folder
    [PSCustomObject]@{
        Item=$folder
        Type="Folder"
        Status= if (Test-Path $path) { "PASS" } else { "FAIL" }
        Path=$path
    }
}

$fileResults = foreach ($file in $requiredFiles) {
    $path = Join-Path $PmoRoot $file
    [PSCustomObject]@{
        Item=$file
        Type="File"
        Status= if (Test-Path $path) { "PASS" } else { "FAIL" }
        Path=$path
    }
}

$all = @($folderResults) + @($fileResults)
$failures = @($all | Where-Object { $_.Status -eq "FAIL" })

$lines = ($all | ForEach-Object {
    "- [$($_.Status)] $($_.Type): $($_.Item) | $($_.Path)"
}) -join "`r`n"

$overall = if ($failures.Count -eq 0) { "PASS" } else { "FAIL" }

$content = @"
# PMO TRACKING SYSTEM HEALTH CHECK

Generated:
$(Get-Date -Format "yyyy-MM-dd HH:mm:ss")

PMO Root:
$PmoRoot

Overall Status:
$overall

Failures:
$($failures.Count)

---

# Results

$lines

---

# Auto-Correction Guidance

If any item is FAIL, rerun:

powershell -ExecutionPolicy Bypass -File "`"$PmoRoot\scripts\01-INIT-PMO-TRACKER.ps1`""

This will recreate missing folders/files without deleting existing records.
"@

$utf8NoBom = New-Object System.Text.UTF8Encoding($false)
[System.IO.File]::WriteAllText($report, $content, $utf8NoBom)

Add-Audit -Action "Health check executed" -Status $overall -Detail $report

Write-Host "[PASS] Health check completed:" -ForegroundColor Green
Write-Host $report
Write-Host "Overall Status: $overall"