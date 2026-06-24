# DEPLOY-PHASE-10ZZD-1-BACKUP-VALIDATION.ps1
# SAFE AUDIT ONLY - no delete, no move, no rename

$Root = "C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software"
Set-Location $Root

$Phase = "phase-10ZZD-1-backup-route-archive-validation"
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
  "$Reports\dependency",
  "$Reports\route-registration",
  "$Reports\classification",
  "$Reports\monitoring",
  $Docs,
  $Scripts
)

foreach ($Folder in $Folders) {
  New-Item -ItemType Directory -Force -Path $Folder | Out-Null
}

$BackupFiles = Get-ChildItem ".\backend\src\routes" -File | Where-Object {
  $_.Name -like "*.doctor-backup" -or
  $_.Name -like "*backup*" -or
  $_.Name -like "*BACKUP*" -or
  $_.Name -like "*DO_NOT_DELETE*"
}

@"
# Phase 10ZZD.1 Backup Route Archive Validation Blueprint

## Purpose
Validate backup-like route files before any archive action.

## Safety Rule
This phase does not delete, move, rename, overwrite, or refactor any source file.

## Scope
Folder checked:

backend\src\routes

## Backup File Patterns

- *.doctor-backup
- *backup*
- *BACKUP*
- *DO_NOT_DELETE*

## Required Outputs

- DEPENDENCY-VALIDATION.txt
- ROUTE-REGISTRATION-VALIDATION.txt
- BACKUP-FILE-CLASSIFICATION.txt
- ARCHIVE-CANDIDATE-MATRIX.md
- LIVE-BACKUP-VALIDATION-STATUS.txt
- PHASE-10ZZD-1-HANDOVER.md

## Exit Criteria

This phase is complete when every backup-like route file has been classified as:

- KEEP
- REVIEW
- ARCHIVE CANDIDATE

No archive action is allowed until after test confirmation.
"@ | Set-Content "$Ops\blueprints\PHASE-10ZZD-1-BLUEPRINT.md"

@"
# Phase 10ZZD.1 Protocols

## Protocol 1 - Validate Before Archive
No backup-like file may be moved until dependency checks and route-registration checks are complete.

## Protocol 2 - Runtime Protection
Protected folders:

- backend
- frontend
- tests
- docs
- _operations
- data
- configs
- node_modules
- .git

## Protocol 3 - Archive Candidate Rule
A file is only an archive candidate when:

1. It is backup-like.
2. It is not imported by runtime code.
3. It is not registered as a route.
4. Tests pass after validation.

## Protocol 4 - No Delete Rule
This phase never deletes anything.
"@ | Set-Content "$Ops\protocols\PHASE-10ZZD-1-PROTOCOLS.md"

@"
# Phase 10ZZD.1 Parameters

## Root
$Root

## Route Folder
backend\src\routes

## Reports Folder
$Reports

## Operations Folder
$Ops

## Classification

KEEP:
Still referenced or required.

REVIEW:
Possible special backup file requiring human confirmation.

ARCHIVE CANDIDATE:
No dependency found, likely historical artifact.

## Final Action
Audit only.
"@ | Set-Content "$Ops\parameters\PHASE-10ZZD-1-PARAMETERS.md"

@"
# Phase 10ZZD.1 Checks And Balances

## Required Checks

- Backup file list generated
- Dependency validation generated
- Route registration validation generated
- Classification generated
- Archive matrix generated
- Live status generated
- Handover generated

## Red Flags

- File name contains DO_NOT_DELETE
- File is imported in backend source
- File is registered in index.js or server.js
- File has same size as active runtime route
- File belongs to database migration or PostgreSQL fallback
"@ | Set-Content "$Ops\checks-balances\PHASE-10ZZD-1-CHECKS-BALANCES.md"

$DependencyReport = "$Reports\dependency\DEPENDENCY-VALIDATION.txt"
$RouteReport = "$Reports\route-registration\ROUTE-REGISTRATION-VALIDATION.txt"
$ClassReport = "$Reports\classification\BACKUP-FILE-CLASSIFICATION.txt"
$Matrix = "$Reports\ARCHIVE-CANDIDATE-MATRIX.md"

"Phase 10ZZD.1 Dependency Validation" | Set-Content $DependencyReport
"Generated: $(Get-Date)" | Add-Content $DependencyReport
"" | Add-Content $DependencyReport

"Phase 10ZZD.1 Route Registration Validation" | Set-Content $RouteReport
"Generated: $(Get-Date)" | Add-Content $RouteReport
"" | Add-Content $RouteReport

"Phase 10ZZD.1 Backup File Classification" | Set-Content $ClassReport
"Generated: $(Get-Date)" | Add-Content $ClassReport
"" | Add-Content $ClassReport

@"
# Archive Candidate Matrix

Generated: $(Get-Date)

| File | Dependency Found | Route Registration Found | Classification | Reason |
|---|---:|---:|---|---|
"@ | Set-Content $Matrix

foreach ($File in $BackupFiles) {
  $Name = $File.Name
  $Base = [System.IO.Path]::GetFileNameWithoutExtension($Name)

  $DependencyHits = Select-String -Path ".\backend\**\*.js",".\frontend\**\*.js",".\scripts\**\*.*",".\tests\**\*.*" -Pattern $Name -SimpleMatch -ErrorAction SilentlyContinue
  $RouteHits = Select-String -Path ".\backend\src\index.js",".\backend\server.js",".\backend\src\server.js" -Pattern $Name -SimpleMatch -ErrorAction SilentlyContinue

  $DependencyFound = if ($DependencyHits) { "YES" } else { "NO" }
  $RouteFound = if ($RouteHits) { "YES" } else { "NO" }

  if ($Name -like "*DO_NOT_DELETE*") {
    $Class = "REVIEW"
    $Reason = "Filename contains DO_NOT_DELETE"
  }
  elseif ($DependencyFound -eq "YES" -or $RouteFound -eq "YES") {
    $Class = "KEEP"
    $Reason = "Reference found"
  }
  else {
    $Class = "ARCHIVE CANDIDATE"
    $Reason = "No dependency or route registration found"
  }

  "FILE: $Name" | Add-Content $DependencyReport
  "Dependency Found: $DependencyFound" | Add-Content $DependencyReport
  if ($DependencyHits) { $DependencyHits | Out-String | Add-Content $DependencyReport }
  "" | Add-Content $DependencyReport

  "FILE: $Name" | Add-Content $RouteReport
  "Route Registration Found: $RouteFound" | Add-Content $RouteReport
  if ($RouteHits) { $RouteHits | Out-String | Add-Content $RouteReport }
  "" | Add-Content $RouteReport

  "$Name`t$Class`t$Reason" | Add-Content $ClassReport

  "| $Name | $DependencyFound | $RouteFound | $Class | $Reason |" | Add-Content $Matrix
}

$BackupCount = $BackupFiles.Count
$ArchiveCandidateCount = (Select-String -Path $Matrix -Pattern "ARCHIVE CANDIDATE").Count
$ReviewCount = (Select-String -Path $Matrix -Pattern "REVIEW").Count
$KeepCount = (Select-String -Path $Matrix -Pattern "KEEP").Count

@"
# Live Backup Validation Status

Generated: $(Get-Date)

## Counts

Backup-like route files found: $BackupCount
Archive candidates: $ArchiveCandidateCount
Review required: $ReviewCount
Keep: $KeepCount

## Status

Phase 10ZZD.1 validation generated.

## Safety Confirmation

No files deleted.
No files moved.
No files renamed.
No source code modified.
No database modified.

## Next Step

Review ARCHIVE-CANDIDATE-MATRIX.md.

Only after review:
1. Run tests.
2. Create archive folder.
3. Move archive candidates using a separate approved archive script.
4. Run tests again.
"@ | Set-Content "$Reports\monitoring\LIVE-BACKUP-VALIDATION-STATUS.txt"

@"
# Phase 10ZZD.1 Testing Protocol

## Before Any Archive Action

Run:

npm test

Then:

cd backend
npm test

## After Any Archive Action

Run the same tests again.

## Required Result

No test failures.

## Rule

If tests fail, restore from archive or stop.
"@ | Set-Content "$Ops\testing\PHASE-10ZZD-1-TESTING-PROTOCOL.md"

@"
# Phase 10ZZD.1 Handover

## Project
Litigation 360 Enterprise Platform

## Phase
Phase 10ZZD.1 Backup Route Archive Validation

## Status
Audit generated.

## Root
$Root

## Created Folders

$Ops
$Reports
$Docs
$Scripts

## Reports Created

$DependencyReport
$RouteReport
$ClassReport
$Matrix
$Reports\monitoring\LIVE-BACKUP-VALIDATION-STATUS.txt

## Safety

No runtime files changed.
No files moved.
No files deleted.
No database changes.

## Next Recommended Action

Review archive candidates.
Then run tests.
Then prepare Phase 10ZZD.2 Safe Archive Execution.

## Next Thread Opening Prompt

Continue Litigation 360 from Phase 10ZZD.1 Backup Route Archive Validation.

Root:
$Root

Current objective:
Review backup-like route files and decide which can safely be archived.

Important:
No delete, move, rename, or refactor until dependency validation and tests pass.
"@ | Set-Content "$Ops\handover\PHASE-10ZZD-1-HANDOVER.md"

@"
@echo off
cd /d $Root
explorer "$Root\$Reports"
pause
"@ | Set-Content "OPEN-PHASE-10ZZD-1-REPORTS.bat"

Write-Host ""
Write-Host "===================================================="
Write-Host "PHASE 10ZZD.1 BACKUP VALIDATION COMPLETE"
Write-Host "===================================================="
Write-Host "Reports: $Reports"
Write-Host "Matrix: $Matrix"
Write-Host "Handover: $Ops\handover\PHASE-10ZZD-1-HANDOVER.md"
Write-Host ""