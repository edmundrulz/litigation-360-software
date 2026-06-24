param(
    [ValidateSet("PLAN","APPLY")]
    [string]$Mode = "PLAN"
)

$ErrorActionPreference = "Stop"

$Root = "C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software"
$Out = Join-Path $Root "_operations\phase-10ZZ1A-enterprise-sop-library"

function Ensure-Folder {
    param([string]$Path)
    if (!(Test-Path -LiteralPath $Path)) {
        New-Item -ItemType Directory -Path $Path -Force | Out-Null
    }
}

function Write-Text {
    param([string]$Path, [string]$Content)
    Ensure-Folder -Path (Split-Path $Path -Parent)
    $Content | Out-File -LiteralPath $Path -Encoding UTF8 -Force
}

function Write-Title {
    param([string]$Text)
    Write-Host ""
    Write-Host "===================================================="
    Write-Host $Text
    Write-Host "===================================================="
}

Write-Title "PHASE 10ZZ1A ENTERPRISE SOP FACTORY V2"

if (!(Test-Path -LiteralPath $Root)) {
    throw "Project root not found: $Root"
}

$Folders = @(
    "sops",
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
    "docs",
    "validation",
    "logs",
    "backups"
)

foreach ($Folder in $Folders) {
    Ensure-Folder -Path (Join-Path $Out $Folder)
}

$SopsJson = @'
[
  {
    "Domain": "Foundation",
    "File": "FOUNDATION-OPERATIONS-SOP.md",
    "Purpose": "Control project foundation, setup, structure, environment readiness and base operating rules."
  },
  {
    "Domain": "RBAC",
    "File": "RBAC-ACCESS-CONTROL-SOP.md",
    "Purpose": "Control roles, permissions, access reviews and privilege escalation."
  },
  {
    "Domain": "Client Intake",
    "File": "CLIENT-INTAKE-SOP.md",
    "Purpose": "Control client onboarding, intake, conflict checking and client data capture."
  },
  {
    "Domain": "Matter Management",
    "File": "MATTER-MANAGEMENT-SOP.md",
    "Purpose": "Control matter creation, assignment, lifecycle tracking and closure."
  },
  {
    "Domain": "Document Lifecycle",
    "File": "DOCUMENT-LIFECYCLE-SOP.md",
    "Purpose": "Control document creation, upload, review, versioning, retention and archiving."
  },
  {
    "Domain": "Court Operations",
    "File": "COURT-OPERATIONS-SOP.md",
    "Purpose": "Control court filing, attendance, deadlines, hearing preparation and court event tracking."
  },
  {
    "Domain": "Industrial Court",
    "File": "INDUSTRIAL-COURT-SOP.md",
    "Purpose": "Control Industrial Court Kuala Lumpur workflows, hearing reminders, filing deadlines and attendance readiness."
  },
  {
    "Domain": "PERKESO",
    "File": "PERKESO-SOP.md",
    "Purpose": "Control PERKESO Kuala Lumpur / Jalan Tun Razak and PERKESO Headquarters / Jalan Ampang workflows."
  },
  {
    "Domain": "Navigation",
    "File": "COURT-NAVIGATION-SOP.md",
    "Purpose": "Control Google Maps, Waze, route planning, departure reminders and court navigation readiness."
  },
  {
    "Domain": "Billing",
    "File": "BILLING-FINANCE-SOP.md",
    "Purpose": "Control billing, invoice, payment, finance audit trail and financial operating checks."
  },
  {
    "Domain": "Executive Operations",
    "File": "EXECUTIVE-OPERATIONS-SOP.md",
    "Purpose": "Control executive dashboard, reporting, decision escalation and management visibility."
  },
  {
    "Domain": "Deployment",
    "File": "DEPLOYMENT-SOP.md",
    "Purpose": "Control deployment readiness, release checks, gatekeeper validation and rollback readiness."
  },
  {
    "Domain": "Monitoring",
    "File": "MONITORING-SOP.md",
    "Purpose": "Control health checks, metrics, dashboards, performance monitoring and operational visibility."
  },
  {
    "Domain": "Alert & Escalation",
    "File": "ALERT-ESCALATION-SOP.md",
    "Purpose": "Control alert creation, severity, escalation, notifications and resolution."
  },
  {
    "Domain": "Analytics",
    "File": "ANALYTICS-SOP.md",
    "Purpose": "Control analytics dashboard, metrics review, insight reporting and performance evidence."
  },
  {
    "Domain": "Predictive Intelligence",
    "File": "PREDICTIVE-INTELLIGENCE-SOP.md",
    "Purpose": "Control prediction, risk scoring, forecasting, trend analysis and executive recommendations."
  },
  {
    "Domain": "Security",
    "File": "SECURITY-SOP.md",
    "Purpose": "Control security hardening, audit, access safety, sensitive operations and incident handling."
  },
  {
    "Domain": "Testing",
    "File": "TESTING-SOP.md",
    "Purpose": "Control smoke, regression, integration, API, frontend, security, performance and recovery testing."
  },
  {
    "Domain": "Validation",
    "File": "VALIDATION-SOP.md",
    "Purpose": "Control validation scripts, evidence reports, PASS/FAIL gates and deployment verification."
  },
  {
    "Domain": "Training",
    "File": "TRAINING-SOP.md",
    "Purpose": "Control training material, operator onboarding, user manuals and knowledge transfer."
  },
  {
    "Domain": "Governance",
    "File": "GOVERNANCE-SOP.md",
    "Purpose": "Control governance ownership, risk, compliance, approval, audit and exception management."
  }
]
'@

$Sops = $SopsJson | ConvertFrom-Json

if ($Mode -eq "PLAN") {
    Write-Host "PLAN MODE ONLY. Folders created, SOP files not generated."
    Write-Host "Run with -Mode APPLY to generate the SOP library."
    Read-Host "Press Enter to close"
    exit 0
}

$SopTemplate = @'
# {{FILE}}

## Status
Generated by Phase 10ZZ1A Enterprise SOP Factory V2.

## Domain
{{DOMAIN}}

## Purpose
{{PURPOSE}}

## Scope
This SOP applies to Litigation 360 operators, administrators, technical maintainers, governance reviewers and executive reviewers handling this domain.

## File And Folder Path

```cmd
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\_operations\phase-10ZZ1A-enterprise-sop-library\sops\{{FILE}}
```

## Inputs

- Existing source files
- Existing documentation
- Existing backend routes
- Existing automation engines
- Existing frontend pages
- Existing operations reports
- Existing validation reports
- Existing test reports
- Operator request or system event
- Governance requirement

## Outputs

- Completed operational action
- Updated report
- Updated log
- Updated registry entry
- Validation evidence
- Test evidence where applicable
- Escalation record where applicable

## Parameters

| Parameter | Value |
|---|---|
| Priority | HIGH |
| Review Cycle | 30 days during active build |
| Evidence Required | Yes |
| Validation Required | Yes |
| Test Required | Where applicable |
| Escalation Required | On failure, blocker, missed deadline, security issue or data integrity risk |
| Destructive Action Allowed | No, unless separately approved |
| Phase 11 Gate Relevance | Required before Phase 11 |

## Rules

1. Confirm project root before executing commands.
2. Do not manually create files if an automated script exists.
3. Preserve evidence under `_operations`.
4. Run validation after SOP-driven changes.
5. Generate reports for changed, repaired or failed processes.
6. Do not delete clients, matters, documents, databases or source files without executive approval.
7. Preserve Industrial Court Kuala Lumpur coverage.
8. Preserve PERKESO Kuala Lumpur / Jalan Tun Razak coverage.
9. Preserve PERKESO Headquarters / Jalan Ampang coverage.
10. Preserve Google Maps, Waze and court navigation readiness.
11. Failed validation blocks phase progression.
12. HIGH priority unresolved issues require escalation.

## Process

### Step 1 — Confirm Project Root

```cmd
cd /d "C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software"
```

PowerShell equivalent:

```powershell
Set-Location "C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software"
```

### Step 2 — Confirm Required Folders

```cmd
dir "_operations"
dir "backend"
dir "frontend"
```

### Step 3 — Identify Domain Evidence

Review related routes, automation engines, frontend pages, documentation, validations, tests and reports.

### Step 4 — Execute Approved Action

Only perform actions that are documented, repeatable, reversible where possible, validated and logged.

### Step 5 — Generate Evidence

Store evidence under:

```cmd
_operations\phase-10ZZ1A-enterprise-sop-library\reports
```

### Step 6 — Validate

Run validation checks and confirm PASS or FAIL.

### Step 7 — Escalate If Needed

Escalate on validation failure, missing file, endpoint failure, report failure, data integrity risk or deadline risk.

## Checks And Balances

| Check | Required |
|---|---|
| Project root confirmed | Yes |
| Folder path confirmed | Yes |
| Evidence created | Yes |
| Validation performed | Yes |
| Report generated | Yes |
| Operator checklist completed | Yes |
| Escalation triggered on failure | Yes |

## Verification

1. SOP exists.
2. SOP is listed in MASTER-SOP-LIBRARY-INDEX.md.
3. SOP is listed in SOP-OWNERSHIP-MATRIX.md.
4. SOP has review cycle.
5. SOP has evidence path.
6. SOP has validation rules.
7. SOP has escalation path.

## Testing

1. File existence test.
2. Registry inclusion test.
3. Checklist completeness test.
4. Evidence path test.
5. Validation report test.

## Real-Time / Live Monitoring Requirement

Where endpoints or dashboards exist, monitor health, metrics, dashboard output, alert status, validation reports and performance reports.
If no live endpoint exists, use report-based monitoring under `_operations`.

## Prompts For Operator Use

```text
Apply the {{DOMAIN}} SOP. Confirm project root, create backups where needed, generate evidence, run validation, produce PASS/FAIL report, and do not perform destructive actions without approval.
```

```text
Review the {{DOMAIN}} SOP failure. Identify failed step, affected file path, missing evidence, validation status, recovery action, escalation owner and next command to run.
```

## Operator Checklist

- [ ] Project root confirmed
- [ ] Relevant files identified
- [ ] Related documentation checked
- [ ] Related routes checked where applicable
- [ ] Related automation checked where applicable
- [ ] Evidence folder confirmed
- [ ] Process executed
- [ ] Validation completed
- [ ] Test evidence captured where applicable
- [ ] Report generated
- [ ] Escalation created if required
- [ ] SOP index updated

## Escalation Path

Operations Owner -> Technical Owner -> Governance Owner -> Executive Owner

## Recovery Action

If this SOP cannot be completed, stop the process, preserve console output, preserve logs, create an issue report, escalate to Technical Owner and do not continue to the next phase until resolved.

## Evidence / Report Path

```cmd
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\_operations\phase-10ZZ1A-enterprise-sop-library\reports
```
'@

foreach ($Item in $Sops) {
    $Content = $SopTemplate
    $Content = $Content.Replace("{{FILE}}", $Item.File)
    $Content = $Content.Replace("{{DOMAIN}}", $Item.Domain)
    $Content = $Content.Replace("{{PURPOSE}}", $Item.Purpose)
    Write-Text -Path (Join-Path $Out ("sops\" + $Item.File)) -Content $Content
}

$IndexRows = @()
foreach ($Item in $Sops) {
    $IndexRows += "| $($Item.Domain) | $($Item.File) | HIGH | 30 days | Operations Owner | Technical Owner | Governance Owner |"
}

$Index = @"
# MASTER SOP LIBRARY INDEX

## Phase
10ZZ1A Enterprise SOP Factory V2

## Purpose
Provide a complete index of enterprise SOPs required before Phase 11.

## SOP Library Path

```cmd
C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\_operations\phase-10ZZ1A-enterprise-sop-library\sops
```

## SOP Index

| Domain | SOP File | Priority | Review Cycle | Primary Owner | Technical Owner | Governance Owner |
|---|---|---|---|---|---|---|
$($IndexRows -join "`r`n")

## Gate Rule
All SOPs must exist before 10ZZ.2 Validation Governance Audit proceeds.
"@

Write-Text -Path (Join-Path $Out "registry\MASTER-SOP-LIBRARY-INDEX.md") -Content $Index

$OwnershipRows = @()
foreach ($Item in $Sops) {
    $OwnershipRows += "| $($Item.Domain) | $($Item.File) | Operations Owner | Technical Owner | Governance Owner | Executive Owner |"
}

$Ownership = @"
# SOP OWNERSHIP MATRIX

| Domain | SOP File | Primary Owner | Technical Owner | Governance Owner | Executive Escalation |
|---|---|---|---|---|---|
$($OwnershipRows -join "`r`n")
"@

Write-Text -Path (Join-Path $Out "matrices\SOP-OWNERSHIP-MATRIX.md") -Content $Ownership

$Review = @'
# SOP REVIEW SCHEDULE

| Review Type | Frequency |
|---|---|
| Active build phase SOP review | Every 30 days |
| Pre-deployment review | Before each major deployment |
| Incident-driven review | After failed validation or production-impacting issue |
| Phase gate review | Before Phase 11 |

## Checklist

- [ ] SOP still matches current route structure
- [ ] SOP still matches current automation engines
- [ ] SOP still matches current operations folders
- [ ] Validation section current
- [ ] Testing section current
- [ ] Escalation path current
- [ ] Evidence path current
'@

Write-Text -Path (Join-Path $Out "docs\SOP-REVIEW-SCHEDULE.md") -Content $Review

$Protocol = @"
# ENTERPRISE SOP FACTORY PROTOCOL

## Purpose
Generate and govern missing enterprise SOPs before Phase 11.

## Scope
Covers missing SOPs identified by Phase 10ZZ.1 and creates a consolidated SOP library.

## Inputs

- MISSING-SOPS.md from Phase 10ZZ.1
- Metadata inventory from Phase 10ZY.1
- Documentation governance output from Phase 10ZZ.0

## Outputs

- SOP files
- Master SOP Library Index
- SOP Ownership Matrix
- SOP Review Schedule
- Validation report

## Parameters

| Parameter | Value |
|---|---|
| Project Root | $Root |
| SOP Library Root | $Out |
| SOP Count Target | $($Sops.Count) |
| Review Cycle | 30 days |
| Phase 11 Gate Dependency | Yes |

## Rules

1. Do not proceed to 10ZZ.2 until SOP files exist.
2. Every SOP must contain purpose, scope, inputs, outputs, parameters, rules, process, validation, operator checklist, escalation path, recovery action and evidence path.
3. Store all SOPs under `_operations`.
4. Index all generated SOPs.
5. Assign owner classes.

## Process

1. Confirm project root.
2. Create SOP library folders.
3. Generate SOP documents.
4. Generate index.
5. Generate ownership matrix.
6. Generate review schedule.
7. Run validation.
8. Print PASS/FAIL.
"@

Write-Text -Path (Join-Path $Out "protocols\ENTERPRISE-SOP-FACTORY-PROTOCOL.md") -Content $Protocol

$Parameters = @"
# SOP PARAMETERS

| Parameter | Value |
|---|---|
| Project Root | $Root |
| SOP Library Root | $Out |
| SOP Count Target | $($Sops.Count) |
| Review Cycle | 30 days |
| Validation Required | Yes |
| Testing Required | Yes |
| Evidence Required | Yes |
| Phase 11 Gate | Blocked until PASS |
"@

Write-Text -Path (Join-Path $Out "parameters\SOP-PARAMETERS.md") -Content $Parameters

$Blueprint = @'
# SOP LIBRARY BLUEPRINT

```cmd
_operations\phase-10ZZ1A-enterprise-sop-library
├── sops
├── protocols
├── parameters
├── blueprints
├── prompts
├── checks-and-balances
├── verification
├── testing
├── monitoring
├── reports
├── registry
├── matrices
├── docs
├── validation
├── logs
└── backups
```
'@

Write-Text -Path (Join-Path $Out "blueprints\SOP-LIBRARY-BLUEPRINT.md") -Content $Blueprint

$PromptLibrary = @'
# SOP PROMPT LIBRARY

## Create / Repair Prompt
Apply the relevant Litigation 360 SOP. Confirm project root, confirm folder paths, create backups if modifying files, generate evidence, run validation, print PASS/FAIL and provide report paths.

## Failure Review Prompt
Review this SOP failure. Identify failed line, failed file path, missing dependency, recovery action, validation command and next patch.

## Phase Gate Prompt
Confirm whether this phase can proceed. Check SOP coverage, validation coverage, test coverage, governance coverage, unresolved failures and required reports.
'@

Write-Text -Path (Join-Path $Out "prompts\SOP-PROMPT-LIBRARY.md") -Content $PromptLibrary

$Checks = @'
# SOP CHECKS AND BALANCES

- Project root check
- Folder existence check
- Evidence path check
- Validation report check
- SOP index check
- Ownership matrix check
- Review schedule check
- No destructive action without approval
- Phase gate block on failed validation
'@

Write-Text -Path (Join-Path $Out "checks-and-balances\SOP-CHECKS-AND-BALANCES.md") -Content $Checks

$Verification = @'
# SOP VERIFICATION PLAN

1. SOP files exist.
2. Master SOP index exists.
3. Ownership matrix exists.
4. Review schedule exists.
5. Protocol exists.
6. Parameter file exists.
7. Blueprint exists.
8. Prompt library exists.
9. Checks and balances file exists.
10. Testing plan exists.
11. Monitoring plan exists.
'@

Write-Text -Path (Join-Path $Out "verification\SOP-VERIFICATION-PLAN.md") -Content $Verification

$Testing = @"
# SOP TESTING PLAN

| Test | Expected |
|---|---|
| SOP file count | $($Sops.Count) |
| Index exists | true |
| Ownership matrix exists | true |
| Review schedule exists | true |
| Validation report generated | true |
"@

Write-Text -Path (Join-Path $Out "testing\SOP-TESTING-PLAN.md") -Content $Testing

$Monitoring = @"
# SOP MONITORING PLAN

| Metric | Target |
|---|---:|
| SOP Files | $($Sops.Count) |
| Indexed SOPs | $($Sops.Count) |
| Ownership Coverage | 100% |
| Review Schedule Coverage | 100% |
| Validation Status | PASS |
"@

Write-Text -Path (Join-Path $Out "monitoring\SOP-MONITORING-PLAN.md") -Content $Monitoring

$ValidationScript = @'
const fs = require("fs");
const path = require("path");

const root = process.env.L360_SOP_ROOT;
const files = process.env.L360_SOP_FILES.split("|");

const required = [
  ...files.map(f => "sops/" + f),
  "registry/MASTER-SOP-LIBRARY-INDEX.md",
  "matrices/SOP-OWNERSHIP-MATRIX.md",
  "docs/SOP-REVIEW-SCHEDULE.md",
  "protocols/ENTERPRISE-SOP-FACTORY-PROTOCOL.md",
  "parameters/SOP-PARAMETERS.md",
  "blueprints/SOP-LIBRARY-BLUEPRINT.md",
  "prompts/SOP-PROMPT-LIBRARY.md",
  "checks-and-balances/SOP-CHECKS-AND-BALANCES.md",
  "verification/SOP-VERIFICATION-PLAN.md",
  "testing/SOP-TESTING-PLAN.md",
  "monitoring/SOP-MONITORING-PLAN.md"
];

let pass = true;

for (const item of required) {
  const ok = fs.existsSync(path.join(root, item));
  console.log(`${item}: ${String(ok).toLowerCase()}`);
  if (!ok) pass = false;
}

console.log("");

if (pass) {
  console.log("PHASE 10ZZ1A ENTERPRISE SOP FACTORY STATUS: PASS");
  process.exit(0);
}

console.log("PHASE 10ZZ1A ENTERPRISE SOP FACTORY STATUS: FAIL");
process.exit(1);
'@

$ValidationPath = Join-Path $Out "validation\validate-sop-factory.js"
Write-Text -Path $ValidationPath -Content $ValidationScript

$env:L360_SOP_ROOT = $Out
$env:L360_SOP_FILES = (($Sops | ForEach-Object { $_.File }) -join "|")

Push-Location $Root
try {
    node $ValidationPath | Tee-Object -FilePath (Join-Path $Out "reports\PHASE-10ZZ1A-SOP-FACTORY-VALIDATION-REPORT.txt")
    if ($LASTEXITCODE -ne 0) {
        throw "SOP Factory validation failed."
    }
}
finally {
    Pop-Location
}

$Summary = @"
PHASE 10ZZ1A ENTERPRISE SOP FACTORY V2

Status: PASS

SOPs Generated: $($Sops.Count)

SOP Library:
$Out\sops

Generated:
$Out\registry\MASTER-SOP-LIBRARY-INDEX.md
$Out\matrices\SOP-OWNERSHIP-MATRIX.md
$Out\docs\SOP-REVIEW-SCHEDULE.md
$Out\protocols\ENTERPRISE-SOP-FACTORY-PROTOCOL.md
$Out\parameters\SOP-PARAMETERS.md
$Out\blueprints\SOP-LIBRARY-BLUEPRINT.md
$Out\prompts\SOP-PROMPT-LIBRARY.md
$Out\checks-and-balances\SOP-CHECKS-AND-BALANCES.md
$Out\verification\SOP-VERIFICATION-PLAN.md
$Out\testing\SOP-TESTING-PLAN.md
$Out\monitoring\SOP-MONITORING-PLAN.md
$Out\reports\PHASE-10ZZ1A-SOP-FACTORY-VALIDATION-REPORT.txt

Next Phase:
10ZZ.2 Validation Governance Audit
"@

Write-Text -Path (Join-Path $Out "reports\PHASE-10ZZ1A-SUMMARY.txt") -Content $Summary

Write-Title "PHASE 10ZZ1A ENTERPRISE SOP FACTORY STATUS: PASS"
Write-Host "Summary:"
Write-Host (Join-Path $Out "reports\PHASE-10ZZ1A-SUMMARY.txt")
Write-Host ""
Read-Host "Press Enter to close"
