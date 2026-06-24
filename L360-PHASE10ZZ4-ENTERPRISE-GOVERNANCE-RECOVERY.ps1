param(
    [ValidateSet("PLAN","APPLY","VERIFY")]
    [string]$Mode = "APPLY"
)

$ErrorActionPreference = "Stop"

$Root = "C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software"
$PhaseRoot = Join-Path $Root "_operations\phase-10ZZ4-enterprise-governance-recovery"

$Folders = @(
    "registry",
    "matrices",
    "reports",
    "validation",
    "logs",
    "monitoring",
    "evidence",
    "protocols",
    "parameters",
    "blueprints",
    "prompts",
    "checks-and-balances",
    "ownership",
    "review-cycles",
    "controls",
    "readiness",
    "backups"
)

$SourcePhases = @(
    "_operations\phase-10ZZ0-enterprise-documentation-governance-audit",
    "_operations\phase-10ZZ1A-enterprise-sop-library",
    "_operations\phase-10ZZ2-validation-governance-audit",
    "_operations\phase-10ZZ3-testing-governance-audit"
)

function Write-Step($Message) {
    Write-Host "[10ZZ.4] $Message"
}

function New-SafeFolder($Path) {
    if (!(Test-Path $Path)) {
        New-Item -ItemType Directory -Path $Path -Force | Out-Null
    }
}

function Get-PhaseStatus($RelativePath) {
    $Path = Join-Path $Root $RelativePath
    if (Test-Path $Path) {
        return "FOUND"
    }
    return "MISSING"
}

function Invoke-Apply {
    Write-Step "Creating enterprise governance recovery structure..."

    New-SafeFolder $PhaseRoot

    foreach ($Folder in $Folders) {
        New-SafeFolder (Join-Path $PhaseRoot $Folder)
    }

    $MasterRegistry = Join-Path $PhaseRoot "registry\MASTER-ENTERPRISE-GOVERNANCE-REGISTRY.md"
    $RecoveryMatrix = Join-Path $PhaseRoot "matrices\ENTERPRISE-GOVERNANCE-RECOVERY-MATRIX.md"
    $OwnershipMatrix = Join-Path $PhaseRoot "ownership\ENTERPRISE-GOVERNANCE-OWNERSHIP-MATRIX.md"
    $ReviewCycle = Join-Path $PhaseRoot "review-cycles\ENTERPRISE-GOVERNANCE-REVIEW-CYCLE.md"
    $Controls = Join-Path $PhaseRoot "controls\ENTERPRISE-GOVERNANCE-CONTROLS.md"
    $Protocol = Join-Path $PhaseRoot "protocols\ENTERPRISE-GOVERNANCE-RECOVERY-PROTOCOL.md"
    $Parameters = Join-Path $PhaseRoot "parameters\ENTERPRISE-GOVERNANCE-PARAMETERS.md"
    $Blueprint = Join-Path $PhaseRoot "blueprints\ENTERPRISE-GOVERNANCE-RECOVERY-BLUEPRINT.md"
    $Prompts = Join-Path $PhaseRoot "prompts\ENTERPRISE-GOVERNANCE-PROMPTS.md"
    $Checks = Join-Path $PhaseRoot "checks-and-balances\ENTERPRISE-GOVERNANCE-CHECKS-AND-BALANCES.md"
    $Readiness = Join-Path $PhaseRoot "readiness\PHASE-10-GOVERNANCE-READINESS-ASSESSMENT.md"
    $Monitoring = Join-Path $PhaseRoot "monitoring\enterprise-governance-recovery-status.json"
    $Evidence = Join-Path $PhaseRoot "evidence\GOVERNANCE-SOURCE-PHASES.txt"
    $Report = Join-Path $PhaseRoot "reports\PHASE-10ZZ4-ENTERPRISE-GOVERNANCE-RECOVERY-REPORT.md"
    $Log = Join-Path $PhaseRoot "logs\PHASE-10ZZ4.log"

    "# GOVERNANCE SOURCE PHASES`n" | Set-Content $Evidence -Encoding UTF8

    $MissingSources = @()

    foreach ($Source in $SourcePhases) {
        $Status = Get-PhaseStatus $Source
        "$Source | $Status" | Add-Content $Evidence -Encoding UTF8
        if ($Status -eq "MISSING") {
            $MissingSources += $Source
        }
    }

    @"
# MASTER ENTERPRISE GOVERNANCE REGISTRY

## Purpose
This registry consolidates the governance recovery status for Litigation 360.

## Governance Streams
| Stream | Required Evidence | Status |
|---|---|---|
| Documentation Governance | Documentation registry, coverage matrix, lifecycle policy | REQUIRED |
| SOP Governance | SOP library, SOP registry, SOP coverage matrix | REQUIRED |
| Validation Governance | Validation registry, validation coverage matrix | REQUIRED |
| Testing Governance | Test registry, test coverage matrix | REQUIRED |
| Ownership Governance | Owner matrix and review cycle | REQUIRED |
| Control Governance | Governance controls and escalation rules | REQUIRED |
| Readiness Governance | Phase 10 readiness assessment | REQUIRED |

## Phase 11 Lock
Phase 11 remains LOCKED until all governance streams are recovered, verified, and passed.
"@ | Set-Content $MasterRegistry -Encoding UTF8

    @"
# ENTERPRISE GOVERNANCE RECOVERY MATRIX

| Governance Area | Source Phase | Required Artifact | Recovery Status |
|---|---|---|---|
| Documentation | 10ZZ.0 | MASTER-DOCUMENTATION-REGISTRY.md | REVIEW REQUIRED |
| SOPs | 10ZZ1A | MASTER-SOP-REGISTRY.md | REVIEW REQUIRED |
| Validation | 10ZZ.2 | MASTER-VALIDATION-REGISTRY.md | REVIEW REQUIRED |
| Testing | 10ZZ.3 | MASTER-TEST-REGISTRY.md | REVIEW REQUIRED |
| Ownership | 10ZZ.4 | ENTERPRISE-GOVERNANCE-OWNERSHIP-MATRIX.md | GENERATED |
| Review Cycles | 10ZZ.4 | ENTERPRISE-GOVERNANCE-REVIEW-CYCLE.md | GENERATED |
| Controls | 10ZZ.4 | ENTERPRISE-GOVERNANCE-CONTROLS.md | GENERATED |
| Readiness | 10ZZ.4 | PHASE-10-GOVERNANCE-READINESS-ASSESSMENT.md | GENERATED |
"@ | Set-Content $RecoveryMatrix -Encoding UTF8

    @"
# ENTERPRISE GOVERNANCE OWNERSHIP MATRIX

| Governance Domain | Owner | Backup Owner | Review Frequency | Evidence Path |
|---|---|---|---|---|
| Documentation | Governance Owner | Project Owner | Monthly / Phase Gate | _operations |
| SOPs | Operations Owner | Governance Owner | Monthly / Phase Gate | _operations\phase-10ZZ1A-enterprise-sop-library |
| Validation | QA Owner | Governance Owner | Every Phase Gate | _operations\phase-10ZZ2-validation-governance-audit |
| Testing | QA Owner | Technical Owner | Every Phase Gate | _operations\phase-10ZZ3-testing-governance-audit |
| Security | Security Owner | Technical Owner | Monthly / Release Gate | backend / docs |
| Commercialisation | Commercial Owner | Governance Owner | Monthly / Release Gate | docs\governance\licensing |
| Monitoring | Operations Owner | Technical Owner | Weekly / Phase Gate | monitoring |
| Deployment | DevOps Owner | Technical Owner | Every Deployment | deployment / tests |
| Recovery | Operations Owner | Governance Owner | Monthly / Incident | backup / recovery |
| Phase 11 Approval | Project Owner | Governance Owner | Final Gate Only | _operations |
"@ | Set-Content $OwnershipMatrix -Encoding UTF8

    @"
# ENTERPRISE GOVERNANCE REVIEW CYCLE

## Daily
- Monitor system health
- Review failed validations
- Review failed tests
- Review audit warnings

## Weekly
- Review monitoring dashboards
- Review open governance gaps
- Review unresolved test failures
- Review operational risks

## Monthly
- Review SOP currency
- Review documentation coverage
- Review validation ownership
- Review testing coverage
- Review commercial licensing controls

## Phase Gate
- Documentation PASS
- SOP PASS
- Validation PASS
- Testing PASS
- Governance Recovery PASS
- Final Readiness PASS

## Release Gate
- Regression test confirmation
- Backup confirmation
- Rollback confirmation
- Audit confirmation
- Approval confirmation
"@ | Set-Content $ReviewCycle -Encoding UTF8

    @"
# ENTERPRISE GOVERNANCE CONTROLS

## Mandatory Controls
1. No Phase 11 without final readiness PASS.
2. No deletion without backup and rollback.
3. No service refactor before consolidation approval.
4. No archive of protected files.
5. No commercial restriction on Ground Zero.
6. No production deployment without audit trail.
7. No manual undocumented changes.
8. No untested route changes.
9. No unregistered module changes.
10. No governance bypass.

## Escalation Rules
If validation fails:
- Stop.
- Record failure.
- Preserve logs.
- Do not continue to Phase 11.
- Fix and re-run verification.

If test baseline fails:
- Stop.
- Identify failing suite.
- Restore if needed.
- Re-run tests.
- Record recovery evidence.
"@ | Set-Content $Controls -Encoding UTF8

    @"
# ENTERPRISE GOVERNANCE RECOVERY PROTOCOL

## Purpose
Recover and unify documentation, SOP, validation, testing, ownership, review cycle, and control governance for Litigation 360.

## Process
1. Confirm previous governance phases exist.
2. Register governance streams.
3. Generate recovery matrix.
4. Assign ownership.
5. Define review cycles.
6. Define mandatory controls.
7. Generate readiness assessment.
8. Validate required files.
9. Produce PASS/FAIL result.

## Required Evidence
- MASTER-ENTERPRISE-GOVERNANCE-REGISTRY.md
- ENTERPRISE-GOVERNANCE-RECOVERY-MATRIX.md
- ENTERPRISE-GOVERNANCE-OWNERSHIP-MATRIX.md
- ENTERPRISE-GOVERNANCE-REVIEW-CYCLE.md
- ENTERPRISE-GOVERNANCE-CONTROLS.md
- PHASE-10-GOVERNANCE-READINESS-ASSESSMENT.md
- enterprise-governance-recovery-status.json
"@ | Set-Content $Protocol -Encoding UTF8

    @"
# ENTERPRISE GOVERNANCE PARAMETERS

ProjectRoot=$Root
PhaseRoot=$PhaseRoot
SourcePhaseCount=$($SourcePhases.Count)
MissingSourceCount=$($MissingSources.Count)
Phase11Locked=TRUE
NoDeleteRule=TRUE
NoManualCreationRule=TRUE
NoServiceRefactorRule=TRUE
GovernanceRecoveryRequired=TRUE
"@ | Set-Content $Parameters -Encoding UTF8

    @"
# ENTERPRISE GOVERNANCE RECOVERY BLUEPRINT

## Objective
Create the master governance control layer before Phase 10 final readiness audit.

## Governance Recovery Layers
- Documentation Governance
- SOP Governance
- Validation Governance
- Testing Governance
- Ownership Governance
- Review Cycle Governance
- Control Governance
- Readiness Governance

## Output
A complete enterprise governance recovery package that allows Phase 10 to proceed toward final readiness audit.
"@ | Set-Content $Blueprint -Encoding UTF8

    @"
# ENTERPRISE GOVERNANCE PROMPTS

Use these in future chats:

1. Continue Litigation 360 from Phase 10ZZ.4 Enterprise Governance Recovery.
2. Do not restart architecture.
3. Do not create new random Phase 10ZZ modules.
4. Preserve test and validation evidence.
5. Generate PowerShell-only deployment scripts unless CMD is specifically requested.
6. Include PASS/FAIL validation.
7. Keep Phase 11 locked until final readiness audit passes.
"@ | Set-Content $Prompts -Encoding UTF8

    @"
# ENTERPRISE GOVERNANCE CHECKS AND BALANCES

Mandatory Checks:
- Source phase existence check
- Registry generation check
- Matrix generation check
- Ownership generation check
- Review cycle generation check
- Controls generation check
- Monitoring JSON check
- Report generation check
- PASS/FAIL validation check
"@ | Set-Content $Checks -Encoding UTF8

    @"
# PHASE 10 GOVERNANCE READINESS ASSESSMENT

## Current Required Chain
| Phase | Purpose | Required Status |
|---|---|---|
| 10ZZ.0 | Documentation Governance | PASS / FOUND |
| 10ZZ1A | SOP Governance | PASS / FOUND |
| 10ZZ.2 | Validation Governance | PASS / FOUND |
| 10ZZ.3 | Testing Governance | PASS / FOUND |
| 10ZZ.4 | Enterprise Governance Recovery | GENERATED |

## Phase 11 Status
LOCKED

## Next Step
Run Phase 10 Final Readiness Audit after governance recovery passes.
"@ | Set-Content $Readiness -Encoding UTF8

    $Status = [ordered]@{
        phase = "10ZZ.4"
        name = "Enterprise Governance Recovery"
        projectRoot = $Root
        phaseRoot = $PhaseRoot
        sourcePhaseCount = $SourcePhases.Count
        missingSourceCount = $MissingSources.Count
        missingSources = $MissingSources
        status = if ($MissingSources.Count -eq 0) { "GENERATED" } else { "GENERATED_WITH_SOURCE_REVIEW_REQUIRED" }
        phase11Locked = $true
        generatedAt = (Get-Date).ToString("s")
        nextPhase = "Phase 10 Final Readiness Audit"
    }

    $Status | ConvertTo-Json -Depth 6 | Set-Content $Monitoring -Encoding UTF8

    @"
# PHASE 10ZZ.4 ENTERPRISE GOVERNANCE RECOVERY REPORT

Project Root:
$Root

Phase Root:
$PhaseRoot

Source Phases Checked:
$($SourcePhases.Count)

Missing Source Phases:
$($MissingSources.Count)

Generated:
- MASTER-ENTERPRISE-GOVERNANCE-REGISTRY.md
- ENTERPRISE-GOVERNANCE-RECOVERY-MATRIX.md
- ENTERPRISE-GOVERNANCE-OWNERSHIP-MATRIX.md
- ENTERPRISE-GOVERNANCE-REVIEW-CYCLE.md
- ENTERPRISE-GOVERNANCE-CONTROLS.md
- ENTERPRISE-GOVERNANCE-RECOVERY-PROTOCOL.md
- ENTERPRISE-GOVERNANCE-PARAMETERS.md
- ENTERPRISE-GOVERNANCE-RECOVERY-BLUEPRINT.md
- ENTERPRISE-GOVERNANCE-PROMPTS.md
- ENTERPRISE-GOVERNANCE-CHECKS-AND-BALANCES.md
- PHASE-10-GOVERNANCE-READINESS-ASSESSMENT.md
- enterprise-governance-recovery-status.json

Result:
GENERATED - VERIFY REQUIRED

Next Recommended Phase:
Phase 10 Final Readiness Audit
"@ | Set-Content $Report -Encoding UTF8

    "Phase 10ZZ.4 generated at $(Get-Date)" | Set-Content $Log -Encoding UTF8

    Write-Step "Generation complete."
}

function Invoke-Verify {
    Write-Step "Verifying enterprise governance recovery..."

    $Failures = @()

    foreach ($Folder in $Folders) {
        $Path = Join-Path $PhaseRoot $Folder
        if (!(Test-Path $Path)) {
            $Failures += "Missing folder: $Path"
        }
    }

    $RequiredFiles = @(
        "registry\MASTER-ENTERPRISE-GOVERNANCE-REGISTRY.md",
        "matrices\ENTERPRISE-GOVERNANCE-RECOVERY-MATRIX.md",
        "ownership\ENTERPRISE-GOVERNANCE-OWNERSHIP-MATRIX.md",
        "review-cycles\ENTERPRISE-GOVERNANCE-REVIEW-CYCLE.md",
        "controls\ENTERPRISE-GOVERNANCE-CONTROLS.md",
        "protocols\ENTERPRISE-GOVERNANCE-RECOVERY-PROTOCOL.md",
        "parameters\ENTERPRISE-GOVERNANCE-PARAMETERS.md",
        "blueprints\ENTERPRISE-GOVERNANCE-RECOVERY-BLUEPRINT.md",
        "prompts\ENTERPRISE-GOVERNANCE-PROMPTS.md",
        "checks-and-balances\ENTERPRISE-GOVERNANCE-CHECKS-AND-BALANCES.md",
        "readiness\PHASE-10-GOVERNANCE-READINESS-ASSESSMENT.md",
        "monitoring\enterprise-governance-recovery-status.json",
        "evidence\GOVERNANCE-SOURCE-PHASES.txt",
        "reports\PHASE-10ZZ4-ENTERPRISE-GOVERNANCE-RECOVERY-REPORT.md",
        "logs\PHASE-10ZZ4.log"
    )

    foreach ($File in $RequiredFiles) {
        $Path = Join-Path $PhaseRoot $File
        if (!(Test-Path $Path)) {
            $Failures += "Missing required file: $File"
        }
    }

    foreach ($Source in $SourcePhases) {
        $SourcePath = Join-Path $Root $Source
        if (!(Test-Path $SourcePath)) {
            $Failures += "Missing source governance phase: $Source"
        }
    }

    $ValidationPath = Join-Path $PhaseRoot "validation\PHASE-10ZZ4-VALIDATION-RESULT.md"

    if ($Failures.Count -eq 0) {
        @"
# PHASE 10ZZ.4 VALIDATION RESULT

Result:
PASS

Governance Recovery:
COMPLETE

Validation Time:
$(Get-Date)

Next Recommended Phase:
Phase 10 Final Readiness Audit
"@ | Set-Content $ValidationPath -Encoding UTF8

        Write-Host ""
        Write-Host "========================================"
        Write-Host "PHASE 10ZZ.4 ENTERPRISE GOVERNANCE RECOVERY: PASS"
        Write-Host "Next: Phase 10 Final Readiness Audit"
        Write-Host "========================================"
        Write-Host ""
        exit 0
    }
    else {
        @"
# PHASE 10ZZ.4 VALIDATION RESULT

Result:
FAIL

Failures:
$($Failures -join "`n")

Validation Time:
$(Get-Date)

Action:
Do not proceed to Phase 11.
Fix governance recovery failures and re-run verification.
"@ | Set-Content $ValidationPath -Encoding UTF8

        Write-Host ""
        Write-Host "========================================"
        Write-Host "PHASE 10ZZ.4 ENTERPRISE GOVERNANCE RECOVERY: FAIL"
        Write-Host "Failure Count: $($Failures.Count)"
        Write-Host "========================================"
        $Failures | ForEach-Object { Write-Host "- $_" }
        Write-Host ""
        exit 1
    }
}

if (!(Test-Path $Root)) {
    throw "Project root not found: $Root"
}

Set-Location $Root

if ($Mode -eq "PLAN") {
    Write-Step "PLAN mode selected."
    Write-Host "Will create: $PhaseRoot"
    Write-Host "Will consolidate documentation, SOP, validation, and testing governance."
    exit 0
}

if ($Mode -eq "APPLY") {
    Invoke-Apply
    Invoke-Verify
}

if ($Mode -eq "VERIFY") {
    Invoke-Verify
}
