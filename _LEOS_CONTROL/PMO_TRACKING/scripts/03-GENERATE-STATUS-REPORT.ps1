param(
    [string]$PmoRoot = ""
)

Set-StrictMode -Version 2.0
$ErrorActionPreference = "Stop"

if ([string]::IsNullOrWhiteSpace($PmoRoot)) {
    $ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
    $PmoRoot = Split-Path -Parent $ScriptDir
}

function Import-CsvSafe {
    param([string]$Path)
    if (Test-Path $Path) {
        return Import-Csv $Path
    }
    return @()
}

function Add-Audit {
    param([string]$Action,[string]$Status,[string]$Detail)
    $audit = Join-Path $PmoRoot "09_AUDIT_LOGS\AUDIT_TRAIL.csv"
    $row = [PSCustomObject]@{
        Timestamp=(Get-Date -Format "yyyy-MM-dd HH:mm:ss")
        Action=$Action
        Status=$Status
        Detail=$Detail
        Script="03-GENERATE-STATUS-REPORT.ps1"
        User=$env:USERNAME
    }
    $row | Export-Csv -Path $audit -NoTypeInformation -Append
}

$tasks = Import-CsvSafe (Join-Path $PmoRoot "01_DATABASE\TASKS.csv")
$milestones = Import-CsvSafe (Join-Path $PmoRoot "01_DATABASE\MILESTONES.csv")
$risks = Import-CsvSafe (Join-Path $PmoRoot "01_DATABASE\RISKS_BLOCKERS.csv")
$approvals = Import-CsvSafe (Join-Path $PmoRoot "01_DATABASE\APPROVALS.csv")
$kpis = Import-CsvSafe (Join-Path $PmoRoot "01_DATABASE\KPI_METRICS.csv")

$stamp = Get-Date -Format "yyyyMMdd-HHmmss"
$reportPath = Join-Path $PmoRoot "02_REPORTS\STATUS-REPORT-$stamp.md"

$totalTasks = @($tasks).Count
$completedTasks = @($tasks | Where-Object { $_.Status -eq "COMPLETED" }).Count
$inProgressTasks = @($tasks | Where-Object { $_.Status -eq "IN_PROGRESS" }).Count
$pendingTasks = @($tasks | Where-Object { $_.Status -eq "PENDING" }).Count
$blockedTasks = @($tasks | Where-Object { $_.Status -eq "BLOCKED" }).Count
$activeRisks = @($risks | Where-Object { $_.Status -eq "ACTIVE" }).Count
$pendingApprovals = @($approvals | Where-Object { $_.Status -eq "PENDING" }).Count

$immediateTasks = @($tasks | Where-Object { $_.Status -ne "COMPLETED" } | Sort-Object Priority, DueDate | Select-Object -First 5)

$taskLines = if ($immediateTasks.Count -gt 0) {
    ($immediateTasks | ForEach-Object {
        "- $($_.TaskID): $($_.TaskName) | Priority: $($_.Priority) | Status: $($_.Status) | Due: $($_.DueDate) | Next: $($_.NextAction)"
    }) -join "`r`n"
} else {
    "No open tasks found."
}

$riskLines = if (@($risks).Count -gt 0) {
    ($risks | ForEach-Object {
        "- $($_.RiskID): $($_.RiskTitle) | Level: $($_.RiskLevel) | Status: $($_.Status) | Mitigation: $($_.Mitigation)"
    }) -join "`r`n"
} else {
    "No risks recorded."
}

$kpiLines = if (@($kpis).Count -gt 0) {
    ($kpis | ForEach-Object {
        "- $($_.Metric): $($_.Value) / Target: $($_.Target) | Status: $($_.Status)"
    }) -join "`r`n"
} else {
    "No KPIs recorded."
}

$content = @"
# LITIGATION 360 LEOS
# PROJECT STATUS REPORT

Generated:
$(Get-Date -Format "yyyy-MM-dd HH:mm:ss")

## Current Project Phase

PHASE 12.0A - MASTER SSOT DEPLOYMENT AND CONTROL STRUCTURE CREATION

## Current Gate

PRE-PHASE 11.0 ENTERPRISE CHANGE CONTROL FOUNDATION

## Phase 11 Status

LOCKED

## Production Approval

NOT APPROVED

## Client Rollout

BLOCKED

---

# Dashboard Metrics

Total Tasks: $totalTasks  
Completed Tasks: $completedTasks  
In Progress Tasks: $inProgressTasks  
Pending Tasks: $pendingTasks  
Blocked Tasks: $blockedTasks  
Active Risks: $activeRisks  
Pending Approvals: $pendingApprovals  

---

# Immediate Task Sequence

$taskLines

---

# Risk and Blocker Summary

$riskLines

---

# KPI Status

$kpiLines

---

# On-Track Verification

On-track status is valid only if:

[ ] Dashboard generated
[ ] Health check generated
[ ] Tasks updated
[ ] Risks updated
[ ] Approvals reviewed
[ ] Evidence paths recorded
[ ] Phase 11 remains locked until all unlock checks pass

Current On-Track Status:
PENDING EVIDENCE

---

# Items Requiring Immediate Review

1. PMO deployment approval
2. Phase 11 lock checklist
3. Evidence folder completion
4. Module certification matrix
5. Route certification matrix
6. Risks marked CRITICAL or HIGH
7. Pending approvals

---

# Next Immediate Task

Run:

powershell -ExecutionPolicy Bypass -File ".\scripts\04-HEALTH-CHECK.ps1"

Then run:

powershell -ExecutionPolicy Bypass -File ".\scripts\06-UPDATE-DASHBOARD.ps1"
"@

$utf8NoBom = New-Object System.Text.UTF8Encoding($false)
[System.IO.File]::WriteAllText($reportPath, $content, $utf8NoBom)

Add-Audit -Action "Status report generated" -Status "PASS" -Detail $reportPath

Write-Host "[PASS] Status report generated:" -ForegroundColor Green
Write-Host $reportPath