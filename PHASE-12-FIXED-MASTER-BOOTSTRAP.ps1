# ============================================================
# LITIGATION 360 LEOS
# PHASE 12.0 FIXED MASTER BOOTSTRAP
# PURPOSE:
#   Fix "file not found" / "create new file?" problem by creating
#   all required folders, scripts, reports, checklists and control docs
#   directly inside the correct project folder.
#
# SAFE MODE:
#   - DOES NOT delete files
#   - DOES NOT rename files
#   - DOES NOT move source files
#   - DOES NOT modify database
#   - DOES NOT unlock production
#   - DOES NOT start Phase 11
# ============================================================

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

# -----------------------------
# 1. DECLARE YOUR PROJECT ROOT
# -----------------------------
$DeclaredProjectRoot = "C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software"

function Write-Step {
    param([string]$Message)
    Write-Host "[PHASE 12 FIX] $Message" -ForegroundColor Cyan
}

function Write-Pass {
    param([string]$Message)
    Write-Host "[PASS] $Message" -ForegroundColor Green
}

function Write-Warn {
    param([string]$Message)
    Write-Host "[WARN] $Message" -ForegroundColor Yellow
}

function Write-Fail {
    param([string]$Message)
    Write-Host "[FAIL] $Message" -ForegroundColor Red
}

function Save-Text {
    param(
        [Parameter(Mandatory=$true)][string]$Path,
        [Parameter(Mandatory=$true)][string]$Content
    )

    $Folder = Split-Path -Path $Path -Parent

    if (!(Test-Path -LiteralPath $Folder)) {
        New-Item -ItemType Directory -Path $Folder -Force | Out-Null
    }

    $Utf8NoBom = New-Object System.Text.UTF8Encoding($false)
    [System.IO.File]::WriteAllText($Path, $Content, $Utf8NoBom)
}

function Require-ExistingFolder {
    param([string]$Path)

    if (!(Test-Path -LiteralPath $Path -PathType Container)) {
        throw "Required project folder not found: $Path"
    }
}

# -----------------------------
# 2. RESOLVE PROJECT ROOT SAFELY
# -----------------------------
Write-Step "Resolving project root..."

if (Test-Path -LiteralPath $DeclaredProjectRoot -PathType Container) {
    $ProjectRoot = $DeclaredProjectRoot
}
else {
    $Current = (Get-Location).Path

    if (
        (Test-Path -LiteralPath (Join-Path $Current "package.json")) -or
        (Test-Path -LiteralPath (Join-Path $Current ".git")) -or
        (Test-Path -LiteralPath (Join-Path $Current "server.js")) -or
        (Test-Path -LiteralPath (Join-Path $Current "backend")) -or
        (Test-Path -LiteralPath (Join-Path $Current "frontend"))
    ) {
        Write-Warn "Declared project root was not found, but current folder looks like a project folder."
        $ProjectRoot = $Current
    }
    else {
        Write-Fail "Could not find your Litigation 360 project folder."
        Write-Host ""
        Write-Host "Expected path:" -ForegroundColor Yellow
        Write-Host $DeclaredProjectRoot -ForegroundColor Yellow
        Write-Host ""
        Write-Host "Current folder:" -ForegroundColor Yellow
        Write-Host $Current -ForegroundColor Yellow
        Write-Host ""
        Write-Host "Fix:"
        Write-Host "1. Open PowerShell."
        Write-Host "2. Run:"
        Write-Host "   cd `"C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software`""
        Write-Host "3. Paste this bootstrap again."
        throw "Wrong folder. No files were changed."
    }
}

Set-Location -LiteralPath $ProjectRoot
$RunStamp = Get-Date -Format "yyyyMMdd-HHmmss"
$ControlRoot = Join-Path $ProjectRoot "_LEOS_CONTROL"

Write-Pass "Project root resolved:"
Write-Host $ProjectRoot -ForegroundColor Green

Write-Pass "Control root:"
Write-Host $ControlRoot -ForegroundColor Green

# -----------------------------
# 3. CREATE REQUIRED FOLDERS
# -----------------------------
Write-Step "Creating required LEOS control folders..."

$RequiredFolders = @(
    "_LEOS_CONTROL",
    "_LEOS_CONTROL\00_SSOT",
    "_LEOS_CONTROL\01_GOVERNANCE",
    "_LEOS_CONTROL\02_SNAPSHOTS",
    "_LEOS_CONTROL\03_ROLLBACK",
    "_LEOS_CONTROL\04_TESTING",
    "_LEOS_CONTROL\05_MONITORING",
    "_LEOS_CONTROL\06_AI_PROMPTS",
    "_LEOS_CONTROL\99_LOGS",
    "_LEOS_CONTROL\certification",
    "_LEOS_CONTROL\change-control",
    "_LEOS_CONTROL\deployment",
    "_LEOS_CONTROL\evidence",
    "_LEOS_CONTROL\evidence\E01-INFRASTRUCTURE",
    "_LEOS_CONTROL\evidence\E02-STARTUP",
    "_LEOS_CONTROL\evidence\E03-AUTHENTICATION",
    "_LEOS_CONTROL\evidence\E04-WORKFLOWS",
    "_LEOS_CONTROL\evidence\E05-SECURITY",
    "_LEOS_CONTROL\evidence\E06-BACKUP",
    "_LEOS_CONTROL\evidence\E07-RESTORE",
    "_LEOS_CONTROL\evidence\E08-PERFORMANCE",
    "_LEOS_CONTROL\evidence\E09-DOCUMENTATION",
    "_LEOS_CONTROL\evidence\E10-READINESS",
    "_LEOS_CONTROL\feature-exploration",
    "_LEOS_CONTROL\feature-exploration\discovery",
    "_LEOS_CONTROL\feature-exploration\flags",
    "_LEOS_CONTROL\feature-exploration\matrix",
    "_LEOS_CONTROL\feature-exploration\runbooks",
    "_LEOS_CONTROL\reports",
    "_LEOS_CONTROL\rollback",
    "_LEOS_CONTROL\verification"
)

foreach ($Folder in $RequiredFolders) {
    New-Item -ItemType Directory -Path (Join-Path $ProjectRoot $Folder) -Force | Out-Null
}

Write-Pass "Required folders created."

# -----------------------------
# 4. CREATE MASTER SSOT DOCUMENT
# -----------------------------
Write-Step "Creating consolidated SSOT master document..."

$SSOT = @'
# LITIGATION 360 LEOS
# SSOT 12.0 CONSOLIDATED MASTER

Version: 12.0-CONSOLIDATED-MASTER
Status: AUTHORITATIVE CONTROL DOCUMENT
Deployment Status: CREATED BY PHASE 12 FIXED MASTER BOOTSTRAP
Classification: Legal Enterprise Operating System

---

## 1. Executive Summary

Litigation 360 is being governed as a Legal Enterprise Operating System.

The project is not currently cleared for uncontrolled production unlock.

The current safe objective is to create a governed control foundation that allows exploration, discovery, mapping, verification, and staged connection of features without breaking the main system.

---

## 2. Current Official Position

Phase 10 structural state: STRUCTURALLY COMPLETE AT DOCUMENT LEVEL

Phase 10 governance closure: ACTIVE

Pre-Phase 11 enterprise change-control foundation: ACTIVE

Phase 11 development: LOCKED

Phase 11.1 Security Hardening: BLOCKED UNTIL UNLOCK REQUIREMENTS PASS

Production approval: NOT APPROVED

Client rollout: BLOCKED

Feature exploration: ALLOWED IN LAB / READ-ONLY MODE ONLY

---

## 3. Golden Rule

No direct modification of production systems.

All changes must follow:

Request
→ Assessment
→ Approval
→ Branch
→ Development
→ Testing
→ Verification
→ Staging
→ Deployment
→ Monitoring
→ Closure

---

## 4. Safe Unlock Rule

All features may be discovered, listed, mapped, and connected conceptually inside the Feature Exploration Lab.

No feature is production-unlocked unless the following evidence exists:

1. Frontend route
2. Backend route / API
3. RBAC rule
4. Audit logging
5. Error handling
6. Database impact review
7. Test plan
8. Rollback plan
9. Monitoring requirement
10. Approval record

---

## 5. Current Allowed Work

Allowed:

- Create control folders
- Create SSOT documents
- Create checklists
- Create feature exploration maps
- Create route inventories
- Create module inventories
- Create reports
- Run read-only verification
- Run lab-only feature exploration

Blocked:

- Delete files
- Rename files
- Move source folders
- Clean duplicates
- Modify database
- Unlock production features
- Start Phase 11
- Start Phase 11.1 Security Hardening
- Deploy to production

---

## 6. Next Course of Action

Run PHASE-12.0C-READONLY-PROJECT-DISCOVERY.ps1.

This will inspect the project and report what actually exists.

After that, use the discovery report to decide which features can safely move from:

DISCOVERED
→ MAPPED
→ CONNECTABLE
→ TESTABLE
→ STAGING READY
→ APPROVED

---

## 7. Unlock Requirements

Phase 11.1 may only commence after:

[ ] Pre-Phase 11 Verification PASS
[ ] Backup PASS
[ ] Monitoring PASS
[ ] Testing PASS
[ ] Documentation PASS
[ ] Rollback PASS
[ ] Approval PASS
[ ] Governance Certification PASS

Current unlock status:

LOCKED
'@

$SSOTPath = Join-Path $ControlRoot "00_SSOT\SSOT-12.0-CONSOLIDATED-MASTER.md"
Save-Text -Path $SSOTPath -Content $SSOT

# -----------------------------
# 5. CREATE CURRENT AUTHORITY POINTER
# -----------------------------
$Authority = @"
# LITIGATION 360 LEOS
# CURRENT AUTHORITY POINTER

Generated: $(Get-Date -Format "yyyy-MM-dd HH:mm:ss")

Project Root:
$ProjectRoot

Control Root:
$ControlRoot

Master Authority:
_LEOS_CONTROL\00_SSOT\SSOT-12.0-CONSOLIDATED-MASTER.md

Current Official Position:
- Phase 10 structural state: structurally complete at document level
- Phase 10 governance closure: active
- Pre-Phase 11 governance foundation: active
- Phase 11 development: locked
- Phase 11.1 Security Hardening: blocked
- Production approval: not approved
- Client rollout: blocked
- Feature exploration: allowed in lab/read-only mode only

Next Script:
PHASE-12.0C-READONLY-PROJECT-DISCOVERY.ps1
"@

Save-Text -Path (Join-Path $ControlRoot "00_SSOT\SSOT-CURRENT-AUTHORITY.md") -Content $Authority

# -----------------------------
# 6. CREATE TEMPLATES
# -----------------------------
Write-Step "Creating governance templates..."

Save-Text -Path (Join-Path $ControlRoot "change-control\CHANGE-REQUEST-TEMPLATE.md") -Content @'
# CHANGE REQUEST TEMPLATE

Change Request ID: CR-YYYY-XXXX
Date:
Requester:
Risk Classification: LOW / MEDIUM / HIGH / CRITICAL
Affected Module:
Affected Files:
Affected Routes:
Affected Database Objects:

Objective:

Reason:

Impact Assessment Reference:

Testing Plan Reference:

Rollback Plan Reference:

Approval Status: PENDING / APPROVED / REJECTED

Notes:
'@

Save-Text -Path (Join-Path $ControlRoot "change-control\IMPACT-ASSESSMENT-TEMPLATE.md") -Content @'
# IMPACT ASSESSMENT TEMPLATE

Impact Assessment ID: IA-YYYY-XXXX
Linked Change Request: CR-YYYY-XXXX
Risk Classification: LOW / MEDIUM / HIGH / CRITICAL

Architecture Impact:
Security Impact:
RBAC Impact:
Database Impact:
Workflow Impact:
Frontend Impact:
Backend Impact:
Testing Impact:
Monitoring Impact:
Rollback Impact:
Deployment Impact:

Recommendation: APPROVE / REJECT / DEFER
Reviewer:
Date:
'@

Save-Text -Path (Join-Path $ControlRoot "rollback\ROLLBACK-PLAN-TEMPLATE.md") -Content @'
# ROLLBACK PLAN TEMPLATE

Rollback ID: ROLLBACK-YYYY-XXXX
Linked Change Request: CR-YYYY-XXXX

Rollback Trigger:
Rollback Scope:
Files to Restore:
Database Rollback Required: YES / NO
Backup Location:

Rollback Procedure:

Rollback Validation:

Rollback Approval:

PASS Criteria:
FAIL Criteria:

Reviewer:
Date:
'@

Save-Text -Path (Join-Path $ControlRoot "verification\PRE-PHASE11-UNLOCK-CHECKLIST.md") -Content @'
# PRE-PHASE 11 UNLOCK CHECKLIST

Phase 11.1 Security Hardening may commence only after all items are PASS.

[ ] Pre-Phase 11 Verification PASS
[ ] Backup PASS
[ ] Monitoring PASS
[ ] Testing PASS
[ ] Documentation PASS
[ ] Rollback PASS
[ ] Approval PASS
[ ] Governance Certification PASS

Current Status: LOCKED
Unlock Decision: PENDING
'@

Save-Text -Path (Join-Path $ControlRoot "certification\MODULE-CERTIFICATION-MATRIX.csv") -Content "Module,FrontendRoute,BackendRoute,DatabaseImpact,RBAC,AuditLogging,TestingEvidence,RollbackPlan,Status`r`n"

Save-Text -Path (Join-Path $ControlRoot "certification\ROUTE-CERTIFICATION-MATRIX.csv") -Content "Route,Method,FrontendPath,BackendPath,AuthRequired,RBACRequired,TestEvidence,Status`r`n"

Write-Pass "Templates created."

# -----------------------------
# 7. CREATE LAB FEATURE FLAGS
# -----------------------------
Write-Step "Creating safe lab-only feature exploration files..."

$FeatureFlags = @'
{
  "mode": "LAB_ONLY",
  "productionUnlock": false,
  "phase11Unlocked": false,
  "allowDiscovery": true,
  "allowMapping": true,
  "allowReadOnlyExploration": true,
  "allowSourceModification": false,
  "allowDatabaseModification": false,
  "allowDeletion": false,
  "allowRename": false,
  "allowMove": false,
  "allowCleanup": false,
  "features": {
    "workspace": "EXPLORE",
    "clients": "EXPLORE",
    "matters": "EXPLORE",
    "deadlines": "EXPLORE",
    "documents": "EXPLORE",
    "courtDates": "EXPLORE",
    "staff": "EXPLORE",
    "dashboardECC": "MAP_ONLY",
    "authentication": "VERIFY_ONLY",
    "rbac": "VERIFY_ONLY",
    "auditLogging": "VERIFY_ONLY",
    "notifications": "MAP_ONLY",
    "automation": "MAP_ONLY",
    "reports": "MAP_ONLY",
    "clientPortal": "FUTURE_ONLY",
    "communicationsHub": "FUTURE_ONLY",
    "financeBilling": "FUTURE_ONLY",
    "knowledgeGraph": "FUTURE_ONLY",
    "aiCopilot": "FUTURE_ONLY",
    "mobileApp": "FUTURE_ONLY"
  }
}
'@

Save-Text -Path (Join-Path $ControlRoot "feature-exploration\flags\LAB-FEATURE-FLAGS.json") -Content $FeatureFlags

Save-Text -Path (Join-Path $ControlRoot "feature-exploration\runbooks\FEATURE-EXPLORATION-RUNBOOK.md") -Content @'
# FEATURE EXPLORATION RUNBOOK

## Purpose

This runbook allows feature discovery and connection planning without unlocking production.

## Safe Sequence

1. Discover files
2. Discover routes
3. Discover modules
4. Map frontend to backend
5. Map backend to database
6. Identify RBAC requirement
7. Identify audit logging requirement
8. Identify tests required
9. Identify rollback requirement
10. Mark feature as CONNECTABLE only after evidence exists

## Forbidden

- Do not delete
- Do not rename
- Do not move
- Do not refactor
- Do not modify database
- Do not production unlock
- Do not start Phase 11
'@

Save-Text -Path (Join-Path $ControlRoot "feature-exploration\matrix\FEATURE-EXPLORATION-MATRIX.csv") -Content "Feature,CurrentStatus,FrontendEvidence,BackendEvidence,DatabaseEvidence,RBACEvidence,AuditEvidence,TestingEvidence,RollbackEvidence,NextAction`r`n"

# -----------------------------
# 8. CREATE READ-ONLY DISCOVERY SCRIPT
# -----------------------------
Write-Step "Creating read-only discovery script..."

$DiscoveryScript = @'
# ============================================================
# LITIGATION 360 LEOS
# PHASE 12.0C READ-ONLY PROJECT DISCOVERY
# SAFE:
#   - No delete
#   - No rename
#   - No move
#   - No database modification
#   - No source modification
# ============================================================

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$ProjectRoot = "C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software"

if (!(Test-Path -LiteralPath $ProjectRoot -PathType Container)) {
    $ProjectRoot = (Get-Location).Path
}

Set-Location -LiteralPath $ProjectRoot

$RunStamp = Get-Date -Format "yyyyMMdd-HHmmss"
$ControlRoot = Join-Path $ProjectRoot "_LEOS_CONTROL"
$DiscoveryRoot = Join-Path $ControlRoot "feature-exploration\discovery"
$ReportRoot = Join-Path $ControlRoot "reports"

New-Item -ItemType Directory -Path $DiscoveryRoot -Force | Out-Null
New-Item -ItemType Directory -Path $ReportRoot -Force | Out-Null

function Export-List {
    param(
        [string]$Path,
        [object[]]$Rows
    )

    if ($null -eq $Rows) {
        $Rows = @()
    }

    $Rows | Out-File -FilePath $Path -Encoding UTF8
}

Write-Host "[PHASE 12.0C] Read-only discovery started..." -ForegroundColor Cyan

# Project root files
Get-ChildItem -LiteralPath $ProjectRoot -Force |
    Select-Object FullName, Name, Mode, Length, LastWriteTime |
    Export-Csv -Path (Join-Path $DiscoveryRoot "ROOT-FILES-AND-FOLDERS.csv") -NoTypeInformation

# Full file inventory excluding node_modules and _LEOS_CONTROL to keep it manageable
$AllFiles = Get-ChildItem -LiteralPath $ProjectRoot -Recurse -File -Force -ErrorAction SilentlyContinue |
    Where-Object {
        $_.FullName -notmatch "\\node_modules\\" -and
        $_.FullName -notmatch "\\_LEOS_CONTROL\\"
    }

$AllFiles |
    Select-Object FullName, Name, Extension, Length, LastWriteTime |
    Export-Csv -Path (Join-Path $DiscoveryRoot "PROJECT-FILE-INVENTORY-EXCLUDING-NODEMODULES.csv") -NoTypeInformation

# Candidate frontend files
$AllFiles |
    Where-Object { $_.Extension -match "^\.(jsx|tsx|js|ts|css|html)$" } |
    Select-Object FullName, Name, Extension, Length, LastWriteTime |
    Export-Csv -Path (Join-Path $DiscoveryRoot "FRONTEND-BACKEND-CODE-CANDIDATES.csv") -NoTypeInformation

# Candidate backend files
$AllFiles |
    Where-Object { $_.FullName -match "\\server|\\backend|\\api|\\routes|\\controllers|\\middleware|\\models" -or $_.Name -match "server|app|route|controller|middleware" } |
    Select-Object FullName, Name, Extension, Length, LastWriteTime |
    Export-Csv -Path (Join-Path $DiscoveryRoot "BACKEND-CANDIDATE-FILES.csv") -NoTypeInformation

# Database files
$AllFiles |
    Where-Object { $_.Extension -match "^\.(db|sqlite|sqlite3)$" -or $_.Name -match "database|sqlite|prisma|schema" } |
    Select-Object FullName, Name, Extension, Length, LastWriteTime |
    Export-Csv -Path (Join-Path $DiscoveryRoot "DATABASE-CANDIDATE-FILES.csv") -NoTypeInformation

# Documentation files
$AllFiles |
    Where-Object { $_.Extension -match "^\.(md|txt|docx|pdf)$" } |
    Select-Object FullName, Name, Extension, Length, LastWriteTime |
    Export-Csv -Path (Join-Path $DiscoveryRoot "DOCUMENTATION-FILES.csv") -NoTypeInformation

# Git status if available
$GitStatusPath = Join-Path $DiscoveryRoot "GIT-STATUS.txt"
try {
    git status --short | Out-File -FilePath $GitStatusPath -Encoding UTF8
}
catch {
    "Git status unavailable: $($_.Exception.Message)" | Out-File -FilePath $GitStatusPath -Encoding UTF8
}

# Package files
$PackageFiles = @(
    "package.json",
    "package-lock.json",
    "vite.config.js",
    "vite.config.ts",
    "server.js",
    "app.js"
)

$PackageReport = foreach ($File in $PackageFiles) {
    $Path = Join-Path $ProjectRoot $File
    [PSCustomObject]@{
        File = $File
        Exists = Test-Path -LiteralPath $Path
        FullName = $Path
    }
}

$PackageReport | Export-Csv -Path (Join-Path $DiscoveryRoot "PACKAGE-AND-STARTUP-FILE-CHECK.csv") -NoTypeInformation

# Ports currently listening
try {
    netstat -ano | Select-String ":3000|:5000|:5060|:5061|:5100|:5173|:8080" |
        Out-File -FilePath (Join-Path $DiscoveryRoot "ACTIVE-PORTS.txt") -Encoding UTF8
}
catch {
    "Port check unavailable: $($_.Exception.Message)" |
        Out-File -FilePath (Join-Path $DiscoveryRoot "ACTIVE-PORTS.txt") -Encoding UTF8
}

# Create readable report
$FileCount = ($AllFiles | Measure-Object).Count
$FrontendCount = ($AllFiles | Where-Object { $_.Extension -match "^\.(jsx|tsx|js|ts|css|html)$" } | Measure-Object).Count
$DbCount = ($AllFiles | Where-Object { $_.Extension -match "^\.(db|sqlite|sqlite3)$" -or $_.Name -match "database|sqlite|prisma|schema" } | Measure-Object).Count
$DocCount = ($AllFiles | Where-Object { $_.Extension -match "^\.(md|txt|docx|pdf)$" } | Measure-Object).Count

$Report = @"
# PHASE 12.0C READ-ONLY PROJECT DISCOVERY REPORT

Generated: $(Get-Date -Format "yyyy-MM-dd HH:mm:ss")

Project Root:
$ProjectRoot

Control Root:
$ControlRoot

Discovery Root:
$DiscoveryRoot

## Summary

Total discovered files excluding node_modules and _LEOS_CONTROL:
$FileCount

Frontend/backend code candidate files:
$FrontendCount

Database candidate files:
$DbCount

Documentation files:
$DocCount

## Output Files

- _LEOS_CONTROL\feature-exploration\discovery\ROOT-FILES-AND-FOLDERS.csv
- _LEOS_CONTROL\feature-exploration\discovery\PROJECT-FILE-INVENTORY-EXCLUDING-NODEMODULES.csv
- _LEOS_CONTROL\feature-exploration\discovery\FRONTEND-BACKEND-CODE-CANDIDATES.csv
- _LEOS_CONTROL\feature-exploration\discovery\BACKEND-CANDIDATE-FILES.csv
- _LEOS_CONTROL\feature-exploration\discovery\DATABASE-CANDIDATE-FILES.csv
- _LEOS_CONTROL\feature-exploration\discovery\DOCUMENTATION-FILES.csv
- _LEOS_CONTROL\feature-exploration\discovery\GIT-STATUS.txt
- _LEOS_CONTROL\feature-exploration\discovery\PACKAGE-AND-STARTUP-FILE-CHECK.csv
- _LEOS_CONTROL\feature-exploration\discovery\ACTIVE-PORTS.txt

## Current Status

Read-only discovery completed.

No files were deleted.
No files were renamed.
No files were moved.
No database was modified.
No source code was modified.
No production feature was unlocked.

## Next Action

Paste this report back into ChatGPT.

Then proceed to Phase 12.0D: feature connection matrix review.
"@

$ReportPath = Join-Path $ReportRoot "PHASE-12.0C-READONLY-PROJECT-DISCOVERY-REPORT.md"
$Report | Out-File -FilePath $ReportPath -Encoding UTF8

Write-Host ""
Write-Host "[PASS] Phase 12.0C read-only discovery completed." -ForegroundColor Green
Write-Host ""
Write-Host "Open report:" -ForegroundColor Cyan
Write-Host "notepad `"_LEOS_CONTROL\reports\PHASE-12.0C-READONLY-PROJECT-DISCOVERY-REPORT.md`""
Write-Host ""
'@

$DiscoveryScriptPath = Join-Path $ProjectRoot "PHASE-12.0C-READONLY-PROJECT-DISCOVERY.ps1"
Save-Text -Path $DiscoveryScriptPath -Content $DiscoveryScript

# -----------------------------
# 9. CREATE RUN COMMAND FILES
# -----------------------------
Write-Step "Creating run helpers..."

$Bat = @"
@echo off
cd /d "$ProjectRoot"
powershell -ExecutionPolicy Bypass -File ".\PHASE-12.0C-READONLY-PROJECT-DISCOVERY.ps1"
pause
"@

Save-Text -Path (Join-Path $ProjectRoot "RUN-PHASE-12.0C-READONLY-DISCOVERY.bat") -Content $Bat

$CommandGuide = @"
# LITIGATION 360 LEOS
# PHASE 12 FIXED MASTER BOOTSTRAP COMMAND GUIDE

## Why Notepad asked 'Create new file?'

Because the files did not exist on your Windows PC yet.

The earlier files were ChatGPT sandbox files.
PowerShell cannot see those files until they are downloaded or recreated locally.

This bootstrap has now created the actual local files inside:

$ProjectRoot

## Created Main Files

1. _LEOS_CONTROL\00_SSOT\SSOT-12.0-CONSOLIDATED-MASTER.md
2. _LEOS_CONTROL\00_SSOT\SSOT-CURRENT-AUTHORITY.md
3. _LEOS_CONTROL\verification\PRE-PHASE11-UNLOCK-CHECKLIST.md
4. _LEOS_CONTROL\feature-exploration\flags\LAB-FEATURE-FLAGS.json
5. _LEOS_CONTROL\feature-exploration\runbooks\FEATURE-EXPLORATION-RUNBOOK.md
6. _LEOS_CONTROL\feature-exploration\matrix\FEATURE-EXPLORATION-MATRIX.csv
7. PHASE-12.0C-READONLY-PROJECT-DISCOVERY.ps1
8. RUN-PHASE-12.0C-READONLY-DISCOVERY.bat

## Run Next

From PowerShell:

cd "$ProjectRoot"
powershell -ExecutionPolicy Bypass -File ".\PHASE-12.0C-READONLY-PROJECT-DISCOVERY.ps1"

Or double-click:

RUN-PHASE-12.0C-READONLY-DISCOVERY.bat

## Open Report After Running

notepad "_LEOS_CONTROL\reports\PHASE-12.0C-READONLY-PROJECT-DISCOVERY-REPORT.md"

## Important

Do not start Phase 11 yet.
Do not delete or clean anything yet.
Do not production-unlock features yet.

Feature exploration is LAB ONLY until evidence exists.
"@

Save-Text -Path (Join-Path $ControlRoot "99_LOGS\PHASE-12-FIXED-BOOTSTRAP-COMMAND-GUIDE.md") -Content $CommandGuide

# -----------------------------
# 10. CREATE BOOTSTRAP REPORT
# -----------------------------
$Report = @"
# PHASE 12 FIXED MASTER BOOTSTRAP REPORT

Generated: $(Get-Date -Format "yyyy-MM-dd HH:mm:ss")

Project Root:
$ProjectRoot

Control Root:
$ControlRoot

## Purpose

This fixed bootstrap corrected the missing file / wrong folder problem by creating all required control folders and scripts directly inside the project root.

## Created

- _LEOS_CONTROL folder structure
- SSOT master file
- Current authority pointer
- Change request template
- Impact assessment template
- Rollback plan template
- Unlock checklist
- Module certification matrix
- Route certification matrix
- Feature exploration lab
- Lab-only feature flags
- Feature exploration runbook
- Read-only discovery script
- BAT launcher
- Command guide

## Safety

No source files modified.
No database modified.
No production features unlocked.
No Phase 11 work started.
No delete/rename/move/cleanup performed.

## Next Action

Run:

powershell -ExecutionPolicy Bypass -File ".\PHASE-12.0C-READONLY-PROJECT-DISCOVERY.ps1"

Then open:

notepad "_LEOS_CONTROL\reports\PHASE-12.0C-READONLY-PROJECT-DISCOVERY-REPORT.md"

Paste the report back into ChatGPT.
"@

$BootstrapReportPath = Join-Path $ControlRoot "99_LOGS\PHASE-12-FIXED-MASTER-BOOTSTRAP-REPORT.md"
Save-Text -Path $BootstrapReportPath -Content $Report

# -----------------------------
# 11. DISPLAY FINAL RESULT
# -----------------------------
Write-Host ""
Write-Pass "PHASE 12 FIXED MASTER BOOTSTRAP COMPLETE"
Write-Host ""
Write-Host "Created local files inside:" -ForegroundColor Cyan
Write-Host $ProjectRoot
Write-Host ""
Write-Host "Open bootstrap report:" -ForegroundColor Cyan
Write-Host "notepad `"_LEOS_CONTROL\99_LOGS\PHASE-12-FIXED-MASTER-BOOTSTRAP-REPORT.md`""
Write-Host ""
Write-Host "Run next discovery:" -ForegroundColor Cyan
Write-Host "powershell -ExecutionPolicy Bypass -File `".\PHASE-12.0C-READONLY-PROJECT-DISCOVERY.ps1`""
Write-Host ""
Write-Host "Or double-click:" -ForegroundColor Cyan
Write-Host "RUN-PHASE-12.0C-READONLY-DISCOVERY.bat"
Write-Host ""
Write-Pass "This fixes the missing-folder / create-new-file problem."
