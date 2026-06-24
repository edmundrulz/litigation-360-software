# ============================================================
# LITIGATION 360 LEOS
# MATTER DETAILS LIVE PROGRESS MONITOR
# VERSION: 12.0B-FIXED
# SAFE MODE: READ-ONLY
# DOES NOT MODIFY FRONTEND/BACKEND/DATABASE CODE
# ============================================================

Set-StrictMode -Version Latest
$ErrorActionPreference = "SilentlyContinue"

$ProjectRoot = "C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software"
$ControlRoot = Join-Path $ProjectRoot "_LEOS_CONTROL"

if (!(Test-Path $ProjectRoot)) {
    throw "Project root not found: $ProjectRoot"
}

if (!(Test-Path $ControlRoot)) {
    throw "Control root not found: $ControlRoot"
}

$MonitorFolder = Join-Path $ControlRoot "05_MONITORING\MATTER_DETAILS"
$DiscoveryFolder = Join-Path $ControlRoot "07_DISCOVERY\MATTER_DETAILS"

New-Item -ItemType Directory -Path $MonitorFolder -Force | Out-Null
New-Item -ItemType Directory -Path $DiscoveryFolder -Force | Out-Null

$ReportPath = Join-Path $MonitorFolder "MATTER-DETAILS-LIVE-PROGRESS.md"
$CsvPath = Join-Path $MonitorFolder "MATTER-DETAILS-LIVE-PROGRESS.csv"
$DiscoveryPath = Join-Path $DiscoveryFolder "MATTER-DETAILS-LIVE-DISCOVERY.csv"
$NestedControlWarningPath = Join-Path $MonitorFolder "NESTED-CONTROL-FOLDER-WARNING.txt"

$ExcludedRegex = "\\node_modules\\|\\.git\\|\\dist\\|\\build\\|\\coverage\\|\\_LEOS_CONTROL\\02_SNAPSHOTS\\"

# Detect accidental nested control folder, but do not delete anything.
$NestedControlRoot = Join-Path $ControlRoot "_LEOS_CONTROL"
$NestedControlExists = Test-Path $NestedControlRoot

if ($NestedControlExists) {
    $Warning = @"
WARNING:
A nested control folder appears to exist:

$NestedControlRoot

This may have been created by the earlier monitor path bug.

No deletion has been performed.

Recommended later action:
Classify first, then decide whether it is safe to archive or remove.
"@
    $Utf8NoBom = New-Object System.Text.UTF8Encoding($false)
    [System.IO.File]::WriteAllText($NestedControlWarningPath, $Warning, $Utf8NoBom)
}

$MatterFiles = Get-ChildItem -Path $ProjectRoot -Recurse -File |
Where-Object {
    $_.FullName -notmatch $ExcludedRegex -and
    (
        $_.Name -match "matter|case|client|deadline|document|intake" -or
        $_.FullName -match "matter|case|client|deadline|document|intake"
    )
} |
Select-Object FullName, Name, Extension, Length, LastWriteTime

$MatterFiles | Export-Csv -Path $DiscoveryPath -NoTypeInformation

$RequiredFiles = @(
    "_LEOS_CONTROL\08_BLUEPRINTS\MATTER_DETAILS\MATTER-DETAILS-MASTER-BLUEPRINT.md",
    "_LEOS_CONTROL\09_PARAMETERS\MATTER_DETAILS\MATTER-DETAILS-PARAMETERS.md",
    "_LEOS_CONTROL\10_PROTOCOLS\MATTER_DETAILS\MATTER-DETAILS-IMPLEMENTATION-PROTOCOL.md",
    "_LEOS_CONTROL\04_TESTING\MATTER_DETAILS\MATTER-DETAILS-TEST-PLAN.md",
    "_LEOS_CONTROL\04_TESTING\MATTER_DETAILS\MATTER-DETAILS-VERIFICATION-CHECKLIST.md",
    "_LEOS_CONTROL\03_ROLLBACK\MATTER-DETAILS-ROLLBACK-PLAN.md",
    "_LEOS_CONTROL\04_TESTING\MATTER_DETAILS\MATTER-DETAILS-MODULE-CERTIFICATION-MATRIX.csv",
    "_LEOS_CONTROL\04_TESTING\MATTER_DETAILS\MATTER-DETAILS-ROUTE-CERTIFICATION-MATRIX.csv"
)

$StatusRows = foreach ($File in $RequiredFiles) {
    $Full = Join-Path $ProjectRoot $File
    [PSCustomObject]@{
        Timestamp = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")
        Item = $File
        FullPath = $Full
        Exists = if (Test-Path $Full) { "YES" } else { "NO" }
        Status = if (Test-Path $Full) { "PASS" } else { "PENDING" }
    }
}

$StatusRows | Export-Csv -Path $CsvPath -NoTypeInformation

$Ports = @(3000,5000,5060,5061,5100,5173,8080)

$PortRows = foreach ($Port in $Ports) {
    $Conn = Get-NetTCPConnection -LocalPort $Port -State Listen -ErrorAction SilentlyContinue
    [PSCustomObject]@{
        Port = $Port
        Listening = if ($Conn) { "YES" } else { "NO" }
        ProcessId = if ($Conn) { ($Conn.OwningProcess | Select-Object -First 1) } else { "" }
    }
}

$MatterFileCount = ($MatterFiles | Measure-Object).Count
$RequiredPassCount = ($StatusRows | Where-Object { $_.Status -eq "PASS" } | Measure-Object).Count
$RequiredTotal = ($StatusRows | Measure-Object).Count

$Report = @"
# LITIGATION 360 LEOS
# MATTER DETAILS LIVE PROGRESS MONITOR

Generated:
$(Get-Date -Format "yyyy-MM-dd HH:mm:ss")

Project Root:
$ProjectRoot

Control Root:
$ControlRoot

Current Phase:
PHASE 12.0B - MATTER DETAILS GOVERNANCE, BLUEPRINT, MONITORING AND READ-ONLY DISCOVERY

Safety Mode:
READ-ONLY

Application Code Modified:
NO

Frontend Modified:
NO

Backend Modified:
NO

Database Modified:
NO

Deletion Performed:
NO

Rename Performed:
NO

Folder Movement Performed:
NO

Phase 11 Work:
BLOCKED

---

# Governance Pack Status

Required Pack Items Passing:
$RequiredPassCount / $RequiredTotal

Status CSV:
$CsvPath

---

# Matter / Case / Client / Deadline / Document Related File Discovery

Candidate Files Found:
$MatterFileCount

Discovery CSV:
$DiscoveryPath

---

# Nested Control Folder Check

Nested _LEOS_CONTROL Exists:
$NestedControlExists

Nested Warning File:
$NestedControlWarningPath

Important:
If nested control folder exists, do not delete it yet. Classify first.

---

# Port Status

$($PortRows | Format-Table -AutoSize | Out-String)

---

# Current Recommended Next Action

Open the discovery CSV and identify the exact frontend file that renders:

Create Case
Case Title
Select Client
Create

Do not change application code until the exact file path is confirmed and backed up.

---

# PASS CRITERIA FOR PHASE 12.0B

[ ] Blueprint exists
[ ] Parameters exist
[ ] Protocol exists
[ ] Test plan exists
[ ] Verification checklist exists
[ ] Rollback plan exists
[ ] Module matrix exists
[ ] Route matrix exists
[ ] Discovery report exists
[ ] Live monitor runs
[ ] No application code modified

---

# CURRENT STATUS

PENDING DISCOVERY REVIEW
"@

$Utf8NoBom = New-Object System.Text.UTF8Encoding($false)
[System.IO.File]::WriteAllText($ReportPath, $Report, $Utf8NoBom)

Write-Host ""
Write-Host "Matter Details Live Monitor Complete" -ForegroundColor Green
Write-Host "Report: $ReportPath" -ForegroundColor Cyan
Write-Host "Discovery: $DiscoveryPath" -ForegroundColor Cyan
Write-Host "Status CSV: $CsvPath" -ForegroundColor Cyan