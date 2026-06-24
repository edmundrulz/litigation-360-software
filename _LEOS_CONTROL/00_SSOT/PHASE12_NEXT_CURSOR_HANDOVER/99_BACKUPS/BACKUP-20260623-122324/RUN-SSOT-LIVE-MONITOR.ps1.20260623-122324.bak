param(
    [int]$Cycles = 1,
    [int]$DelaySeconds = 5,
    [switch]$Continuous
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$ProjectRoot = "C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software"
$SsotRoot = "C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\_LEOS_CONTROL\00_SSOT\PHASE12_NEXT_CURSOR_HANDOVER"
$MonitorDir = Join-Path $SsotRoot "08_LIVE_MONITORING"
$LiveStatusPath = Join-Path $MonitorDir "LIVE-STATUS.md"
$LiveCsvPath = Join-Path $MonitorDir "LIVE-MONITOR.csv"

$RequiredPaths = @(
    (Join-Path $SsotRoot "MASTER-SSOT-CURSOR-HANDOVER.md"),
    (Join-Path $SsotRoot "SSOT-CURRENT-AUTHORITY.md"),
    (Join-Path $SsotRoot "TIMELINE-CURRENCY-TRACKER.md"),
    (Join-Path $SsotRoot "DECISION-LOG.md"),
    (Join-Path $SsotRoot "VARIATION-REGISTRY.md"),
    (Join-Path $SsotRoot "ROADMAP-MILESTONES.md"),
    (Join-Path $SsotRoot "SOP-SAFE-CURSOR-WORKFLOW.md"),
    (Join-Path $SsotRoot "HANDOVER-NOTES-FOR-CURSOR.md"),
    (Join-Path $SsotRoot "TESTING-VERIFICATION-CHECKLIST.md"),
    (Join-Path $SsotRoot "ROLLBACK-PROTOCOL.md"),
    (Join-Path $SsotRoot "COMPLIANCE-CHECKLIST.md"),
    (Join-Path $SsotRoot "VERSION-CONTROL-UPDATE-PROTOCOL.md"),
    (Join-Path $SsotRoot "07_AUTOMATION_SCRIPTS\RUN-SSOT-VERIFY.ps1"),
    (Join-Path $SsotRoot "07_AUTOMATION_SCRIPTS\RUN-SSOT-LIVE-MONITOR.ps1"),
    (Join-Path $ProjectRoot ".cursor\rules\00-litigation360-core-safety.mdc")
)

if (!(Test-Path -LiteralPath $MonitorDir)) {
    New-Item -Path $MonitorDir -ItemType Directory -Force | Out-Null
}

if (!(Test-Path -LiteralPath $LiveCsvPath)) {
    "Timestamp,Phase,CompletionPercent,Status,RiskLevel,Blockers,Verification,NextAction" | Set-Content -Path $LiveCsvPath -Encoding UTF8
}

$i = 0

do {
    $Now = Get-Date -Format "yyyy-MM-dd HH:mm:ss zzz"

    $Found = 0
    foreach ($Path in $RequiredPaths) {
        if (Test-Path -LiteralPath $Path) {
            $Found++
        }
    }

    $Completion = [Math]::Round(($Found / $RequiredPaths.Count) * 100, 0)

    if ($Completion -eq 100) {
        $Status = "SSOT control pack verified at file-existence level"
        $Verification = "PASS"
        $NextAction = "Open project in Cursor and instruct Cursor to inspect only"
    }
    else {
        $Status = "SSOT control pack incomplete"
        $Verification = "FAIL"
        $NextAction = "Run bootstrap again or inspect missing files"
    }

    $RiskLevel = "Low"
    $Blockers = "Production development remains locked"

    $LiveStatus = @"
# LIVE STATUS

Updated:
$Now

Project:
Litigation 360 LEOS

Phase:
PHASE12_NEXT_CURSOR_HANDOVER

Completion:
$Completion%

Status:
$Status

Risk level:
$RiskLevel

Blockers:
$Blockers

Verification:
$Verification

Next action:
$NextAction

Safety note:
This monitor checks documentation/control files only. It does not edit production code.
"@

    $LiveStatus | Set-Content -Path $LiveStatusPath -Encoding UTF8

    $CsvLine = "$Now,PHASE12_NEXT_CURSOR_HANDOVER,$Completion,$Status,$RiskLevel,$Blockers,$Verification,$NextAction"
    Add-Content -Path $LiveCsvPath -Value $CsvLine -Encoding UTF8

    Write-Host "[$Now] Completion $Completion% | $Verification | $NextAction"

    $i++

    if (!$Continuous -and $i -ge $Cycles) {
        break
    }

    Start-Sleep -Seconds $DelaySeconds

} while ($true)
