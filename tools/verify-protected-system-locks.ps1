$ErrorActionPreference = "Stop"

Write-Host "=== VERIFY FULL PROTECTED SYSTEM LOCKS ==="

$failures = @()

function Require-File {
  param([string]$Path, [string]$Label)

  if (!(Test-Path $Path)) {
    $script:failures += "Missing protected file: $Label -> $Path"
  }
}

function Require-Marker {
  param([string]$Path, [string]$Marker, [string]$Label)

  if (!(Test-Path $Path)) {
    $script:failures += "Missing file for marker check: $Path"
    return
  }

  $content = Get-Content $Path -Raw

  if ($content -notlike "*$Marker*") {
    $script:failures += "Missing protected marker [$Label]: $Marker in $Path"
  }
}

# ------------------------------------------------------------
# 1. Protected source baseline files
# ------------------------------------------------------------

Require-File "frontend/src/App.jsx" "Main app render/control file"
Require-File "frontend/src/App.css" "Main app stylesheet"
Require-File "frontend/src/pages/Clients.jsx" "Page 3 client directory page"

# ------------------------------------------------------------
# 2. Page 3 protected markers
# ------------------------------------------------------------

Require-Marker "frontend/src/pages/Clients.jsx" "alphabet-filter-control" "Page 3 alphabet structured control"
Require-Marker "frontend/src/pages/Clients.jsx" "alphabet-filter-main-row" "Page 3 alphabet main row"
Require-Marker "frontend/src/pages/Clients.jsx" "alphabet-filter-select-field" "Page 3 alphabet select field"
Require-Marker "frontend/src/pages/Clients.jsx" "alphabet-filter-manual-field" "Page 3 alphabet manual field"
Require-Marker "frontend/src/pages/Clients.jsx" "alphabet-chip-grid" "Page 3 alphabet chip grid"

Require-Marker "frontend/src/App.css" "PHASE 14E ALPHABET FILTER FINAL STRUCTURED CONTROL" "Page 3 alphabet final CSS"
Require-Marker "frontend/src/App.css" "PHASE 14E SIMPLE REQUIRED COUNTER LABEL FIX" "Page 3 required counter CSS"
Require-Marker "frontend/src/App.css" "client-required-field-counter-metrics" "Page 3 required counter metrics"

# ------------------------------------------------------------
# 3. Page 4+ progress calculator protected markers
# ------------------------------------------------------------

Require-Marker "frontend/src/App.jsx" "function computeRequiredProgress(items)" "Page 4+ progress helper"
Require-Marker "frontend/src/App.jsx" "function PageRequiredProgressCard" "Page 4+ progress card"
Require-Marker "frontend/src/App.jsx" "const isPostPage3Module" "Page 4+ post-page-3 module gate"
Require-Marker "frontend/src/App.jsx" "const pageProgressItems" "Page 4+ progress item map"
Require-Marker "frontend/src/App.jsx" "workflow-progress-dashboard" "Page 4+ progress visual class"

# ------------------------------------------------------------
# 4. Phase 14 implementation / closeout / integration docs
# ------------------------------------------------------------

Require-File "docs/phase-14/implementation/PAGE_4_PLUS_PROGRESS_CALCULATOR_SETUP_20260703.md" "Page 4+ setup note"
Require-File "docs/phase-14/implementation/PAGE_4_PLUS_PROGRESS_CALCULATOR_IMPLEMENTATION_20260703.md" "Page 4+ implementation note"
Require-File "docs/phase-14/closeout/PAGE_4_PLUS_PROGRESS_CALCULATOR_HANDOVER_20260703.md" "Page 4+ handover"
Require-File "docs/phase-14/integration/PAGE_4_PLUS_PROGRESS_CALCULATOR_INTEGRATED_20260703.md" "Page 4+ integration note"

# ------------------------------------------------------------
# 5. Phase 14 audit docs
# ------------------------------------------------------------

Require-File "docs/phase-14/audit/PHASE_14_MASTER_COMPLETION_AUDIT_20260703.md" "Phase 14 master audit"
Require-File "docs/phase-14/audit/PHASE_14_BRANCH_CLASSIFICATION_MATRIX_20260703.md" "Phase 14 branch classification matrix"
Require-File "docs/phase-14/audit/evidence/PHASE_14_BRANCH_EVIDENCE_20260703.txt" "Phase 14 evidence file"

# Decision / plan may not exist in every branch yet, but if present they are protected by deletion guard.
if (Test-Path "docs/phase-14/audit/PHASE_14_MASTER_COMPLETION_DECISION_20260703.md") {
  Require-File "docs/phase-14/audit/PHASE_14_MASTER_COMPLETION_DECISION_20260703.md" "Phase 14 decision note"
}

if (Test-Path "docs/phase-14/audit/PHASE_14_TO_PHASE_15_INTEGRATION_PLAN_20260703.md") {
  Require-File "docs/phase-14/audit/PHASE_14_TO_PHASE_15_INTEGRATION_PLAN_20260703.md" "Phase 14 to Phase 15 integration plan"
}

# ------------------------------------------------------------
# 6. Governance protection docs
# ------------------------------------------------------------

Require-File "docs/governance/VERSION_CONTROL_CHANGE_MANAGEMENT_POLICY_20260703.md" "Version control change management policy"
Require-File "docs/governance/PROTECTED_WORK_REGISTER_20260703.md" "Protected work register"

# ------------------------------------------------------------
# 7. Tooling locks
# ------------------------------------------------------------

Require-File "tools/verify-no-protected-deletions.ps1" "General protected deletion guard"
Require-File "tools/protection-pre-commit-check.ps1" "Protection pre-commit check"
Require-File "tools/create-protected-version-snapshot.ps1" "Protected snapshot tool"

Require-File "tools/verify-page3-required-counter-lock.ps1" "Page 3 required counter lock"
Require-File "tools/verify-page3-alphabet-filter-lock.ps1" "Page 3 alphabet filter lock"
Require-File "tools/verify-page3-real-percentage-lock.ps1" "Page 3 real percentage lock"

# ------------------------------------------------------------
# Final result
# ------------------------------------------------------------

if ($failures.Count -gt 0) {
  Write-Host ""
  Write-Host "FULL PROTECTED SYSTEM LOCK FAILED" -ForegroundColor Red
  foreach ($failure in $failures) {
    Write-Host $failure -ForegroundColor Red
  }
  exit 1
}

Write-Host "SOURCE BASELINE LOCK PASSED" -ForegroundColor Green
Write-Host "PAGE 3 STRUCTURAL LOCK PASSED" -ForegroundColor Green
Write-Host "PAGE 4+ PROGRESS CALCULATOR LOCK PASSED" -ForegroundColor Green
Write-Host "PHASE 14 AUDIT / CLOSEOUT LOCK PASSED" -ForegroundColor Green
Write-Host "GOVERNANCE POLICY LOCK PASSED" -ForegroundColor Green
Write-Host "TOOLING LOCK PASSED" -ForegroundColor Green
Write-Host "FULL PROTECTED SYSTEM LOCK PASSED" -ForegroundColor Green

exit 0
