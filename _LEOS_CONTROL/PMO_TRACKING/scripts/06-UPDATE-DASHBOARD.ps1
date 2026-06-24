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
    if (Test-Path $Path) { return Import-Csv $Path }
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
        Script="06-UPDATE-DASHBOARD.ps1"
        User=$env:USERNAME
    }
    $row | Export-Csv -Path $audit -NoTypeInformation -Append
}

$tasks = Import-CsvSafe (Join-Path $PmoRoot "01_DATABASE\TASKS.csv")
$milestones = Import-CsvSafe (Join-Path $PmoRoot "01_DATABASE\MILESTONES.csv")
$risks = Import-CsvSafe (Join-Path $PmoRoot "01_DATABASE\RISKS_BLOCKERS.csv")
$approvals = Import-CsvSafe (Join-Path $PmoRoot "01_DATABASE\APPROVALS.csv")
$kpis = Import-CsvSafe (Join-Path $PmoRoot "01_DATABASE\KPI_METRICS.csv")

$totalTasks = @($tasks).Count
$completedTasks = @($tasks | Where-Object { $_.Status -eq "COMPLETED" }).Count
$inProgressTasks = @($tasks | Where-Object { $_.Status -eq "IN_PROGRESS" }).Count
$pendingTasks = @($tasks | Where-Object { $_.Status -eq "PENDING" }).Count
$blockedTasks = @($tasks | Where-Object { $_.Status -eq "BLOCKED" }).Count
$activeRisks = @($risks | Where-Object { $_.Status -eq "ACTIVE" }).Count
$pendingApprovals = @($approvals | Where-Object { $_.Status -eq "PENDING" }).Count

$taskSummary = if (@($tasks).Count -gt 0) {
    ($tasks | Select-Object -First 10 | ForEach-Object {
        "| $($_.TaskID) | $($_.TaskName) | $($_.Priority) | $($_.Status) | $($_.PercentComplete)% | $($_.DueDate) | $($_.VerificationStatus) |"
    }) -join "`r`n"
} else {
    "| - | No tasks found | - | - | - | - | - |"
}

$riskSummary = if (@($risks).Count -gt 0) {
    ($risks | Select-Object -First 10 | ForEach-Object {
        "| $($_.RiskID) | $($_.RiskTitle) | $($_.RiskLevel) | $($_.Status) | $($_.Mitigation) |"
    }) -join "`r`n"
} else {
    "| - | No risks found | - | - | - |"
}

$kpiSummary = if (@($kpis).Count -gt 0) {
    ($kpis | ForEach-Object {
        "| $($_.Metric) | $($_.Value) | $($_.Target) | $($_.Status) |"
    }) -join "`r`n"
} else {
    "| - | - | - | - |"
}

$dashboard = @"
# LITIGATION 360 LEOS
# PROJECT STATUS DASHBOARD

Last Updated:
$(Get-Date -Format "yyyy-MM-dd HH:mm:ss")

---

# Current Project Phase

PHASE 12.0A - MASTER SSOT DEPLOYMENT AND CONTROL STRUCTURE CREATION

# Current Governance Gate

PRE-PHASE 11.0 ENTERPRISE CHANGE CONTROL FOUNDATION

# Phase 11 Status

LOCKED

# Production Approval

NOT APPROVED

# Client Rollout

BLOCKED

---

# Executive Metrics

| Metric | Value |
|---|---:|
| Total Tasks | $totalTasks |
| Completed Tasks | $completedTasks |
| In Progress Tasks | $inProgressTasks |
| Pending Tasks | $pendingTasks |
| Blocked Tasks | $blockedTasks |
| Active Risks | $activeRisks |
| Pending Approvals | $pendingApprovals |

---

# Task Dashboard

| Task ID | Task | Priority | Status | Completion | Due Date | Verification |
|---|---|---|---|---:|---|---|
$taskSummary

---

# Risk Dashboard

| Risk ID | Risk | Level | Status | Mitigation |
|---|---|---|---|---|
$riskSummary

---

# KPI Dashboard

| Metric | Value | Target | Status |
|---|---|---|---|
$kpiSummary

---

# Missing Deliverables / Dependencies / Blockers

Current known missing deliverables:

- Physical SSOT deployment evidence
- Evidence folder populated with real evidence
- Module certification matrix completed
- Route certification matrix completed
- Pre-Phase 11 unlock checklist completed
- Governance certification decision

---

# Immediate Review / Approval Required

1. Approve PMO Tracking System deployment
2. Verify Phase 11 remains locked
3. Review active risks
4. Review pending approvals
5. Confirm no cleanup or source modification has occurred

---

# Next Immediate Task

Run health check:

powershell -ExecutionPolicy Bypass -File ".\scripts\04-HEALTH-CHECK.ps1"

Then generate report:

powershell -ExecutionPolicy Bypass -File ".\scripts\03-GENERATE-STATUS-REPORT.ps1"

---

# On-Track Verification

Current on-track status:
PENDING EVIDENCE

On-track requires:
[ ] Dashboard updated
[ ] Health check PASS
[ ] No Phase 11 feature work started
[ ] No deletion/cleanup performed
[ ] Evidence folders created
[ ] Verification reports generated
"@

$path = Join-Path $PmoRoot "00_DASHBOARD\DASHBOARD.md"
$utf8NoBom = New-Object System.Text.UTF8Encoding($false)
[System.IO.File]::WriteAllText($path, $dashboard, $utf8NoBom)

Add-Audit -Action "Dashboard updated" -Status "PASS" -Detail $path

Write-Host "[PASS] Dashboard updated:" -ForegroundColor Green
Write-Host $path