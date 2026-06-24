Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$ProjectRoot = "C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software"
$SsotRoot = "C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\_LEOS_CONTROL\00_SSOT\PHASE12_NEXT_CURSOR_HANDOVER"
$CursorRulesDir = Join-Path $ProjectRoot ".cursor\rules"

$RequiredPaths = @(
    $ProjectRoot,
    $SsotRoot,
    (Join-Path $SsotRoot "MASTER-SSOT-CURSOR-HANDOVER.md"),
    (Join-Path $SsotRoot "SSOT-CURRENT-AUTHORITY.md"),
    (Join-Path $SsotRoot "TIMELINE-CURRENCY-TRACKER.md"),
    (Join-Path $SsotRoot "DECISION-LOG.md"),
    (Join-Path $SsotRoot "DECISION-LOG.csv"),
    (Join-Path $SsotRoot "VARIATION-REGISTRY.md"),
    (Join-Path $SsotRoot "VARIATION-REGISTRY.csv"),
    (Join-Path $SsotRoot "ROADMAP-MILESTONES.md"),
    (Join-Path $SsotRoot "SOP-SAFE-CURSOR-WORKFLOW.md"),
    (Join-Path $SsotRoot "HANDOVER-NOTES-FOR-CURSOR.md"),
    (Join-Path $SsotRoot "TESTING-VERIFICATION-CHECKLIST.md"),
    (Join-Path $SsotRoot "ROLLBACK-PROTOCOL.md"),
    (Join-Path $SsotRoot "COMPLIANCE-CHECKLIST.md"),
    (Join-Path $SsotRoot "VERSION-CONTROL-UPDATE-PROTOCOL.md"),
    (Join-Path $SsotRoot "AUDIT-LOG.md"),
    (Join-Path $SsotRoot "AUDIT-LOG.csv"),
    (Join-Path $SsotRoot "07_AUTOMATION_SCRIPTS\RUN-SSOT-VERIFY.ps1"),
    (Join-Path $SsotRoot "07_AUTOMATION_SCRIPTS\RUN-SSOT-LIVE-MONITOR.ps1"),
    (Join-Path $SsotRoot "07_AUTOMATION_SCRIPTS\RUN-SSOT-VERIFY.cmd"),
    (Join-Path $SsotRoot "07_AUTOMATION_SCRIPTS\RUN-SSOT-LIVE-MONITOR.cmd"),
    (Join-Path $SsotRoot "08_LIVE_MONITORING\LIVE-STATUS.md"),
    (Join-Path $SsotRoot "08_LIVE_MONITORING\LIVE-MONITOR.csv"),
    $CursorRulesDir,
    (Join-Path $CursorRulesDir "00-litigation360-core-safety.mdc"),
    (Join-Path $CursorRulesDir "01-windows-powershell-automation.mdc"),
    (Join-Path $CursorRulesDir "02-documentation-handover.mdc")
)

$Results = foreach ($Path in $RequiredPaths) {
    [PSCustomObject]@{
        Exists = Test-Path -LiteralPath $Path
        Path = $Path
    }
}

$Results | Format-Table -AutoSize

$Missing = @($Results | Where-Object { $_.Exists -eq $false })
$MissingCount = $Missing.Count

Write-Host ""
Write-Host "============================================================"
Write-Host "SSOT VERIFICATION SUMMARY"
Write-Host "============================================================"
Write-Host "Total checked: $($Results.Count)"
Write-Host "Missing:       $MissingCount"

if ($MissingCount -gt 0) {
    Write-Host ""
    Write-Host "FAILED: Missing required SSOT files or folders."
    Write-Host "Review missing paths above."
    exit 1
}

Write-Host ""
Write-Host "PASSED: All required SSOT files and folders exist."
Write-Host "Production code was not checked or modified by this verification script."
exit 0
