param(
    [ValidateSet("PLAN","APPLY","VERIFY")]
    [string]$Mode = "APPLY"
)

$ErrorActionPreference = "Stop"

$Root = "C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software"
$PhaseRoot = Join-Path $Root "_operations\phase-11-0-enterprise-transition-control"

$Folders = @(
    "charter",
    "roadmap",
    "protocols",
    "parameters",
    "blueprints",
    "prompts",
    "checks-and-balances",
    "verification",
    "testing",
    "monitoring",
    "reports",
    "registry",
    "matrices",
    "governance",
    "logs",
    "evidence",
    "validation",
    "backups"
)

$RequiredPhase10Evidence = @(
    "_operations\phase-10ZZ1A-enterprise-sop-library\validation\PHASE-10ZZ1A-VALIDATION-RESULT.md",
    "_operations\phase-10ZZ2-validation-governance-audit\validation\PHASE-10ZZ2-VALIDATION-RESULT.md",
    "_operations\phase-10ZZ3-testing-governance-audit\validation\PHASE-10ZZ3-VALIDATION-RESULT.md",
    "_operations\phase-10ZZ4-enterprise-governance-recovery\validation\PHASE-10ZZ4-VALIDATION-RESULT.md"
)

function Write-Step($Message) {
    Write-Host "[PHASE 11.0] $Message"
}

function New-SafeFolder($Path) {
    if (!(Test-Path $Path)) {
        New-Item -ItemType Directory -Path $Path -Force | Out-Null
    }
}

function Invoke-Apply {
    Write-Step "Creating Phase 11.0 Enterprise Transition Control..."

    New-SafeFolder $PhaseRoot

    foreach ($Folder in $Folders) {
        New-SafeFolder (Join-Path $PhaseRoot $Folder)
    }

    $MissingEvidence = @()

    foreach ($Evidence in $RequiredPhase10Evidence) {
        $Path = Join-Path $Root $Evidence
        if (!(Test-Path $Path)) {
            $MissingEvidence += $Evidence
        }
    }

    @"
# PHASE 11.0 ENTERPRISE TRANSITION CHARTER

## Purpose
Phase 11.0 formally transitions Litigation 360 from Phase 10 governance recovery into controlled enterprise expansion.

## Rule
Phase 11 does not mean uncontrolled feature creation.

Phase 11 must proceed only through:
- documented scope
- controlled execution
- governance approval
- testing
- validation
- monitoring
- rollback planning
- certification evidence

## Phase 11 Starting Position
Phase 10 governance chain has been reported as passed.

## Immediate Phase 11 Objective
Create controlled execution readiness before implementing new enterprise ecosystem modules.

## Phase 11 Priority Order
1. Security hardening
2. Document management completion
3. Communication layer
4. Commercial compliance
5. Repository consolidation
6. Client portal
7. Finance / billing
8. Knowledge graph
9. AI only after data foundation is stable
"@ | Set-Content (Join-Path $PhaseRoot "charter\PHASE-11-ENTERPRISE-TRANSITION-CHARTER.md") -Encoding UTF8

    @"
# PHASE 11 EXECUTION ROADMAP

## Phase 11.0
Enterprise Transition Control

## Phase 11.1
Security Hardening Readiness

## Phase 11.2
Document Management Operationalisation

## Phase 11.3
Communications Hub Foundation

## Phase 11.4
Commercial Audit & Compliance Completion

## Phase 11.5
Repository Consolidation Completion

## Phase 11.6
Pilot Deployment Readiness

## Phase 11.7
Ground Zero Law Firm Controlled Pilot

## Phase 11.8
Pilot Feedback & Stabilisation

## Phase 11.9
Phase 11 Certification Audit
"@ | Set-Content (Join-Path $PhaseRoot "roadmap\PHASE-11-ROADMAP.md") -Encoding UTF8

    @"
# PHASE 11 EXECUTION PROTOCOL

## Mandatory Protocols
1. No new module without scope document.
2. No route without test.
3. No frontend page without backend/API mapping.
4. No admin function without audit trail.
5. No client data without security controls.
6. No pilot deployment without rollback plan.
7. No AI feature before document and data governance are stable.
8. No commercial restriction on Ground Zero.
9. No manual undocumented changes.
10. No Phase 11 subphase closes without PASS validation.
"@ | Set-Content (Join-Path $PhaseRoot "protocols\PHASE-11-EXECUTION-PROTOCOL.md") -Encoding UTF8

    @"
# PHASE 11 PARAMETERS

ProjectRoot=$Root
PhaseRoot=$PhaseRoot
Phase=11.0
Mode=EnterpriseTransitionControl
Phase10EvidenceRequired=TRUE
NoDeleteRule=TRUE
NoManualCreationRule=TRUE
GroundZeroProtected=TRUE
SecurityFirst=TRUE
DocumentManagementSecond=TRUE
AIRestrictedUntilDataReady=TRUE
PilotBeforeRollout=TRUE
"@ | Set-Content (Join-Path $PhaseRoot "parameters\PHASE-11-PARAMETERS.md") -Encoding UTF8

    @"
# PHASE 11 BLUEPRINT

## Architecture Direction
Litigation 360 must proceed from Legal Practice Operating System toward Enterprise Legal Practice Operating System.

## Controlled Build Layers
- Security Layer
- Document Layer
- Communication Layer
- Compliance Layer
- Commercial Layer
- Pilot Deployment Layer
- Client Experience Layer
- Intelligence Layer

## Execution Pattern
Each Phase 11 subphase must generate:
- folders
- documentation
- protocol
- parameters
- backend files where applicable
- frontend files where applicable
- validation scripts
- test scripts
- monitoring files
- reports
- PASS/FAIL output
"@ | Set-Content (Join-Path $PhaseRoot "blueprints\PHASE-11-BLUEPRINT.md") -Encoding UTF8

    @"
# PHASE 11 OPERATOR PROMPTS

Use these prompts in the next steps:

1. Continue Litigation 360 from Phase 11.0 Enterprise Transition Control.
2. Do not restart architecture.
3. Do not create random features.
4. Start with Phase 11.1 Security Hardening Readiness.
5. Provide ready-to-run PowerShell only.
6. Include folders, files, reports, validation, testing, monitoring, checks and balances, and PASS/FAIL output.
7. Preserve Ground Zero unlimited access.
8. Do not delete files.
9. Do not refactor services unless the phase specifically authorizes it.
"@ | Set-Content (Join-Path $PhaseRoot "prompts\PHASE-11-PROMPTS.md") -Encoding UTF8

    @"
# PHASE 11 CHECKS AND BALANCES

## Required Checks
- Phase 10 evidence check
- Folder creation check
- Charter generation check
- Roadmap generation check
- Protocol generation check
- Parameter generation check
- Blueprint generation check
- Prompt generation check
- Monitoring generation check
- Report generation check
- PASS/FAIL validation check

## Stop Conditions
Stop if:
- Phase 10 evidence is missing
- Security prerequisites are absent
- Ground Zero protection is violated
- Any validation fails
- Any test fails
- Manual risky change is required
"@ | Set-Content (Join-Path $PhaseRoot "checks-and-balances\PHASE-11-CHECKS-AND-BALANCES.md") -Encoding UTF8

    @"
# PHASE 11 TESTING FRAMEWORK

## Minimum Testing Expectations
Every Phase 11 subphase must include:
- file existence tests
- route existence tests where applicable
- API response tests where applicable
- configuration tests
- governance tests
- regression tests
- monitoring tests
- PASS/FAIL result

## Pilot Requirement
Before full rollout, test with Ground Zero only.
"@ | Set-Content (Join-Path $PhaseRoot "testing\PHASE-11-TESTING-FRAMEWORK.md") -Encoding UTF8

    @"
# PHASE 11 VERIFICATION FRAMEWORK

## Verification Requirements
Each subphase must verify:
- expected files created
- required folders created
- governance documents created
- validation result generated
- monitoring status generated
- report generated
- no prohibited operation occurred

## Result Format
PASS or FAIL only.
"@ | Set-Content (Join-Path $PhaseRoot "verification\PHASE-11-VERIFICATION-FRAMEWORK.md") -Encoding UTF8

    @"
# PHASE 11 MASTER REGISTRY

| Phase | Name | Status |
|---|---|---|
| 11.0 | Enterprise Transition Control | GENERATED |
| 11.1 | Security Hardening Readiness | PENDING |
| 11.2 | Document Management Operationalisation | PENDING |
| 11.3 | Communications Hub Foundation | PENDING |
| 11.4 | Commercial Audit & Compliance Completion | PENDING |
| 11.5 | Repository Consolidation Completion | PENDING |
| 11.6 | Pilot Deployment Readiness | PENDING |
| 11.7 | Ground Zero Pilot | PENDING |
| 11.8 | Pilot Feedback & Stabilisation | PENDING |
| 11.9 | Phase 11 Certification Audit | PENDING |
"@ | Set-Content (Join-Path $PhaseRoot "registry\PHASE-11-MASTER-REGISTRY.md") -Encoding UTF8

    @"
# PHASE 11 CONTROL MATRIX

| Control Area | Required | Status |
|---|---:|---|
| Security First | Yes | ACTIVE |
| Document Management Before AI | Yes | ACTIVE |
| Ground Zero Protection | Yes | ACTIVE |
| Testing Per Subphase | Yes | ACTIVE |
| Monitoring Per Subphase | Yes | ACTIVE |
| PASS/FAIL Validation | Yes | ACTIVE |
| Pilot Before Rollout | Yes | ACTIVE |
| No Random Feature Expansion | Yes | ACTIVE |
"@ | Set-Content (Join-Path $PhaseRoot "matrices\PHASE-11-CONTROL-MATRIX.md") -Encoding UTF8

    $Status = [ordered]@{
        phase = "11.0"
        name = "Enterprise Transition Control"
        projectRoot = $Root
        phaseRoot = $PhaseRoot
        phase10EvidenceRequired = $RequiredPhase10Evidence.Count
        missingPhase10Evidence = $MissingEvidence.Count
        missingEvidence = $MissingEvidence
        status = if ($MissingEvidence.Count -eq 0) { "GENERATED" } else { "GENERATED_WITH_MISSING_PHASE10_EVIDENCE" }
        generatedAt = (Get-Date).ToString("s")
        nextPhase = "Phase 11.1 Security Hardening Readiness"
    }

    $Status | ConvertTo-Json -Depth 6 | Set-Content (Join-Path $PhaseRoot "monitoring\phase-11-transition-status.json") -Encoding UTF8

    @"
# PHASE 11.0 ENTERPRISE TRANSITION CONTROL REPORT

Project Root:
$Root

Phase Root:
$PhaseRoot

Missing Phase 10 Evidence:
$($MissingEvidence.Count)

Generated:
- Phase 11 Charter
- Phase 11 Roadmap
- Phase 11 Protocol
- Phase 11 Parameters
- Phase 11 Blueprint
- Phase 11 Prompts
- Phase 11 Checks and Balances
- Phase 11 Testing Framework
- Phase 11 Verification Framework
- Phase 11 Master Registry
- Phase 11 Control Matrix
- Phase 11 Monitoring Status

Next Recommended Phase:
Phase 11.1 Security Hardening Readiness

Result:
GENERATED - VERIFY REQUIRED
"@ | Set-Content (Join-Path $PhaseRoot "reports\PHASE-11-0-ENTERPRISE-TRANSITION-CONTROL-REPORT.md") -Encoding UTF8

    "Phase 11.0 generated at $(Get-Date)" | Set-Content (Join-Path $PhaseRoot "logs\PHASE-11-0.log") -Encoding UTF8

    Write-Step "Generation complete."
}

function Invoke-Verify {
    Write-Step "Verifying Phase 11.0..."

    $Failures = @()

    foreach ($Folder in $Folders) {
        $Path = Join-Path $PhaseRoot $Folder
        if (!(Test-Path $Path)) {
            $Failures += "Missing folder: $Path"
        }
    }

    $RequiredFiles = @(
        "charter\PHASE-11-ENTERPRISE-TRANSITION-CHARTER.md",
        "roadmap\PHASE-11-ROADMAP.md",
        "protocols\PHASE-11-EXECUTION-PROTOCOL.md",
        "parameters\PHASE-11-PARAMETERS.md",
        "blueprints\PHASE-11-BLUEPRINT.md",
        "prompts\PHASE-11-PROMPTS.md",
        "checks-and-balances\PHASE-11-CHECKS-AND-BALANCES.md",
        "testing\PHASE-11-TESTING-FRAMEWORK.md",
        "verification\PHASE-11-VERIFICATION-FRAMEWORK.md",
        "registry\PHASE-11-MASTER-REGISTRY.md",
        "matrices\PHASE-11-CONTROL-MATRIX.md",
        "monitoring\phase-11-transition-status.json",
        "reports\PHASE-11-0-ENTERPRISE-TRANSITION-CONTROL-REPORT.md",
        "logs\PHASE-11-0.log"
    )

    foreach ($File in $RequiredFiles) {
        $Path = Join-Path $PhaseRoot $File
        if (!(Test-Path $Path)) {
            $Failures += "Missing required file: $File"
        }
    }

    foreach ($Evidence in $RequiredPhase10Evidence) {
        $Path = Join-Path $Root $Evidence
        if (!(Test-Path $Path)) {
            $Failures += "Missing Phase 10 evidence: $Evidence"
        }
    }

    $ValidationPath = Join-Path $PhaseRoot "validation\PHASE-11-0-VALIDATION-RESULT.md"

    if ($Failures.Count -eq 0) {
        @"
# PHASE 11.0 VALIDATION RESULT

Result:
PASS

Phase:
11.0 Enterprise Transition Control

Validation Time:
$(Get-Date)

Next Recommended Phase:
Phase 11.1 Security Hardening Readiness
"@ | Set-Content $ValidationPath -Encoding UTF8

        Write-Host ""
        Write-Host "========================================"
        Write-Host "PHASE 11.0 ENTERPRISE TRANSITION CONTROL: PASS"
        Write-Host "Next: Phase 11.1 Security Hardening Readiness"
        Write-Host "========================================"
        Write-Host ""
        exit 0
    }
    else {
        @"
# PHASE 11.0 VALIDATION RESULT

Result:
FAIL

Failures:
$($Failures -join "`n")

Validation Time:
$(Get-Date)

Action:
Do not proceed to Phase 11.1 until failures are fixed.
"@ | Set-Content $ValidationPath -Encoding UTF8

        Write-Host ""
        Write-Host "========================================"
        Write-Host "PHASE 11.0 ENTERPRISE TRANSITION CONTROL: FAIL"
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
    exit 0
}

if ($Mode -eq "APPLY") {
    Invoke-Apply
    Invoke-Verify
}

if ($Mode -eq "VERIFY") {
    Invoke-Verify
}

