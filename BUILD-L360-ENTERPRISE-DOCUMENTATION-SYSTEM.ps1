# BUILD-L360-ENTERPRISE-DOCUMENTATION-SYSTEM.ps1
# Litigation 360 Enterprise Documentation + Governance + Monitoring Builder

$Root = "C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software"
Set-Location $Root

$Folders = @(
  "docs\MASTER-SYSTEM",
  "docs\MASTER-SYSTEM\01-protocols",
  "docs\MASTER-SYSTEM\02-parameters",
  "docs\MASTER-SYSTEM\03-blueprints",
  "docs\MASTER-SYSTEM\04-checks-balances",
  "docs\MASTER-SYSTEM\05-verification",
  "docs\MASTER-SYSTEM\06-testing",
  "docs\MASTER-SYSTEM\07-monitoring",
  "docs\MASTER-SYSTEM\08-prompts",
  "docs\MASTER-SYSTEM\09-deployment",
  "docs\MASTER-SYSTEM\10-recovery",
  "docs\MASTER-SYSTEM\11-progress",
  "reports\master-system",
  "reports\master-system\inventory",
  "reports\master-system\verification",
  "reports\master-system\testing",
  "reports\master-system\monitoring",
  "scripts\master-system"
)

foreach ($Folder in $Folders) {
  New-Item -ItemType Directory -Force -Path $Folder | Out-Null
}

@"
# Litigation 360 Master Documentation Index

Purpose:
Single navigation point for all enterprise documentation.

## Core Areas

1. Architecture
2. Governance
3. Operations
4. Testing
5. Validation
6. Security
7. Automation
8. AI
9. Legal Operations
10. Phase History
11. Deployment
12. Recovery
13. Monitoring
14. Commercialisation
15. Licensing
16. Executive Knowledge

## Rule

No major feature, module, route, engine, deployment, or patch is considered complete unless it has:

- Blueprint
- Protocol
- Parameters
- Checks and balances
- Verification
- Testing evidence
- Recovery instruction
- Monitoring reference
- Completion report
"@ | Set-Content "docs\MASTER-SYSTEM\MASTER-DOCUMENTATION-INDEX.md"

@"
# Master Protocols

## Development Protocol

Before any change:
1. Identify affected files.
2. Identify affected routes.
3. Identify affected database tables.
4. Identify affected tests.
5. Create backup or snapshot.
6. Run existing tests.
7. Apply change.
8. Run verification.
9. Generate report.

## No Blind Change Rule

Do not modify production files without:
- backup
- validation command
- rollback plan
- test result

## Completion Rule

A phase is complete only when:
- files exist
- routes exist
- tests exist
- documentation exists
- verification passes
- report is generated
"@ | Set-Content "docs\MASTER-SYSTEM\01-protocols\MASTER-PROTOCOLS.md"

@"
# Master Parameters

## Root Path

C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software

## Core Folders

backend
frontend
docs
_operations
scripts
tests
reports
configs
data

## Protected Folders

Do not auto-move or delete:
- backend
- frontend
- node_modules
- .git
- docs
- _operations
- tests
- configs
- data

## Required Evidence Per Phase

- Blueprint
- Build script
- API route
- Utility/service
- Test
- Report
- Completion document
"@ | Set-Content "docs\MASTER-SYSTEM\02-parameters\MASTER-PARAMETERS.md"

@"
# Master Blueprint Template

Each new module must follow this format.

## Module Name

## Purpose

## Scope

## Files To Create

## Files To Modify

## API Endpoints

## Database Tables

## Inputs

## Outputs

## Validation Rules

## Error Handling

## Security Rules

## Tests Required

## Rollback Plan

## Completion Criteria
"@ | Set-Content "docs\MASTER-SYSTEM\03-blueprints\MASTER-BLUEPRINT-TEMPLATE.md"

@"
# Master Checks And Balances

## Required Checks

- Folder exists
- File exists
- Route registered
- Server starts
- Database connects
- Tests pass
- Report generated
- Documentation updated

## Red Flag Conditions

- Missing test
- Missing rollback
- Missing route registration
- Hardcoded fake progress
- Empty documentation
- Broken relative path
- Manual-only process
"@ | Set-Content "docs\MASTER-SYSTEM\04-checks-balances\MASTER-CHECKS-BALANCES.md"

@"
# Master Verification Protocol

## Verification Commands

Run from root:

npm test

cd backend
npm test

## Inventory Commands

Get-ChildItem .\backend\src\routes -Recurse | Select-Object FullName
Get-ChildItem .\backend\src\utils -Recurse | Select-Object FullName
Get-ChildItem .\backend\src\services -Recurse | Select-Object FullName
Get-ChildItem .\tests -Recurse | Select-Object FullName

## Verification Output Folder

reports\master-system\verification
"@ | Set-Content "docs\MASTER-SYSTEM\05-verification\MASTER-VERIFICATION-PROTOCOL.md"

@"
# Master Testing Protocol

## Required Test Categories

1. Health tests
2. Route tests
3. Security tests
4. CRUD smoke tests
5. Workflow tests
6. Automation tests
7. Deadline tests
8. Licensing tests
9. Commercialisation tests

## Rule

Every new engine must have at least one test file.

## Test Output Folder

reports\master-system\testing
"@ | Set-Content "docs\MASTER-SYSTEM\06-testing\MASTER-TESTING-PROTOCOL.md"

@"
# Master Monitoring Protocol

## Live Monitoring Areas

- Backend health
- Frontend health
- Database connection
- Route availability
- Test status
- Error logs
- Scheduler
- Dashboard
- Automation engines
- Commercial licensing

## Monitoring Output Folder

reports\master-system\monitoring
"@ | Set-Content "docs\MASTER-SYSTEM\07-monitoring\MASTER-MONITORING-PROTOCOL.md"

@"
# Master Prompt Library

## Build Prompt

Create this module using:
- exact file paths
- exact commands
- no manual guessing
- test file
- verification report
- rollback instruction

## Audit Prompt

Audit the system and return:
- existing files
- missing files
- broken references
- duplicated files
- required next action

## Handover Prompt

Create a handover package with:
- status
- completed items
- missing items
- risks
- next steps
"@ | Set-Content "docs\MASTER-SYSTEM\08-prompts\MASTER-PROMPT-LIBRARY.md"

@"
# Master Deployment Protocol

## Deployment Rule

No deployment is approved unless:

- backup exists
- tests pass
- validation report exists
- rollback path exists
- affected routes identified
- affected files identified

## Deployment Output Folder

reports\master-system
"@ | Set-Content "docs\MASTER-SYSTEM\09-deployment\MASTER-DEPLOYMENT-PROTOCOL.md"

@"
# Master Recovery Protocol

## Recovery Steps

1. Stop backend.
2. Stop frontend.
3. Restore latest backup.
4. Verify package files.
5. Restart backend.
6. Restart frontend.
7. Run health checks.
8. Run regression tests.

## Protected Recovery Rule

Never overwrite SQLite production database without copied test database.
"@ | Set-Content "docs\MASTER-SYSTEM\10-recovery\MASTER-RECOVERY-PROTOCOL.md"

@"
# Master Progress Tracker

## Status

Generated by BUILD-L360-ENTERPRISE-DOCUMENTATION-SYSTEM.ps1

## Current Governance Status

- Documentation structure created
- Protocols created
- Parameters created
- Blueprint template created
- Checks and balances created
- Verification protocol created
- Testing protocol created
- Monitoring protocol created
- Prompt library created
- Deployment protocol created
- Recovery protocol created

## Next Required Step

Run master audit script.
"@ | Set-Content "docs\MASTER-SYSTEM\11-progress\MASTER-PROGRESS-TRACKER.md"

@"
# MASTER AUDIT SCRIPT
`$Root = "C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software"
Set-Location `$Root

Get-Date | Out-File "reports\master-system\MASTER-AUDIT-TIMESTAMP.txt"

Get-ChildItem ".\backend\src\routes" -Recurse | Select-Object FullName | Out-File "reports\master-system\inventory\ROUTES.txt"
Get-ChildItem ".\backend\src\utils" -Recurse | Select-Object FullName | Out-File "reports\master-system\inventory\UTILITIES.txt"
Get-ChildItem ".\backend\src\services" -Recurse | Select-Object FullName | Out-File "reports\master-system\inventory\SERVICES.txt"
Get-ChildItem ".\tests" -Recurse | Select-Object FullName | Out-File "reports\master-system\inventory\TESTS.txt"
Get-ChildItem ".\docs" -Recurse | Select-Object FullName | Out-File "reports\master-system\inventory\DOCS.txt"
Get-ChildItem ".\_operations" -Recurse | Select-Object FullName | Out-File "reports\master-system\inventory\OPERATIONS.txt"
Get-ChildItem ".\scripts" -Recurse | Select-Object FullName | Out-File "reports\master-system\inventory\SCRIPTS.txt"

Write-Host "MASTER AUDIT COMPLETE"
Write-Host "Output: reports\master-system\inventory"
"@ | Set-Content "scripts\master-system\RUN-MASTER-AUDIT.ps1"

@"
# LIVE STATUS SNAPSHOT SCRIPT
`$Root = "C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software"
Set-Location `$Root

`$Report = "reports\master-system\monitoring\LIVE-STATUS-SNAPSHOT.txt"

"Litigation 360 Live Status Snapshot" | Out-File `$Report
"Generated: `$((Get-Date).ToString())" | Out-File `$Report -Append
"" | Out-File `$Report -Append

"Node Processes:" | Out-File `$Report -Append
Get-Process node -ErrorAction SilentlyContinue | Select-Object Id,ProcessName,CPU,StartTime | Out-File `$Report -Append

"" | Out-File `$Report -Append
"Root Folder:" | Out-File `$Report -Append
Get-ChildItem . | Select-Object Name,Mode,LastWriteTime | Out-File `$Report -Append

Write-Host "LIVE STATUS SNAPSHOT CREATED"
Write-Host `$Report
"@ | Set-Content "scripts\master-system\RUN-LIVE-STATUS-SNAPSHOT.ps1"

@"
@echo off
cd /d C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software
powershell -ExecutionPolicy Bypass -File scripts\master-system\RUN-MASTER-AUDIT.ps1
powershell -ExecutionPolicy Bypass -File scripts\master-system\RUN-LIVE-STATUS-SNAPSHOT.ps1
pause
"@ | Set-Content "RUN-L360-MASTER-SYSTEM-AUDIT.bat"

Write-Host ""
Write-Host "==============================================="
Write-Host "LITIGATION 360 MASTER DOCUMENTATION SYSTEM DONE"
Write-Host "==============================================="
Write-Host ""
Write-Host "Created:"
Write-Host "docs\MASTER-SYSTEM"
Write-Host "scripts\master-system"
Write-Host "reports\master-system"
Write-Host "RUN-L360-MASTER-SYSTEM-AUDIT.bat"
Write-Host ""