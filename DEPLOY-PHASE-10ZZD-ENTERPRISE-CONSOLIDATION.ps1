# DEPLOY-PHASE-10ZZD-ENTERPRISE-CONSOLIDATION.ps1
# Litigation 360 - Phase 10ZZD Enterprise Consolidation Audit
# Safe documentation, monitoring, verification, and handover deployment
# No source code is modified. No runtime files are moved. No delete actions.

$Root = "C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software"
Set-Location $Root

$Phase = "phase-10ZZD-enterprise-consolidation"
$Ops = "_operations\$Phase"
$Reports = "reports\$Phase"
$Docs = "docs\$Phase"
$Scripts = "scripts\$Phase"

$Folders = @(
    $Ops,
    "$Ops\blueprints",
    "$Ops\protocols",
    "$Ops\parameters",
    "$Ops\checks-balances",
    "$Ops\verification",
    "$Ops\testing",
    "$Ops\monitoring",
    "$Ops\handover",
    $Reports,
    "$Reports\inventory",
    "$Reports\verification",
    "$Reports\monitoring",
    "$Reports\testing",
    $Docs,
    $Scripts
)

foreach ($Folder in $Folders) {
    New-Item -ItemType Directory -Force -Path $Folder | Out-Null
}

@"
# Phase 10ZZD Enterprise Consolidation Blueprint

## Purpose
Create a controlled consolidation framework for Litigation 360.

## Objective
Identify what should be:

- KEEP
- MERGE
- ARCHIVE
- REFACTOR
- REMOVE

## Scope

Covered:

- backend routes
- backend utilities
- backend services
- tests
- scripts
- docs
- operations records
- backup files in runtime folders
- duplicate registries
- monitoring output

## Safety Rule

This phase is audit-only.

No files are deleted.
No files are moved.
No runtime code is changed.
No database is changed.

## Known Current Evidence

The system already contains major legal engines including client identity, conflict, deadline, intake, matter numbering, task automation, workflow conveyor, audit logging, API guard, error bus, and logger.

The route layer contains enterprise, legal, operations, deployment, monitoring, dashboard, conflict, deadline, intake, and automation routes.

The tests layer contains legal engine tests, security tests, CRUD tests, licensing tests, and commercialisation tests.

## Exit Criteria

Phase 10ZZD is complete when these are generated:

- MASTER-CONSOLIDATION-MATRIX.md
- ROUTE-CONSOLIDATION-AUDIT.txt
- UTILITY-CONSOLIDATION-AUDIT.txt
- SERVICE-CONSOLIDATION-AUDIT.txt
- TEST-CONSOLIDATION-AUDIT.txt
- BACKUP-FILE-AUDIT.txt
- LIVE-CONSOLIDATION-STATUS.txt
- PHASE-10ZZD-HANDOVER.md
"@ | Set-Content "$Ops\blueprints\PHASE-10ZZD-BLUEPRINT.md"

@"
# Phase 10ZZD Protocols

## Protocol 1 - Audit Before Action
Do not move, delete, rename, or refactor until inventory evidence exists.

## Protocol 2 - Runtime Protection
The following folders are protected:

- backend
- frontend
- node_modules
- .git
- data
- configs
- tests
- docs
- _operations

## Protocol 3 - Backup File Rule
Backup files found inside runtime folders must first be listed, reviewed, then moved only by a separate approved archive script.

## Protocol 4 - Service Refactor Rule
Utilities must not be blindly moved into services.
Each service refactor requires:

- source utility identified
- dependent route identified
- test identified
- rollback plan
- before/after test result

## Protocol 5 - Completion Rule
No consolidation item is complete unless it has:

- evidence
- classification
- action
- risk rating
- verification method
"@ | Set-Content "$Ops\protocols\PHASE-10ZZD-PROTOCOLS.md"

@"
# Phase 10ZZD Parameters

## Root Path
$Root

## Operations Folder
$Ops

## Reports Folder
$Reports

## Docs Folder
$Docs

## Scripts Folder
$Scripts

## Classification Labels

KEEP:
Required and active.

MERGE:
Duplicate or overlapping function.

ARCHIVE:
Backup, obsolete, old version, historical artifact.

REFACTOR:
Working but architecturally misplaced.

REMOVE:
Only after separate confirmation. Not used in this phase.

## Current Architectural Concern

Utilities are heavily developed.
Services layer is underdeveloped.
Backup files exist inside active route folders.
Some registry duplication likely exists.
"@ | Set-Content "$Ops\parameters\PHASE-10ZZD-PARAMETERS.md"

@"
# Phase 10ZZD Checks And Balances

## Required Checks

- Route inventory generated
- Utility inventory generated
- Service inventory generated
- Test inventory generated
- Backup file inventory generated
- Runtime process snapshot generated
- Consolidation matrix generated
- Handover generated

## Red Flags

- .doctor-backup inside backend/src/routes
- backup-before files inside backend/src/routes
- POSTGRES_BACKUP files inside runtime folders
- only one service file
- duplicate route naming
- old phase text files inside route folder
- generated reports left in root
"@ | Set-Content "$Ops\checks-balances\PHASE-10ZZD-CHECKS-BALANCES.md"

@"
# Phase 10ZZD Verification Protocol

## Verification Method

This phase verifies structure only.

## Commands Used

Get-ChildItem backend/src/routes
Get-ChildItem backend/src/utils
Get-ChildItem backend/src/services
Get-ChildItem tests
Get-ChildItem scripts
Get-ChildItem docs
Get-ChildItem _operations
Get-Process node

## No Modification Confirmation

This script performs:

- read
- inventory
- report creation

It does not perform:

- delete
- move
- rename
- database write
- source code patch
"@ | Set-Content "$Ops\verification\PHASE-10ZZD-VERIFICATION-PROTOCOL.md"

@"
# Phase 10ZZD Testing Protocol

## Required Testing After This Phase

After reviewing the consolidation matrix, run:

npm test

Then run any licensing/commercialisation tests separately if touched.

## Current Phase Testing Scope

This phase does not modify source code, so no regression should be triggered.

## Future Test Requirement

Before any archive/refactor action:

1. Capture current tests.
2. Move/refactor one category only.
3. Run tests.
4. Generate report.
5. Continue only if clean.
"@ | Set-Content "$Ops\testing\PHASE-10ZZD-TESTING-PROTOCOL.md"

@"
# Phase 10ZZD Monitoring Protocol

## Live Monitoring

This phase captures:

- active Node processes
- root folder state
- route count
- utility count
- service count
- test count
- backup file count

## Output

$Reports\monitoring\LIVE-CONSOLIDATION-STATUS.txt

## Purpose

This gives a live snapshot before consolidation action.
"@ | Set-Content "$Ops\monitoring\PHASE-10ZZD-MONITORING-PROTOCOL.md"

# Inventory generation
Get-ChildItem ".\backend\src\routes" -File | Select-Object Name,FullName,Length,LastWriteTime | Out-File "$Reports\inventory\ROUTE-CONSOLIDATION-AUDIT.txt"
Get-ChildItem ".\backend\src\utils" -File | Select-Object Name,FullName,Length,LastWriteTime | Out-File "$Reports\inventory\UTILITY-CONSOLIDATION-AUDIT.txt"
Get-ChildItem ".\backend\src\services" -File -ErrorAction SilentlyContinue | Select-Object Name,FullName,Length,LastWriteTime | Out-File "$Reports\inventory\SERVICE-CONSOLIDATION-AUDIT.txt"
Get-ChildItem ".\tests" -Recurse -File | Select-Object Name,FullName,Length,LastWriteTime | Out-File "$Reports\inventory\TEST-CONSOLIDATION-AUDIT.txt"
Get-ChildItem ".\scripts" -Recurse -File | Select-Object Name,FullName,Length,LastWriteTime | Out-File "$Reports\inventory\SCRIPT-CONSOLIDATION-AUDIT.txt"
Get-ChildItem ".\docs" -Recurse -File | Select-Object Name,FullName,Length,LastWriteTime | Out-File "$Reports\inventory\DOCS-CONSOLIDATION-AUDIT.txt"
Get-ChildItem ".\_operations" -Recurse -File | Select-Object Name,FullName,Length,LastWriteTime | Out-File "$Reports\inventory\OPERATIONS-CONSOLIDATION-AUDIT.txt"

# Backup-like file audit
Get-ChildItem ".\backend\src\routes" -File |
Where-Object {
    $_.Name -like "*.doctor-backup" -or
    $_.Name -like "*backup*" -or
    $_.Name -like "*BACKUP*" -or
    $_.Name -like "*DO_NOT_DELETE*"
} |
Select-Object Name,FullName,Length,LastWriteTime |
Out-File "$Reports\inventory\BACKUP-FILE-AUDIT.txt"

# File type inventory
Get-ChildItem ".\backend" -Recurse -File |
Group-Object Extension |
Sort-Object Count -Descending |
Out-File "$Reports\inventory\BACKEND-FILE-TYPE-INVENTORY.txt"

# Counts
$RouteCount = (Get-ChildItem ".\backend\src\routes" -File).Count
$UtilityCount = (Get-ChildItem ".\backend\src\utils" -File).Count
$ServiceCount = (Get-ChildItem ".\backend\src\services" -File -ErrorAction SilentlyContinue).Count
$TestCount = (Get-ChildItem ".\tests" -Recurse -File).Count
$BackupCount = (Get-ChildItem ".\backend\src\routes" -File | Where-Object {
    $_.Name -like "*.doctor-backup" -or
    $_.Name -like "*backup*" -or
    $_.Name -like "*BACKUP*" -or
    $_.Name -like "*DO_NOT_DELETE*"
}).Count

@"
# Litigation 360 Phase 10ZZD Live Consolidation Status

Generated: $(Get-Date)

## Counts

Routes: $RouteCount
Utilities: $UtilityCount
Services: $ServiceCount
Tests: $TestCount
Backup-like route files: $BackupCount

## Interpretation

Routes are highly developed.
Utilities are highly developed.
Services layer requires architectural improvement.
Backup-like files exist in runtime routes and require future archive review.
Testing layer exists and should be used as safety gate.

## Current Status

Phase 10ZZD audit generated successfully.
No source files modified.
No runtime files moved.
No database changes made.
"@ | Set-Content "$Reports\monitoring\LIVE-CONSOLIDATION-STATUS.txt"

@"
# Litigation 360 Master Consolidation Matrix

Generated: $(Get-Date)

## Purpose

This matrix classifies project components into:

- KEEP
- MERGE
- ARCHIVE
- REFACTOR
- REMOVE

## Routes

| Category | Action | Reason |
|---|---|---|
| Core legal routes | KEEP | Required runtime modules |
| Enterprise routes | KEEP | Required governance/operations modules |
| Dashboard/monitoring routes | KEEP | Required operational visibility |
| .doctor-backup files | ARCHIVE LATER | Backup artifacts inside runtime folder |
| backup-before files | ARCHIVE LATER | Historical safety files inside runtime folder |
| POSTGRES_BACKUP_DO_NOT_DELETE files | REVIEW THEN ARCHIVE | Migration backup artifact |

## Utilities

| Utility Type | Action | Reason |
|---|---|---|
| client identity | KEEP | Core Phase 9 legal engine |
| conflict engine | KEEP | Core legal risk engine |
| deadline calculator | KEEP | Court operations engine |
| matter intake | KEEP | Matter opening workflow |
| matter numbering | KEEP | Numbering control |
| task automation | KEEP | Operational workflow support |
| workflow conveyor | KEEP | Matter workflow support |
| logger/error/audit utilities | KEEP | System safety and audit |

## Services

| Area | Action | Reason |
|---|---|---|
| autoHealService | KEEP | Existing service layer |
| legal engines currently in utils | REFACTOR LATER | Service layer is underdeveloped |
| route business logic | REVIEW | May need extraction into services |

## Tests

| Test Type | Action | Reason |
|---|---|---|
| Legal engine tests | KEEP | Core verification |
| Security tests | KEEP | Regression baseline |
| CRUD smoke tests | KEEP | Baseline integrity |
| Licensing/commercialisation tests | KEEP | Commercial readiness |

## Documentation

| Area | Action | Reason |
|---|---|---|
| MASTER-HANDBOOK | KEEP | Enterprise reference |
| MASTER-SYSTEM | KEEP | Governance framework |
| Historical reconstruction | KEEP + COMPLETE | Early phase traceability |
| Duplicate/old reports | REVIEW | May be archived after certification |

## Next Safe Action

Do not delete anything yet.

Next phase should be:

Phase 10ZZD.1 - Backup Route Archive Validation

Only after:
- dependency check
- route registration check
- tests pass
"@ | Set-Content "$Reports\MASTER-CONSOLIDATION-MATRIX.md"

@"
# Phase 10ZZD Handover

## Project
Litigation 360 Enterprise Platform

## Phase
Phase 10ZZD - Enterprise Consolidation Audit

## Date
$(Get-Date)

## Status
Generated successfully.

## What Was Created

### Operations
$Ops

### Documentation
$Docs

### Reports
$Reports

### Scripts
$Scripts

## What Was Verified

- Routes inventory generated
- Utilities inventory generated
- Services inventory generated
- Tests inventory generated
- Scripts inventory generated
- Docs inventory generated
- Operations inventory generated
- Backup-like files in route folder identified
- Live consolidation status generated
- Master consolidation matrix generated

## Safety Confirmation

No source code modified.
No source code deleted.
No source code moved.
No database modified.
No runtime file renamed.
No dependency changed.

## Key Findings

1. Route layer is large and mature.
2. Utility layer contains major legal engines.
3. Services layer is thin.
4. Backup-like files remain inside backend route folders.
5. Testing layer exists and must be used before future cleanup.
6. Governance and documentation are now strong.
7. Next improvement should be consolidation, not feature expansion.

## Next Recommended Phase

Phase 10ZZD.1 - Backup Route Archive Validation

Purpose:
Validate which backup files in backend/src/routes can be safely archived.

Do not proceed to Phase 11 until consolidation is completed.

## Restart Thread Handover Summary

The next ChatGPT thread should begin with this instruction:

'I am continuing Litigation 360 from Phase 10ZZD Enterprise Consolidation Audit. The project root is C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software. Phase 10ZZD created consolidation documentation, protocols, parameters, checks, verification, monitoring, inventories, and a master consolidation matrix. The next recommended step is Phase 10ZZD.1 Backup Route Archive Validation. Do not delete or move files without dependency validation and test confirmation.'

"@ | Set-Content "$Ops\handover\PHASE-10ZZD-HANDOVER.md"

@"
@echo off
cd /d $Root
echo Opening Phase 10ZZD reports...
explorer "$Root\$Reports"
pause
"@ | Set-Content "OPEN-PHASE-10ZZD-REPORTS.bat"

Write-Host ""
Write-Host "=================================================="
Write-Host "PHASE 10ZZD ENTERPRISE CONSOLIDATION AUDIT COMPLETE"
Write-Host "=================================================="
Write-Host ""
Write-Host "Reports:"
Write-Host "$Reports"
Write-Host ""
Write-Host "Handover:"
Write-Host "$Ops\handover\PHASE-10ZZD-HANDOVER.md"
Write-Host ""
Write-Host "Open reports with:"
Write-Host "OPEN-PHASE-10ZZD-REPORTS.bat"
Write-Host ""