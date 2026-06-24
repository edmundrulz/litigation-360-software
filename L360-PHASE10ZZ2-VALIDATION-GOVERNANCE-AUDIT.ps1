$ErrorActionPreference = "Stop"

$ProjectRoot = "C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software"
$PhaseRoot = Join-Path $ProjectRoot "_operations\phase-10ZZ2-validation-governance-audit"
$RawInventory = Join-Path $PhaseRoot "RAW-VALIDATION-INVENTORY.txt"

$Folders = @(
    "registry",
    "matrices",
    "reports",
    "docs",
    "validation",
    "logs",
    "backups"
)

foreach ($Folder in $Folders) {
    New-Item -ItemType Directory -Path (Join-Path $PhaseRoot $Folder) -Force | Out-Null
}

if (-not (Test-Path $RawInventory)) {
    Write-Host "❌ RAW-VALIDATION-INVENTORY.txt missing"
    exit 1
}

$Lines = Get-Content $RawInventory | Where-Object { $_ -match "C:\\Users\\" }
$Total = $Lines.Count

$Categories = @{
    "Backend" = ($Lines | Where-Object { $_ -match "\\backend\\" }).Count
    "Frontend" = ($Lines | Where-Object { $_ -match "\\frontend\\|\\src\\|\\components\\" }).Count
    "Operations" = ($Lines | Where-Object { $_ -match "\\_operations\\" }).Count
    "PowerShell" = ($Lines | Where-Object { $_ -match "\.ps1$" }).Count
    "Batch" = ($Lines | Where-Object { $_ -match "\.bat$" }).Count
    "JavaScript" = ($Lines | Where-Object { $_ -match "\.js$" }).Count
    "Logs" = ($Lines | Where-Object { $_ -match "\.log$" }).Count
    "Docs" = ($Lines | Where-Object { $_ -match "\.md$|\.txt$" }).Count
    "Audit" = ($Lines | Where-Object { $_ -match "audit" }).Count
    "Health" = ($Lines | Where-Object { $_ -match "health" }).Count
    "Validation" = ($Lines | Where-Object { $_ -match "validat|verify|check" }).Count
}

$Registry = "# MASTER VALIDATION REGISTRY`n`n"
$Registry += "Total Validation-Related Assets: $Total`n`n"
$Registry += "| No | Asset Path |`n|---:|---|`n"

$i = 1
foreach ($Line in $Lines) {
    $Registry += "| $i | $Line |`n"
    $i++
}

$Coverage = "# VALIDATION COVERAGE MATRIX`n`n"
$Coverage += "| Domain | Asset Count | Status |`n|---|---:|---|`n"

foreach ($Key in $Categories.Keys) {
    $Status = if ($Categories[$Key] -gt 0) { "COVERED" } else { "MISSING" }
    $Coverage += "| $Key | $($Categories[$Key]) | $Status |`n"
}

$Ownership = "# VALIDATION OWNERSHIP MATRIX`n`n"
$Ownership += "| Domain | Primary Owner | Technical Owner | Governance Owner | Review Cycle |`n"
$Ownership += "|---|---|---|---|---|`n"
foreach ($Key in $Categories.Keys) {
    $Ownership += "| $Key | Operations Owner | Technical Owner | Governance Owner | 30 days |`n"
}

$Missing = "# MISSING VALIDATIONS`n`n"
$Missing += "The following domains require governance review if asset count is zero:`n`n"

$MissingCount = 0
foreach ($Key in $Categories.Keys) {
    if ($Categories[$Key] -eq 0) {
        $Missing += "- $Key validation coverage missing`n"
        $MissingCount++
    }
}

if ($MissingCount -eq 0) {
    $Missing += "No zero-coverage validation domains detected.`n"
}

$Gap = "# VALIDATION GAP ANALYSIS`n`n"
$Gap += "Live Validation Inventory Count: $Total`n`n"
$Gap += "Previous Baseline: 284`n`n"
$Gap += "Current Difference: $($Total - 284)`n`n"
$Gap += "Interpretation: Validation-related assets have expanded and now require registry, ownership, lifecycle control, and recurring governance review.`n"

$Policy = "# VALIDATION LIFECYCLE POLICY`n`n"
$Policy += "## Purpose`n"
$Policy += "This policy governs validation assets across Litigation 360 before Phase 11 promotion.`n`n"
$Policy += "## Rules`n"
$Policy += "1. Every validation asset must be registered.`n"
$Policy += "2. Every validation asset must have ownership.`n"
$Policy += "3. Every validation asset must map to a domain.`n"
$Policy += "4. Every missing validation must be documented.`n"
$Policy += "5. Validation governance must be reviewed every 30 days.`n"
$Policy += "6. Phase 11 cannot proceed without validation governance PASS.`n"

$FinalStatus = if ($Total -gt 0 -and $MissingCount -eq 0) { "PASS" } else { "REVIEW REQUIRED" }

$Result = "# PHASE 10ZZ.2 VALIDATION GOVERNANCE AUDIT RESULT`n`n"
$Result += "Total Assets: $Total`n"
$Result += "Missing Domains: $MissingCount`n"
$Result += "Final Status: $FinalStatus`n"

$Report = "# PHASE 10ZZ.2 VALIDATION GOVERNANCE AUDIT REPORT`n`n"
$Report += "Project Root:`n$ProjectRoot`n`n"
$Report += "Phase Root:`n$PhaseRoot`n`n"
$Report += "Raw Inventory:`n$RawInventory`n`n"
$Report += "Validation Assets Found:`n$Total`n`n"
$Report += "Final Status:`n$FinalStatus`n`n"
$Report += "Generated:`n"
$Report += "- MASTER-VALIDATION-REGISTRY.md`n"
$Report += "- VALIDATION-COVERAGE-MATRIX.md`n"
$Report += "- VALIDATION-OWNERSHIP-MATRIX.md`n"
$Report += "- MISSING-VALIDATIONS.md`n"
$Report += "- VALIDATION-GAP-ANALYSIS.md`n"
$Report += "- VALIDATION-LIFECYCLE-POLICY.md`n"
$Report += "- VALIDATION-GOVERNANCE-RESULT.md`n`n"
$Report += "Next Phase:`n10ZZ.3 Testing Governance Audit`n"

Set-Content (Join-Path $PhaseRoot "registry\MASTER-VALIDATION-REGISTRY.md") $Registry -Encoding UTF8
Set-Content (Join-Path $PhaseRoot "matrices\VALIDATION-COVERAGE-MATRIX.md") $Coverage -Encoding UTF8
Set-Content (Join-Path $PhaseRoot "matrices\VALIDATION-OWNERSHIP-MATRIX.md") $Ownership -Encoding UTF8
Set-Content (Join-Path $PhaseRoot "reports\MISSING-VALIDATIONS.md") $Missing -Encoding UTF8
Set-Content (Join-Path $PhaseRoot "reports\VALIDATION-GAP-ANALYSIS.md") $Gap -Encoding UTF8
Set-Content (Join-Path $PhaseRoot "docs\VALIDATION-LIFECYCLE-POLICY.md") $Policy -Encoding UTF8
Set-Content (Join-Path $PhaseRoot "validation\VALIDATION-GOVERNANCE-RESULT.md") $Result -Encoding UTF8
Set-Content (Join-Path $PhaseRoot "reports\PHASE-10ZZ2-VALIDATION-GOVERNANCE-AUDIT-REPORT.md") $Report -Encoding UTF8
Set-Content (Join-Path $PhaseRoot "logs\PHASE-10ZZ2-RUN-LOG.txt") "10ZZ.2 completed. Status: $FinalStatus. Assets: $Total" -Encoding UTF8

Write-Host ""
Write-Host "===================================================="
Write-Host "PHASE 10ZZ.2 VALIDATION GOVERNANCE AUDIT"
Write-Host "===================================================="
Write-Host "Validation Assets Found : $Total"
Write-Host "Missing Domains         : $MissingCount"
Write-Host "Final Status            : $FinalStatus"
Write-Host "Report                  : $PhaseRoot\reports\PHASE-10ZZ2-VALIDATION-GOVERNANCE-AUDIT-REPORT.md"
Write-Host "===================================================="

if ($FinalStatus -eq "PASS") {
    exit 0
} else {
    exit 1
}
