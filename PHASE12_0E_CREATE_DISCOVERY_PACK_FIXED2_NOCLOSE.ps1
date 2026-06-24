#requires -Version 5.1
<#
LITIGATION 360 LEOS
PHASE 12.0E - MATTER TYPE BACKEND / DATA SUPPORT DISCOVERY AND CERTIFICATION
MASTER ADD-ONLY DEPLOYMENT PACK CREATOR

SAFETY CLASSIFICATION:
- This script creates documentation, protocols, checklists, prompts, discovery scripts, monitoring scripts, and report folders.
- This script DOES NOT modify active frontend source code.
- This script DOES NOT modify active backend source code.
- This script DOES NOT modify the database.
- This script writes only inside the LEOS control root.

Recommended run location:
PowerShell 5.1+ on Windows

Run command:
powershell -ExecutionPolicy Bypass -NoProfile -File "C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software_LEOS_CONTROL\07_DISCOVERY\PHASE12.0E-MATTER-TYPE-BACKEND-DATA-DISCOVERY\PHASE12.0E-CREATE-DISCOVERY-PACK.ps1"
#>

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

# =========================
# 0. FIXED PROJECT PATHS
# =========================
$ProjectRoot = "C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software"
$ControlRoot = "C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software_LEOS_CONTROL"
$PhaseId = "PHASE12.0E"
$PhaseName = "MATTER-TYPE-BACKEND-DATA-DISCOVERY"
$PhaseSlug = "$PhaseId-$PhaseName"
$RunStamp = Get-Date -Format "yyyyMMdd-HHmmss"

$DiscoveryRoot = Join-Path $ControlRoot "07_DISCOVERY"
$PhaseRoot = Join-Path $DiscoveryRoot $PhaseSlug
$DocsRoot = Join-Path $PhaseRoot "00_DOCUMENTATION"
$ProtocolsRoot = Join-Path $PhaseRoot "01_PROTOCOLS"
$ParametersRoot = Join-Path $PhaseRoot "02_PARAMETERS"
$BlueprintsRoot = Join-Path $PhaseRoot "03_BLUEPRINTS"
$ChecklistsRoot = Join-Path $PhaseRoot "04_CHECKLISTS"
$PromptsRoot = Join-Path $PhaseRoot "05_PROMPTS"
$ScriptsRoot = Join-Path $PhaseRoot "06_SCRIPTS"
$ReportsRoot = Join-Path $PhaseRoot "07_REPORTS"
$EvidenceRoot = Join-Path $PhaseRoot "08_EVIDENCE"
$SnapshotsRoot = Join-Path $PhaseRoot "09_READONLY_SNAPSHOTS"
$MonitorRoot = Join-Path $PhaseRoot "10_LIVE_MONITORING"
$LogsRoot = Join-Path $PhaseRoot "99_LOGS"

$LegacyRoots = @(
    (Join-Path $ControlRoot "00_SSOT"),
    (Join-Path $ControlRoot "01_GOVERNANCE"),
    (Join-Path $ControlRoot "02_SNAPSHOTS"),
    (Join-Path $ControlRoot "03_ROLLBACK"),
    (Join-Path $ControlRoot "04_TESTING"),
    (Join-Path $ControlRoot "05_MONITORING"),
    (Join-Path $ControlRoot "06_AI_PROMPTS"),
    (Join-Path $ControlRoot "07_DISCOVERY"),
    (Join-Path $ControlRoot "08_BLUEPRINTS"),
    (Join-Path $ControlRoot "09_PARAMETERS"),
    (Join-Path $ControlRoot "10_PROTOCOLS"),
    (Join-Path $ControlRoot "99_LOGS")
)

$AllRoots = @(
    $ControlRoot,$DiscoveryRoot,$PhaseRoot,$DocsRoot,$ProtocolsRoot,$ParametersRoot,$BlueprintsRoot,$ChecklistsRoot,
    $PromptsRoot,$ScriptsRoot,$ReportsRoot,$EvidenceRoot,$SnapshotsRoot,$MonitorRoot,$LogsRoot
) + $LegacyRoots

# =========================
# 1. SAFE HELPERS
# =========================
function New-SafeDirectory {
    param([Parameter(Mandatory=$true)][string]$Path)
    if (-not (Test-Path -LiteralPath $Path)) {
        New-Item -ItemType Directory -Path $Path -Force | Out-Null
    }
}

function Set-ManagedTextFile {
    param(
        [Parameter(Mandatory=$true)][string]$Path,
        [Parameter(Mandatory=$true)][string]$Content
    )
    $parent = Split-Path -Parent $Path
    New-SafeDirectory $parent
    if (Test-Path -LiteralPath $Path) {
        $existing = Get-Content -LiteralPath $Path -Raw -ErrorAction SilentlyContinue
        if ($existing -ne $Content) {
            $backupPath = "$Path.bak.$RunStamp"
            Copy-Item -LiteralPath $Path -Destination $backupPath -Force
        }
    }
    Set-Content -LiteralPath $Path -Value $Content -Encoding UTF8
}

function Add-Log {
    param([string]$Message)
    $line = "[{0}] {1}" -f (Get-Date -Format "yyyy-MM-dd HH:mm:ss"), $Message
    Write-Host $line
    Add-Content -LiteralPath (Join-Path $LogsRoot "PHASE12.0E-pack-create-$RunStamp.log") -Value $line -Encoding UTF8
}

foreach ($root in $AllRoots) { New-SafeDirectory $root }
Add-Log "Created/verified LEOS control folders."

# =========================
# 2. TARGET REGISTRY
# =========================
$TargetRegistryCsv = Join-Path $ChecklistsRoot "PHASE12.0E-TARGET-FILE-REGISTRY.csv"
$TargetRegistry = @(
    [pscustomobject]@{TargetName="Primary Matter UI";Path=(Join-Path $ProjectRoot "frontend\src\pages\Cases.jsx");Classification="READ_ONLY_INSPECT";MayModify="NO";Purpose="Confirm existing UI state fields and current Matter Details implementation."},
    [pscustomobject]@{TargetName="Frontend API Helper";Path=(Join-Path $ProjectRoot "frontend\src\api.js");Classification="READ_ONLY_INSPECT";MayModify="NO";Purpose="Confirm whether matter_type or equivalent is sent or supported."},
    [pscustomobject]@{TargetName="Active Backend Cases Route";Path=(Join-Path $ProjectRoot "backend\src\routes\cases.js");Classification="READ_ONLY_INSPECT";MayModify="NO";Purpose="Confirm backend request/response fields and route logic."},
    [pscustomobject]@{TargetName="Do Not Touch Backup Route";Path=(Join-Path $ProjectRoot "backend\src\routes_BACKUP_BEFORE_ROLE_HARDENING\cases.js");Classification="REFERENCE_ONLY_DO_NOT_TOUCH";MayModify="NO";Purpose="Historical backup route only. Not an active route."}
)
$TargetRegistry | Export-Csv -LiteralPath $TargetRegistryCsv -NoTypeInformation -Encoding UTF8
Add-Log "Created target file registry: $TargetRegistryCsv"

# =========================
# 3. DOCUMENTATION FILES
# =========================
$StartHere = @'
# PHASE 12.0E — START HERE

## Exact Restart Point

PHASE 12.0E — MATTER TYPE BACKEND / DATA SUPPORT DISCOVERY AND CERTIFICATION

## One-Line Meaning

This phase checks whether the system already supports Matter Type and other Matter Details fields before any UI/backend/database patch is allowed.

## Safety Status

This phase is read-only.

Allowed:
- Create governance folders.
- Create documentation.
- Create checklists.
- Create prompts.
- Create reports.
- Read active source files.
- Copy active source files into readonly evidence snapshots.
- Inspect possible SQLite files without writing to them.
- Generate CSV/Markdown discovery reports.
- Monitor local dev ports and Node processes.

Blocked:
- Editing Cases.jsx.
- Editing api.js.
- Editing backend routes.
- Editing SQLite database.
- Running database migrations.
- Renaming files.
- Deleting files.
- Cleaning folders.
- Starting Phase 11.

## Run Order

1. Run the pack creator.
2. Run `Run-PHASE12.0E-ReadOnly-Discovery.ps1`.
3. Run `Start-PHASE12.0E-Live-Monitor.ps1` when the app is running.
4. Run `Create-PHASE12.0E-Final-Certification-Report.ps1`.
5. Read the generated final certification report.
6. Only then decide whether a later patch phase is justified.

## Plain-English Rule

Do not add Matter Type just because we want it. First prove that the database, backend, and frontend can safely carry it.
'@
Set-ManagedTextFile (Join-Path $DocsRoot "00_START_HERE_PHASE12.0E.md") $StartHere

$MasterBlueprint = @'
# PHASE 12.0E MASTER BLUEPRINT

## Project

Litigation 360 LEOS

## Module

Matter Details

## Phase

PHASE 12.0E — Matter Type Backend / Data Support Discovery and Certification

## Purpose

The purpose of this phase is to determine whether the current system can safely support advanced Matter Details fields, especially Matter Type, without guessing.

## Current Known Foundation

The current Matter Details UI foundation is already present. The form appears after clicking Create New Matter. Current supported visible fields include:

- Matter Title
- Linked Client
- Status
- Description / Summary

The backend and database were not modified during the Matter Details UI foundation phase.

## Primary Question

Does the existing system already support these fields?

- matter_type
- matter_number
- priority
- open_date
- person_in_charge
- assistant_or_clerk
- court_related
- court_case_number
- opposing_party
- next_deadline
- notes
- document_linkage

## Discovery Areas

### Frontend UI

File:
`C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\pages\Cases.jsx`

Check:
- Existing state shape.
- Existing form fields.
- Existing submit payload.
- Existing render logic.
- Whether matter_type already exists.

### Frontend API

File:
`C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\frontend\src\api.js`

Check:
- Existing cases API functions.
- Whether request body includes or passes through unknown fields.
- Whether matter_type or case_type exists.

### Backend Route

File:
`C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\backend\src\routes\cases.js`

Check:
- POST create fields.
- PUT/PATCH update fields.
- SELECT list fields.
- INSERT statement fields.
- UPDATE statement fields.
- Validation.
- Error handling.

### Database

Check:
- SQLite file location.
- Table names.
- Column names.
- Whether matter_type or equivalent exists.
- Whether adding new fields would require migration.

## Output Required

This phase must produce:

- Target registry.
- Read-only discovery report.
- Field support matrix.
- Route support matrix.
- Database support matrix.
- API support matrix.
- Risk register.
- Final certification report.
- Clear next recommendation.

## Success Definition

PHASE 12.0E is successful when we can clearly say one of the following:

1. Matter Type is already safely supported and can be exposed in a later frontend patch.
2. Matter Type is partly supported and needs backend/database work first.
3. Matter Type is not supported and must not be added until a migration/route plan is created.

## Non-Success Definition

This phase is not successful if the answer is unclear, assumed, or based only on visual UI preference.
'@
Set-ManagedTextFile (Join-Path $BlueprintsRoot "PHASE12.0E-MASTER-BLUEPRINT.md") $MasterBlueprint

$Parameters = @'
# PHASE 12.0E PARAMETERS

## Fixed Paths

Project Root:
`C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software`

Control Root:
`C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software_LEOS_CONTROL`

Phase Root:
`C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software_LEOS_CONTROL\07_DISCOVERY\PHASE12.0E-MATTER-TYPE-BACKEND-DATA-DISCOVERY`

## Source Files

Primary UI:
`frontend\src\pages\Cases.jsx`

Frontend API:
`frontend\src\api.js`

Active Backend Route:
`backend\src\routes\cases.js`

Backup Route Reference:
`backend\src\routes_BACKUP_BEFORE_ROLE_HARDENING\cases.js`

## Safety Parameters

- Modification permission: NO for active app files.
- Database write permission: NO.
- Migration permission: NO.
- Rename permission: NO.
- Delete permission: NO.
- Backup route edit permission: NEVER unless recovery is expressly approved.

## Discovery Keywords

- matter_type
- matterType
- case_type
- caseType
- type
- priority
- open_date
- opened_at
- person_in_charge
- assigned_to
- lawyer
- clerk
- assistant
- court_related
- court_case_number
- opposing_party
- deadline
- next_deadline
- description
- status
- client_id
- title

## Expected Existing Fields

Based on current known UI foundation:

- title
- client_id
- status
- description

These are not enough to prove Matter Type support.

## Certification Status Values

Use only these values:

- PASS
- FAIL
- PARTIAL
- NOT_FOUND
- NOT_APPLICABLE
- NEEDS_HUMAN_REVIEW
- BLOCKED

## Next-Action Values

Use only these values:

- SAFE_TO_PATCH_FRONTEND_LATER
- NEED_BACKEND_DISCOVERY_MORE
- NEED_DATABASE_DISCOVERY_MORE
- NEED_BACKEND_AND_DATABASE_PLAN
- DO_NOT_PATCH
- READY_FOR_PHASE12.0F_PLANNING
'@
Set-ManagedTextFile (Join-Path $ParametersRoot "PHASE12.0E-PARAMETERS.md") $Parameters

$Protocols = @'
# PHASE 12.0E PROTOCOLS

## Protocol 1 — No Assumption Rule

No field may be added to the UI unless support is proven or a controlled backend/database plan exists.

## Protocol 2 — Read-Only First Rule

The first action must be inspection only.

Do not patch:
- Cases.jsx
- api.js
- cases.js
- SQLite database

## Protocol 3 — Source of Truth Rule

The current SSOT remains the authority. Phase 11 remains locked.

## Protocol 4 — Evidence Rule

Every conclusion must be supported by one or more of:

- File path
- Line match
- CSV finding
- Schema output
- Hash record
- Timestamped report

## Protocol 5 — Database Rule

Do not add matter_type to the database yet.

First check:
- Which SQLite file is active.
- Which table stores cases/matters.
- Which columns exist.
- Whether existing backend SQL mentions the field.

## Protocol 6 — Backend Rule

Do not modify backend routes yet.

First check:
- POST route fields.
- GET route fields.
- PUT/PATCH route fields.
- SQL INSERT fields.
- SQL SELECT fields.
- SQL UPDATE fields.
- Validation.

## Protocol 7 — Frontend Rule

Do not expose Matter Type in the UI yet.

First check:
- State object.
- Form object.
- Submit payload.
- API helper.
- Rendering.

## Protocol 8 — Monitoring Rule

Live monitoring is for visibility only. It must not auto-fix, auto-delete, auto-edit, or auto-migrate.

## Protocol 9 — Patch Gate

A later patch is allowed only if the final certification report says one of:

- SAFE_TO_PATCH_FRONTEND_LATER
- READY_FOR_PHASE12.0F_PLANNING

## Protocol 10 — Stop Rule

Stop immediately if:

- Active source file is missing.
- Backend route cannot be located.
- Database file cannot be identified.
- Build/runtime status conflicts with expected state.
- The discovery report is empty or unclear.
'@
Set-ManagedTextFile (Join-Path $ProtocolsRoot "PHASE12.0E-PROTOCOLS.md") $Protocols

$ChecksBalances = @'
# PHASE 12.0E CHECKS AND BALANCES

## Gate A — Path Gate

Required paths must exist:

- Project root
- Control root
- Cases.jsx
- api.js
- active backend cases.js

If any active file is missing, do not patch.

## Gate B — Hash Gate

Hash the active source files before analysis.

Purpose:
- Prove what was inspected.
- Detect accidental changes.

## Gate C — Snapshot Gate

Copy active text source files into readonly snapshots inside the control root.

Purpose:
- Evidence only.
- Not a working backup for editing.

## Gate D — Field Support Gate

For each field, check four layers:

1. UI field exists.
2. API sends/accepts it.
3. Backend reads/writes it.
4. Database column exists.

Only if all four pass can the field be called fully supported.

## Gate E — Partial Support Rule

If only 1–3 layers pass, mark PARTIAL.

Do not call it supported.

## Gate F — Human Review Gate

Discovery scripts can find text matches. A person must still review whether the match is real support or just a comment/unused code.

## Gate G — Final Certification Gate

No Phase 12.0F patch until final certification report is created and reviewed.

## Gate H — Phase 11 Lock Gate

Nothing in this phase unlocks Phase 11.
'@
Set-ManagedTextFile (Join-Path $ProtocolsRoot "PHASE12.0E-CHECKS-AND-BALANCES.md") $ChecksBalances

$FieldDictionary = @'
# PHASE 12.0E FIELD DICTIONARY

## Current Confirmed Basic Fields

### title
Display name: Matter Title
Meaning: Name/title of the legal matter.
Status: Expected existing field.

### client_id
Display name: Linked Client
Meaning: Links matter/case to a client profile.
Status: Expected existing field.

### status
Display name: Status
Meaning: Current matter lifecycle status.
Status: Expected existing field.

### description
Display name: Description / Summary
Meaning: Short summary of the matter.
Status: Expected existing field.

## Fields Under Discovery

### matter_type
Display name: Matter Type
Meaning: Broad category of legal work.
Examples: Litigation, Advisory, Contract, Debt Recovery, Employment, Family, Criminal, Corporate, Conveyancing, Other.
Required support before UI exposure: database column + backend create/update/list + API payload + frontend form.

### matter_number
Display name: Matter Number
Meaning: Internal file/reference number.
Required support: database column + uniqueness rule or manual rule.

### priority
Display name: Priority
Meaning: Operational urgency.
Examples: Low, Normal, High, Urgent.
Required support: database column + default value.

### open_date
Display name: Open Date
Meaning: Date the matter was opened.
Required support: database column + date handling.

### person_in_charge
Display name: Person In Charge
Meaning: Main lawyer/staff responsible.
Required support: user/staff source must be known.

### assistant_or_clerk
Display name: Assistant / Clerk
Meaning: Supporting staff.
Required support: user/staff source must be known.

### court_related
Display name: Court Related
Meaning: Whether the matter has court involvement.
Required support: boolean/flag column.

### court_case_number
Display name: Court Case Number
Meaning: Official court filing/case number.
Required support: text column and optional validation.

### opposing_party
Display name: Opposing Party
Meaning: Opponent, respondent, defendant, plaintiff, or counterparty.
Required support: text column and privacy handling.

### next_deadline
Display name: Next Deadline
Meaning: Next important deadline date.
Required support: date column or task/deadline module integration.

### notes
Display name: Notes
Meaning: Internal matter notes.
Required support: text column or notes table.

### document_linkage
Display name: Document Linkage
Meaning: Link to matter documents/folders.
Required support: document module or path/link table.
'@
Set-ManagedTextFile (Join-Path $DocsRoot "PHASE12.0E-FIELD-DICTIONARY.md") $FieldDictionary

$TestingPlan = @'
# PHASE 12.0E TESTING PLAN

## Testing Objective

Prove whether Matter Type and related fields are already supported before any patch is made.

## Test Type 1 — Path Tests

Expected result:
- Project root exists.
- Control root exists.
- Cases.jsx exists.
- api.js exists.
- active backend cases.js exists.

Fail action:
- Stop. Do not patch.

## Test Type 2 — Hash Tests

Expected result:
- SHA256 hash recorded for every active target file that exists.

Fail action:
- Mark NEEDS_HUMAN_REVIEW.

## Test Type 3 — Keyword Discovery Tests

Expected result:
- Find exact lines where relevant fields are mentioned.

Important:
- Keyword match does not equal support.
- Human review is required.

## Test Type 4 — Database Discovery Tests

Expected result:
- SQLite-like database files listed.
- If sqlite3 CLI exists, schema exported.
- If sqlite3 CLI does not exist, database status marked NEEDS_HUMAN_REVIEW.

## Test Type 5 — Layer Support Tests

For each field, test:

- UI layer
- API layer
- Backend route layer
- Database layer

Final result:
- Full support only if all required layers pass.

## Test Type 6 — Runtime Monitoring Tests

When app is running, monitor:

- Frontend port 5173
- Backend candidate ports 5000, 5100, 5060, 5061, 8080
- Node process count
- Node memory use
- Target source file last-write timestamps
- Target source file hashes
- CPU and RAM snapshot

## Test Type 7 — Final Certification

The final certification report must say:

- What was found.
- What was not found.
- What is safe.
- What is blocked.
- Recommended next phase.
'@
Set-ManagedTextFile (Join-Path $DocsRoot "PHASE12.0E-TESTING-PLAN.md") $TestingPlan

$Prompts = @'
# PHASE 12.0E READY PROMPTS

## Prompt 1 — New Thread Handover

Use this prompt at the start of a new ChatGPT thread:

I am continuing Litigation 360 LEOS from the current SSOT. Phase 12.0D Matter Details UI Foundation is substantially complete. The form appears after clicking Create New Matter. Backend and database were not modified. Phase 11 remains locked. The next phase is PHASE 12.0E — Matter Type Backend / Data Support Discovery and Certification. This phase is read-only only. Do not patch frontend, backend, or database. Help me run discovery, interpret reports, and decide whether Matter Type can safely be added later.

## Prompt 2 — Discovery Report Interpretation

I have run the PHASE12.0E read-only discovery script. Interpret the discovery report, field support matrix, route findings, and database findings. Tell me exactly which fields are fully supported, partially supported, not supported, or unsafe. Do not suggest a patch unless support is proven.

## Prompt 3 — Backend Review

Review the backend cases route findings. Identify which fields are accepted in POST/PUT, which fields are selected in GET, which fields are inserted/updated in SQL, and whether matter_type is actually supported. Do not guess.

## Prompt 4 — Database Review

Review the SQLite schema output. Identify table names, columns, and whether matter_type or equivalent exists. Tell me whether a migration would be required. Do not write migration code yet.

## Prompt 5 — Safe Later Patch Planning

Based only on the certified Phase 12.0E findings, prepare a later Phase 12.0F patch plan. The plan must include backups, rollback, exact files, exact fields, test cases, and browser checklist. Do not provide direct patch code until I approve.

## Prompt 6 — Layman Explanation

Explain the Phase 12.0E discovery results in layman terms. Tell me what is safe, what is risky, what should be delayed, and what the next button-click action should be.

## Prompt 7 — Stop And Protect

If the discovery shows missing backend or database support, stop the patch path and prepare a safe backend/database planning document instead. Do not modify active code.
'@
Set-ManagedTextFile (Join-Path $PromptsRoot "PHASE12.0E-PROMPTS.md") $Prompts
Set-ManagedTextFile (Join-Path $ControlRoot "06_AI_PROMPTS\PHASE12.0E-PROMPTS.md") $Prompts

$ImplementationOutline = @'
# PHASE 12.0E IMPLEMENTATION OUTLINE

## What This Phase Implements

This phase implements governance and discovery only.

It creates:

- Documentation folder.
- Protocols folder.
- Parameters folder.
- Blueprints folder.
- Checklists folder.
- Prompts folder.
- Scripts folder.
- Reports folder.
- Evidence folder.
- Readonly snapshots folder.
- Live monitoring folder.
- Logs folder.

## What This Phase Does Not Implement

It does not implement Matter Type in the app.

It does not change:

- UI code.
- Backend route code.
- API helper code.
- Database schema.
- Existing data.

## Automation Strategy

The pack creator creates the governance framework once.

The discovery runner creates updated reports whenever run.

The live monitor creates updated runtime monitoring data while running.

The final certification script creates a final decision report.

## Human Workload Reduction

Instead of manually creating many folders and files, this pack creates them automatically with fixed paths.

Instead of manually checking every file from scratch, the discovery runner searches target files and creates evidence CSV files.

Instead of manually checking ports repeatedly, the monitor updates live status files.

## Safe Next Course

Run discovery first. Review report. Then decide whether Phase 12.0F should be frontend-only, backend/database planning, or blocked.
'@
Set-ManagedTextFile (Join-Path $DocsRoot "PHASE12.0E-IMPLEMENTATION-OUTLINE.md") $ImplementationOutline

$DoNotTouch = @'
# PHASE 12.0E DO-NOT-TOUCH LIST

## Do Not Modify

- `frontend\src\pages\Cases.jsx`
- `frontend\src\api.js`
- `backend\src\routes\cases.js`
- any SQLite database file
- package files
- active backend server files
- active frontend configuration files

## Do Not Rename

- Cases.jsx
- cases.js route
- current cases API names
- database tables

## Do Not Delete

- backups
- reports
- snapshots
- source files
- database files

## Do Not Assume

- That Matter Type exists.
- That `type` means Matter Type.
- That comments prove support.
- That UI state proves database support.
- That database column proves backend support.

## Do Not Start

- Phase 11
- production deployment
- client data testing
- real client data entry
'@
Set-ManagedTextFile (Join-Path $DocsRoot "PHASE12.0E-DO-NOT-TOUCH.md") $DoNotTouch

# =========================
# 4. CHECKLIST CSV FILES
# =========================
$VerificationRows = @(
    [pscustomobject]@{Gate="Path Gate";Requirement="Project root exists";Status="PENDING";EvidencePath="";Owner="System/User";Notes=""},
    [pscustomobject]@{Gate="Path Gate";Requirement="Control root exists";Status="PENDING";EvidencePath="";Owner="System/User";Notes=""},
    [pscustomobject]@{Gate="Path Gate";Requirement="Cases.jsx exists";Status="PENDING";EvidencePath="";Owner="System/User";Notes=""},
    [pscustomobject]@{Gate="Path Gate";Requirement="api.js exists";Status="PENDING";EvidencePath="";Owner="System/User";Notes=""},
    [pscustomobject]@{Gate="Path Gate";Requirement="backend cases.js exists";Status="PENDING";EvidencePath="";Owner="System/User";Notes=""},
    [pscustomobject]@{Gate="Hash Gate";Requirement="Target hashes recorded";Status="PENDING";EvidencePath="";Owner="System/User";Notes=""},
    [pscustomobject]@{Gate="Snapshot Gate";Requirement="Readonly source snapshots created";Status="PENDING";EvidencePath="";Owner="System/User";Notes=""},
    [pscustomobject]@{Gate="Field Gate";Requirement="Matter Type support checked across UI/API/backend/database";Status="PENDING";EvidencePath="";Owner="Human Review";Notes=""},
    [pscustomobject]@{Gate="Database Gate";Requirement="SQLite files listed and schema exported if possible";Status="PENDING";EvidencePath="";Owner="System/User";Notes=""},
    [pscustomobject]@{Gate="Final Gate";Requirement="Final certification report created";Status="PENDING";EvidencePath="";Owner="System/User";Notes=""}
)
$VerificationRows | Export-Csv -LiteralPath (Join-Path $ChecklistsRoot "PHASE12.0E-VERIFICATION-CHECKLIST.csv") -NoTypeInformation -Encoding UTF8

$Fields = @("title","client_id","status","description","matter_type","matter_number","priority","open_date","person_in_charge","assistant_or_clerk","court_related","court_case_number","opposing_party","next_deadline","notes","document_linkage")
$FieldRows = foreach ($field in $Fields) {
    [pscustomobject]@{Field=$field;UILayer="PENDING";APILayer="PENDING";BackendLayer="PENDING";DatabaseLayer="PENDING";OverallStatus="PENDING";Evidence="";Recommendation=""}
}
$FieldRows | Export-Csv -LiteralPath (Join-Path $ChecklistsRoot "PHASE12.0E-FIELD-SUPPORT-MATRIX.csv") -NoTypeInformation -Encoding UTF8

$TestCases = @(
    [pscustomobject]@{TestId="12E-T001";TestName="Verify fixed project path";Expected="Path exists";Result="PENDING";Evidence=""},
    [pscustomobject]@{TestId="12E-T002";TestName="Verify active UI target";Expected="Cases.jsx exists";Result="PENDING";Evidence=""},
    [pscustomobject]@{TestId="12E-T003";TestName="Verify active API target";Expected="api.js exists";Result="PENDING";Evidence=""},
    [pscustomobject]@{TestId="12E-T004";TestName="Verify active backend route";Expected="cases.js exists";Result="PENDING";Evidence=""},
    [pscustomobject]@{TestId="12E-T005";TestName="Scan for matter_type";Expected="Matches recorded or NOT_FOUND";Result="PENDING";Evidence=""},
    [pscustomobject]@{TestId="12E-T006";TestName="List SQLite files";Expected="Database candidates recorded";Result="PENDING";Evidence=""},
    [pscustomobject]@{TestId="12E-T007";TestName="Export SQLite schema if sqlite3 is available";Expected="Schema exported or tool missing stated";Result="PENDING";Evidence=""},
    [pscustomobject]@{TestId="12E-T008";TestName="Create final certification";Expected="Certification report exists";Result="PENDING";Evidence=""}
)
$TestCases | Export-Csv -LiteralPath (Join-Path $ChecklistsRoot "PHASE12.0E-TEST-CASES.csv") -NoTypeInformation -Encoding UTF8
Add-Log "Created checklist CSV files."

# =========================
# 5. READ-ONLY DISCOVERY SCRIPT
# =========================
$DiscoveryScript = @'
#requires -Version 5.1
<#
PHASE 12.0E READ-ONLY DISCOVERY RUNNER
This script reads source files, creates evidence reports, and does not modify app code or database.
#>
Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$ProjectRoot = "C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software"
$ControlRoot = "C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software_LEOS_CONTROL"
$PhaseRoot = Join-Path $ControlRoot "07_DISCOVERY\PHASE12.0E-MATTER-TYPE-BACKEND-DATA-DISCOVERY"
$ReportsRoot = Join-Path $PhaseRoot "07_REPORTS"
$EvidenceRoot = Join-Path $PhaseRoot "08_EVIDENCE"
$SnapshotsRoot = Join-Path $PhaseRoot "09_READONLY_SNAPSHOTS"
$LogsRoot = Join-Path $PhaseRoot "99_LOGS"
$RunStamp = Get-Date -Format "yyyyMMdd-HHmmss"

foreach ($p in @($ReportsRoot,$EvidenceRoot,$SnapshotsRoot,$LogsRoot)) {
    if (-not (Test-Path -LiteralPath $p)) { New-Item -ItemType Directory -Path $p -Force | Out-Null }
}

$LogPath = Join-Path $LogsRoot "PHASE12.0E-readonly-discovery-$RunStamp.log"
function Log-Line {
    param([string]$Message)
    $line = "[{0}] {1}" -f (Get-Date -Format "yyyy-MM-dd HH:mm:ss"), $Message
    Write-Host $line
    Add-Content -LiteralPath $LogPath -Value $line -Encoding UTF8
}

function Get-HashOrNA {
    param([string]$Path)
    if (Test-Path -LiteralPath $Path) {
        try { return (Get-FileHash -LiteralPath $Path -Algorithm SHA256).Hash } catch { return "HASH_ERROR: $($_.Exception.Message)" }
    }
    return "NOT_FOUND"
}

function Get-LineCountOrZero {
    param([string]$Path)
    if (Test-Path -LiteralPath $Path) {
        try { return ((Get-Content -LiteralPath $Path -ErrorAction Stop) | Measure-Object -Line).Lines } catch { return 0 }
    }
    return 0
}

Log-Line "Starting PHASE 12.0E read-only discovery."

$Targets = @(
    [pscustomobject]@{Name="Primary Matter UI";Layer="UI";Path=(Join-Path $ProjectRoot "frontend\src\pages\Cases.jsx")},
    [pscustomobject]@{Name="Frontend API Helper";Layer="API";Path=(Join-Path $ProjectRoot "frontend\src\api.js")},
    [pscustomobject]@{Name="Active Backend Cases Route";Layer="BACKEND";Path=(Join-Path $ProjectRoot "backend\src\routes\cases.js")},
    [pscustomobject]@{Name="Backup Route Reference - Do Not Touch";Layer="REFERENCE";Path=(Join-Path $ProjectRoot "backend\src\routes_BACKUP_BEFORE_ROLE_HARDENING\cases.js")}
)

$FileEvidence = foreach ($target in $Targets) {
    $exists = Test-Path -LiteralPath $target.Path
    $item = $null
    if ($exists) { $item = Get-Item -LiteralPath $target.Path }
    [pscustomobject]@{
        RunStamp=$RunStamp
        Name=$target.Name
        Layer=$target.Layer
        Path=$target.Path
        Exists=$exists
        SizeBytes=if ($item) { $item.Length } else { 0 }
        LastWriteTime=if ($item) { $item.LastWriteTime.ToString("yyyy-MM-dd HH:mm:ss") } else { "" }
        LineCount=Get-LineCountOrZero $target.Path
        SHA256=Get-HashOrNA $target.Path
        Classification=if ($target.Layer -eq "REFERENCE") { "REFERENCE_ONLY_DO_NOT_TOUCH" } else { "READ_ONLY_INSPECT" }
    }
}
$FileEvidencePath = Join-Path $EvidenceRoot "PHASE12.0E-target-file-evidence-$RunStamp.csv"
$FileEvidence | Export-Csv -LiteralPath $FileEvidencePath -NoTypeInformation -Encoding UTF8
Log-Line "Wrote target file evidence: $FileEvidencePath"

$SnapshotRunRoot = Join-Path $SnapshotsRoot $RunStamp
New-Item -ItemType Directory -Path $SnapshotRunRoot -Force | Out-Null
foreach ($target in $Targets) {
    if (Test-Path -LiteralPath $target.Path) {
        $safeName = ($target.Name -replace '[^a-zA-Z0-9]+','_').Trim('_')
        $dest = Join-Path $SnapshotRunRoot ("$safeName-" + (Split-Path -Leaf $target.Path))
        Copy-Item -LiteralPath $target.Path -Destination $dest -Force
        Log-Line "Readonly snapshot copied: $dest"
    }
}

$Keywords = @(
    "matter_type","matterType","case_type","caseType","type","priority","open_date","opened_at",
    "person_in_charge","assigned_to","lawyer","clerk","assistant","court_related","court_case_number",
    "opposing_party","deadline","next_deadline","description","status","client_id","title"
)

$MatchRows = New-Object System.Collections.Generic.List[object]
foreach ($target in $Targets) {
    if (Test-Path -LiteralPath $target.Path) {
        foreach ($keyword in $Keywords) {
            $matches = Select-String -LiteralPath $target.Path -Pattern $keyword -SimpleMatch -CaseSensitive:$false -ErrorAction SilentlyContinue
            if ($matches) {
                foreach ($m in $matches) {
                    $trimmed = $m.Line.Trim()
                    if ($trimmed.Length -gt 300) { $trimmed = $trimmed.Substring(0,300) }
                    $MatchRows.Add([pscustomobject]@{
                        RunStamp=$RunStamp
                        Target=$target.Name
                        Layer=$target.Layer
                        Keyword=$keyword
                        Path=$target.Path
                        LineNumber=$m.LineNumber
                        LineText=$trimmed
                    }) | Out-Null
                }
            } else {
                $MatchRows.Add([pscustomobject]@{
                    RunStamp=$RunStamp
                    Target=$target.Name
                    Layer=$target.Layer
                    Keyword=$keyword
                    Path=$target.Path
                    LineNumber=0
                    LineText="NOT_FOUND"
                }) | Out-Null
            }
        }
    } else {
        foreach ($keyword in $Keywords) {
            $MatchRows.Add([pscustomobject]@{
                RunStamp=$RunStamp
                Target=$target.Name
                Layer=$target.Layer
                Keyword=$keyword
                Path=$target.Path
                LineNumber=0
                LineText="TARGET_FILE_NOT_FOUND"
            }) | Out-Null
        }
    }
}
$KeywordEvidencePath = Join-Path $EvidenceRoot "PHASE12.0E-keyword-evidence-$RunStamp.csv"
$MatchRows | Export-Csv -LiteralPath $KeywordEvidencePath -NoTypeInformation -Encoding UTF8
Log-Line "Wrote keyword evidence: $KeywordEvidencePath"

$DbCandidates = @()
if (Test-Path -LiteralPath $ProjectRoot) {
    $DbCandidates = Get-ChildItem -LiteralPath $ProjectRoot -Recurse -File -ErrorAction SilentlyContinue |
        Where-Object {
            $_.Extension -match '^\.(db|sqlite|sqlite3)$' -and
            $_.FullName -notmatch '\\node_modules\\|\\\.git\\|\\dist\\|\\build\\|_LEOS_CONTROL'
        }
}

$DbRows = foreach ($db in $DbCandidates) {
    [pscustomobject]@{
        RunStamp=$RunStamp
        Path=$db.FullName
        Name=$db.Name
        SizeBytes=$db.Length
        LastWriteTime=$db.LastWriteTime.ToString("yyyy-MM-dd HH:mm:ss")
        SHA256=Get-HashOrNA $db.FullName
        Classification="DATABASE_CANDIDATE_READ_ONLY_DO_NOT_WRITE"
    }
}
$DbEvidencePath = Join-Path $EvidenceRoot "PHASE12.0E-database-candidates-$RunStamp.csv"
$DbRows | Export-Csv -LiteralPath $DbEvidencePath -NoTypeInformation -Encoding UTF8
Log-Line "Wrote database candidate evidence: $DbEvidencePath"

$SqliteStatusPath = Join-Path $EvidenceRoot "PHASE12.0E-sqlite-schema-status-$RunStamp.txt"
$sqlite3 = Get-Command sqlite3 -ErrorAction SilentlyContinue
if ($sqlite3 -and $DbCandidates.Count -gt 0) {
    Add-Content -LiteralPath $SqliteStatusPath -Value "sqlite3 found: $($sqlite3.Source)" -Encoding UTF8
    foreach ($db in $DbCandidates) {
        $schemaOut = Join-Path $EvidenceRoot ("PHASE12.0E-schema-" + ($db.BaseName -replace '[^a-zA-Z0-9]+','_') + "-$RunStamp.sql.txt")
        try {
            & $sqlite3.Source $db.FullName ".schema" | Out-File -LiteralPath $schemaOut -Encoding UTF8
            Add-Content -LiteralPath $SqliteStatusPath -Value "Schema exported: $schemaOut" -Encoding UTF8
            Log-Line "SQLite schema exported: $schemaOut"
        } catch {
            Add-Content -LiteralPath $SqliteStatusPath -Value "Schema export failed for $($db.FullName): $($_.Exception.Message)" -Encoding UTF8
            Log-Line "SQLite schema export failed for $($db.FullName)"
        }
    }
} elseif (-not $sqlite3) {
    Set-Content -LiteralPath $SqliteStatusPath -Value "sqlite3 CLI not found. Database candidates were listed, but schema export requires sqlite3 or manual DB inspection." -Encoding UTF8
    Log-Line "sqlite3 CLI not found. Schema export skipped."
} else {
    Set-Content -LiteralPath $SqliteStatusPath -Value "No SQLite database candidates found under project root." -Encoding UTF8
    Log-Line "No SQLite database candidates found."
}

$Fields = @("title","client_id","status","description","matter_type","matter_number","priority","open_date","person_in_charge","assistant_or_clerk","court_related","court_case_number","opposing_party","next_deadline","notes","document_linkage")
$SupportRows = foreach ($field in $Fields) {
    $uiFound = ($MatchRows | Where-Object { $_.Keyword -eq $field -and $_.Layer -eq "UI" -and $_.LineText -ne "NOT_FOUND" -and $_.LineText -ne "TARGET_FILE_NOT_FOUND" } | Measure-Object).Count
    $apiFound = ($MatchRows | Where-Object { $_.Keyword -eq $field -and $_.Layer -eq "API" -and $_.LineText -ne "NOT_FOUND" -and $_.LineText -ne "TARGET_FILE_NOT_FOUND" } | Measure-Object).Count
    $backendFound = ($MatchRows | Where-Object { $_.Keyword -eq $field -and $_.Layer -eq "BACKEND" -and $_.LineText -ne "NOT_FOUND" -and $_.LineText -ne "TARGET_FILE_NOT_FOUND" } | Measure-Object).Count
    $overall = "NEEDS_HUMAN_REVIEW"
    if ($uiFound -eq 0 -and $apiFound -eq 0 -and $backendFound -eq 0) { $overall = "NOT_FOUND_IN_CODE_TARGETS" }
    elseif ($uiFound -gt 0 -and $apiFound -gt 0 -and $backendFound -gt 0) { $overall = "CODE_MATCHES_FOUND_DATABASE_STILL_REQUIRED" }
    else { $overall = "PARTIAL_CODE_MATCH_DATABASE_STILL_REQUIRED" }
    [pscustomobject]@{
        RunStamp=$RunStamp
        Field=$field
        UILayerCodeMatches=$uiFound
        APILayerCodeMatches=$apiFound
        BackendLayerCodeMatches=$backendFound
        DatabaseLayer="CHECK_SCHEMA_OUTPUT_OR_MANUAL_DB_REVIEW"
        OverallPreliminaryStatus=$overall
        ImportantNote="Keyword matches are not proof of support. Human review is required."
    }
}
$SupportMatrixPath = Join-Path $EvidenceRoot "PHASE12.0E-preliminary-field-support-matrix-$RunStamp.csv"
$SupportRows | Export-Csv -LiteralPath $SupportMatrixPath -NoTypeInformation -Encoding UTF8
Log-Line "Wrote preliminary field support matrix: $SupportMatrixPath"

$ReportPath = Join-Path $ReportsRoot "PHASE12.0E-READONLY-DISCOVERY-REPORT-$RunStamp.md"
$lines = New-Object System.Collections.Generic.List[string]
$lines.Add("# PHASE 12.0E READ-ONLY DISCOVERY REPORT")
$lines.Add("")
$lines.Add("Run Stamp: $RunStamp")
$lines.Add("")
$lines.Add("## Safety Statement")
$lines.Add("")
$lines.Add("This discovery run did not modify active frontend code, backend code, or database files. It only created reports, evidence files, and readonly snapshots under the LEOS control root.")
$lines.Add("")
$lines.Add("## Target File Evidence")
$lines.Add("")
$lines.Add("CSV: `$FileEvidencePath`")
$lines.Add("")
foreach ($row in $FileEvidence) {
    $lines.Add("- $($row.Name): Exists=$($row.Exists), Lines=$($row.LineCount), SHA256=$($row.SHA256), Path=$($row.Path)")
}
$lines.Add("")
$lines.Add("## Keyword Evidence")
$lines.Add("")
$lines.Add("CSV: `$KeywordEvidencePath`")
$lines.Add("")
$lines.Add("## Database Candidate Evidence")
$lines.Add("")
$lines.Add("CSV: `$DbEvidencePath`")
$lines.Add("")
if ($DbCandidates.Count -eq 0) {
    $lines.Add("No SQLite database candidates were found under the project root by extension scan.")
} else {
    foreach ($db in $DbCandidates) { $lines.Add("- $($db.FullName)") }
}
$lines.Add("")
$lines.Add("SQLite schema status: `$SqliteStatusPath`")
$lines.Add("")
$lines.Add("## Preliminary Field Support Matrix")
$lines.Add("")
$lines.Add("CSV: `$SupportMatrixPath`")
$lines.Add("")
$lines.Add("Important: preliminary field support is based on keyword/code matches only. It is not final certification.")
$lines.Add("")
$lines.Add("## Recommended Next Action")
$lines.Add("")
$lines.Add("Open the preliminary field support matrix and the keyword evidence CSV. Confirm whether matter_type exists in UI/API/backend/database. Do not patch until final certification is produced.")
$lines | Set-Content -LiteralPath $ReportPath -Encoding UTF8
Log-Line "Wrote discovery report: $ReportPath"

$LatestPointer = Join-Path $ReportsRoot "PHASE12.0E-LATEST-DISCOVERY-REPORT.txt"
Set-Content -LiteralPath $LatestPointer -Value $ReportPath -Encoding UTF8

Log-Line "PHASE 12.0E read-only discovery completed."
Write-Host ""
Write-Host "DONE. Discovery report:" -ForegroundColor Green
Write-Host $ReportPath -ForegroundColor Green
'@
Set-ManagedTextFile (Join-Path $ScriptsRoot "Run-PHASE12.0E-ReadOnly-Discovery.ps1") $DiscoveryScript

# =========================
# 6. LIVE MONITOR SCRIPT
# =========================
$MonitorScript = @'
#requires -Version 5.1
<#
PHASE 12.0E LIVE MONITOR
This monitor updates live CSV/Markdown status files. It does not modify app code or database.
Stop with CTRL+C.
#>
param(
    [int]$IntervalSeconds = 10,
    [int]$MaxLoops = 0
)
Set-StrictMode -Version Latest
$ErrorActionPreference = "Continue"

$ProjectRoot = "C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software"
$ControlRoot = "C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software_LEOS_CONTROL"
$PhaseRoot = Join-Path $ControlRoot "07_DISCOVERY\PHASE12.0E-MATTER-TYPE-BACKEND-DATA-DISCOVERY"
$MonitorRoot = Join-Path $PhaseRoot "10_LIVE_MONITORING"
$LogsRoot = Join-Path $PhaseRoot "99_LOGS"
foreach ($p in @($MonitorRoot,$LogsRoot)) { if (-not (Test-Path -LiteralPath $p)) { New-Item -ItemType Directory -Path $p -Force | Out-Null } }

$RunStamp = Get-Date -Format "yyyyMMdd-HHmmss"
$CsvPath = Join-Path $MonitorRoot "PHASE12.0E-live-monitor-$RunStamp.csv"
$LiveMdPath = Join-Path $MonitorRoot "PHASE12.0E-LIVE-STATUS.md"
$LogPath = Join-Path $LogsRoot "PHASE12.0E-live-monitor-$RunStamp.log"

$Targets = @(
    [pscustomobject]@{Name="Cases.jsx";Path=(Join-Path $ProjectRoot "frontend\src\pages\Cases.jsx")},
    [pscustomobject]@{Name="api.js";Path=(Join-Path $ProjectRoot "frontend\src\api.js")},
    [pscustomobject]@{Name="backend cases.js";Path=(Join-Path $ProjectRoot "backend\src\routes\cases.js")}
)
$Ports = @(5173,5000,5100,5060,5061,8080)

function Get-HashSafe {
    param([string]$Path)
    if (Test-Path -LiteralPath $Path) {
        try { return (Get-FileHash -LiteralPath $Path -Algorithm SHA256).Hash.Substring(0,16) } catch { return "HASH_ERR" }
    }
    return "NOT_FOUND"
}

function Test-PortListen {
    param([int]$Port)
    try {
        $conn = Get-NetTCPConnection -LocalPort $Port -State Listen -ErrorAction SilentlyContinue
        if ($conn) { return "LISTENING" }
        return "NOT_LISTENING"
    } catch {
        $text = netstat -ano | Select-String (":" + $Port)
        if ($text) { return "PRESENT_NETSTAT_CHECK" }
        return "UNKNOWN"
    }
}

function Get-SystemSnapshot {
    $cpu = "NA"
    $mem = "NA"
    try {
        $processor = Get-CimInstance Win32_PerfFormattedData_PerfOS_Processor -Filter "Name='_Total'" -ErrorAction SilentlyContinue
        if ($processor) { $cpu = [string]$processor.PercentProcessorTime }
    } catch {}
    try {
        $os = Get-CimInstance Win32_OperatingSystem -ErrorAction SilentlyContinue
        if ($os) {
            $freeMb = [math]::Round($os.FreePhysicalMemory / 1024, 0)
            $totalMb = [math]::Round($os.TotalVisibleMemorySize / 1024, 0)
            $mem = "$freeMb/$totalMb MB free/total"
        }
    } catch {}
    return [pscustomobject]@{CPUPercent=$cpu;Memory=$mem}
}

"Timestamp,Loop,Frontend5173,Backend5000,Backend5100,Port5060,Port5061,Port8080,NodeProcessCount,NodeMemoryMB,CPUPercent,Memory,FileHashSummary" | Set-Content -LiteralPath $CsvPath -Encoding UTF8
$loop = 0
Write-Host "PHASE 12.0E live monitor started. Stop with CTRL+C." -ForegroundColor Green
Write-Host "CSV: $CsvPath"
Write-Host "Live MD: $LiveMdPath"

while ($true) {
    $loop++
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $portMap = @{}
    foreach ($port in $Ports) { $portMap[[string]$port] = Test-PortListen $port }
    $nodeProcesses = Get-Process node -ErrorAction SilentlyContinue
    $nodeCount = if ($nodeProcesses) { ($nodeProcesses | Measure-Object).Count } else { 0 }
    $nodeMem = if ($nodeProcesses) { [math]::Round((($nodeProcesses | Measure-Object WorkingSet64 -Sum).Sum / 1MB), 1) } else { 0 }
    $sys = Get-SystemSnapshot
    $hashParts = New-Object System.Collections.Generic.List[string]
    foreach ($t in $Targets) {
        $exists = Test-Path -LiteralPath $t.Path
        $last = "NA"
        if ($exists) { try { $last = (Get-Item -LiteralPath $t.Path).LastWriteTime.ToString("HH:mm:ss") } catch {} }
        $hashParts.Add("$($t.Name)=$exists/$last/$(Get-HashSafe $t.Path)") | Out-Null
    }
    $hashSummary = ($hashParts -join " | ").Replace(',', ';')
    $csvLine = '"{0}",{1},"{2}","{3}","{4}","{5}","{6}","{7}",{8},{9},"{10}","{11}","{12}"' -f $timestamp,$loop,$portMap['5173'],$portMap['5000'],$portMap['5100'],$portMap['5060'],$portMap['5061'],$portMap['8080'],$nodeCount,$nodeMem,$sys.CPUPercent,$sys.Memory,$hashSummary
    Add-Content -LiteralPath $CsvPath -Value $csvLine -Encoding UTF8

    $md = New-Object System.Collections.Generic.List[string]
    $md.Add("# PHASE 12.0E LIVE STATUS")
    $md.Add("")
    $md.Add("Last Updated: $timestamp")
    $md.Add("")
    $md.Add("## Ports")
    $md.Add("")
    foreach ($port in $Ports) { $md.Add("- Port $port: $($portMap[[string]$port])") }
    $md.Add("")
    $md.Add("## Node / Runtime")
    $md.Add("")
    $md.Add("- Node process count: $nodeCount")
    $md.Add("- Node memory MB: $nodeMem")
    $md.Add("")
    $md.Add("## System")
    $md.Add("")
    $md.Add("- CPU percent: $($sys.CPUPercent)")
    $md.Add("- Memory: $($sys.Memory)")
    $md.Add("")
    $md.Add("## Target File Watch")
    $md.Add("")
    foreach ($t in $Targets) {
        $exists = Test-Path -LiteralPath $t.Path
        $last = "NA"
        if ($exists) { try { $last = (Get-Item -LiteralPath $t.Path).LastWriteTime.ToString("yyyy-MM-dd HH:mm:ss") } catch {} }
        $md.Add("- $($t.Name): Exists=$exists, LastWrite=$last, HashPrefix=$(Get-HashSafe $t.Path)")
    }
    $md.Add("")
    $md.Add("## Safety")
    $md.Add("")
    $md.Add("This monitor is read-only. It does not edit source code, backend files, or database files.")
    $md | Set-Content -LiteralPath $LiveMdPath -Encoding UTF8

    Add-Content -LiteralPath $LogPath -Value "[$timestamp] loop=$loop ports5173=$($portMap['5173']) node=$nodeCount memMB=$nodeMem" -Encoding UTF8
    Write-Host "[$timestamp] 5173=$($portMap['5173']) 5000=$($portMap['5000']) 5100=$($portMap['5100']) node=$nodeCount memMB=$nodeMem"

    if ($MaxLoops -gt 0 -and $loop -ge $MaxLoops) { break }
    Start-Sleep -Seconds $IntervalSeconds
}
'@
Set-ManagedTextFile (Join-Path $ScriptsRoot "Start-PHASE12.0E-Live-Monitor.ps1") $MonitorScript
Set-ManagedTextFile (Join-Path $ControlRoot "05_MONITORING\Start-PHASE12.0E-Live-Monitor.ps1") $MonitorScript

# =========================
# 7. FINAL CERTIFICATION SCRIPT
# =========================
$CertificationScript = @'
#requires -Version 5.1
<#
PHASE 12.0E FINAL CERTIFICATION REPORT CREATOR
Creates a final human-review certification shell from the latest discovery evidence.
#>
Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$ControlRoot = "C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software_LEOS_CONTROL"
$PhaseRoot = Join-Path $ControlRoot "07_DISCOVERY\PHASE12.0E-MATTER-TYPE-BACKEND-DATA-DISCOVERY"
$ReportsRoot = Join-Path $PhaseRoot "07_REPORTS"
$EvidenceRoot = Join-Path $PhaseRoot "08_EVIDENCE"
$RunStamp = Get-Date -Format "yyyyMMdd-HHmmss"
if (-not (Test-Path -LiteralPath $ReportsRoot)) { New-Item -ItemType Directory -Path $ReportsRoot -Force | Out-Null }

$latestDiscoveryPointer = Join-Path $ReportsRoot "PHASE12.0E-LATEST-DISCOVERY-REPORT.txt"
$latestDiscovery = "NOT_FOUND"
if (Test-Path -LiteralPath $latestDiscoveryPointer) { $latestDiscovery = Get-Content -LiteralPath $latestDiscoveryPointer -Raw }

$latestSupport = Get-ChildItem -LiteralPath $EvidenceRoot -Filter "PHASE12.0E-preliminary-field-support-matrix-*.csv" -File -ErrorAction SilentlyContinue | Sort-Object LastWriteTime -Descending | Select-Object -First 1
$latestKeyword = Get-ChildItem -LiteralPath $EvidenceRoot -Filter "PHASE12.0E-keyword-evidence-*.csv" -File -ErrorAction SilentlyContinue | Sort-Object LastWriteTime -Descending | Select-Object -First 1
$latestDb = Get-ChildItem -LiteralPath $EvidenceRoot -Filter "PHASE12.0E-database-candidates-*.csv" -File -ErrorAction SilentlyContinue | Sort-Object LastWriteTime -Descending | Select-Object -First 1

$matterTypeStatus = "NEEDS_HUMAN_REVIEW"
$recommendedNext = "DO_NOT_PATCH_UNTIL_HUMAN_REVIEW"
if ($latestSupport) {
    $rows = Import-Csv -LiteralPath $latestSupport.FullName
    $mt = $rows | Where-Object { $_.Field -eq "matter_type" } | Select-Object -First 1
    if ($mt) {
        $matterTypeStatus = $mt.OverallPreliminaryStatus
        if ($mt.OverallPreliminaryStatus -eq "CODE_MATCHES_FOUND_DATABASE_STILL_REQUIRED") {
            $recommendedNext = "REVIEW_DATABASE_SCHEMA_BEFORE_PATCH"
        } elseif ($mt.OverallPreliminaryStatus -eq "NOT_FOUND_IN_CODE_TARGETS") {
            $recommendedNext = "NEED_BACKEND_AND_DATABASE_PLAN"
        } else {
            $recommendedNext = "NEEDS_HUMAN_REVIEW"
        }
    }
}

$ReportPath = Join-Path $ReportsRoot "PHASE12.0E-FINAL-CERTIFICATION-REPORT-$RunStamp.md"
$lines = New-Object System.Collections.Generic.List[string]
$lines.Add("# PHASE 12.0E FINAL CERTIFICATION REPORT")
$lines.Add("")
$lines.Add("Run Stamp: $RunStamp")
$lines.Add("")
$lines.Add("## Certification Result")
$lines.Add("")
$lines.Add("Status: NEEDS_HUMAN_REVIEW")
$lines.Add("")
$lines.Add("Reason: The script can collect evidence, but a human must confirm whether keyword matches are real working support.")
$lines.Add("")
$lines.Add("## Matter Type Preliminary Status")
$lines.Add("")
$lines.Add("matter_type: $matterTypeStatus")
$lines.Add("")
$lines.Add("Recommended next action: $recommendedNext")
$lines.Add("")
$lines.Add("## Evidence Files")
$lines.Add("")
$lines.Add("- Latest discovery report: $latestDiscovery")
$lines.Add("- Latest support matrix: $(if ($latestSupport) { $latestSupport.FullName } else { 'NOT_FOUND' })")
$lines.Add("- Latest keyword evidence: $(if ($latestKeyword) { $latestKeyword.FullName } else { 'NOT_FOUND' })")
$lines.Add("- Latest database candidates: $(if ($latestDb) { $latestDb.FullName } else { 'NOT_FOUND' })")
$lines.Add("")
$lines.Add("## Hard Safety Decision")
$lines.Add("")
$lines.Add("Do not add Matter Type to the UI unless database support and backend support are confirmed.")
$lines.Add("")
$lines.Add("## Human Review Checklist")
$lines.Add("")
$lines.Add("- [ ] Confirm active backend route fields.")
$lines.Add("- [ ] Confirm active database table and columns.")
$lines.Add("- [ ] Confirm whether matter_type exists as a real persisted field.")
$lines.Add("- [ ] Confirm whether frontend API passes the field.")
$lines.Add("- [ ] Confirm whether UI state includes the field.")
$lines.Add("- [ ] Decide whether Phase 12.0F is frontend-only, backend/database planning, or blocked.")
$lines.Add("")
$lines.Add("## Phase 11")
$lines.Add("")
$lines.Add("Phase 11 remains locked.")
$lines | Set-Content -LiteralPath $ReportPath -Encoding UTF8
Write-Host "Final certification report created:" -ForegroundColor Green
Write-Host $ReportPath -ForegroundColor Green
'@
Set-ManagedTextFile (Join-Path $ScriptsRoot "Create-PHASE12.0E-Final-Certification-Report.ps1") $CertificationScript

# =========================
# 8. RUN ALL READ-ONLY SCRIPT
# =========================
$RunAllScript = @'
#requires -Version 5.1
<#
Runs the PHASE 12.0E read-only discovery and then creates the final certification shell.
It does not start the live monitor because the monitor is long-running and should be launched separately.
#>
Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$ControlRoot = "C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software_LEOS_CONTROL"
$ScriptsRoot = Join-Path $ControlRoot "07_DISCOVERY\PHASE12.0E-MATTER-TYPE-BACKEND-DATA-DISCOVERY\06_SCRIPTS"
$Discovery = Join-Path $ScriptsRoot "Run-PHASE12.0E-ReadOnly-Discovery.ps1"
$Cert = Join-Path $ScriptsRoot "Create-PHASE12.0E-Final-Certification-Report.ps1"

Write-Host "Running Phase 12.0E read-only discovery..." -ForegroundColor Cyan
& powershell -ExecutionPolicy Bypass -NoProfile -File $Discovery
Write-Host "Creating Phase 12.0E final certification report..." -ForegroundColor Cyan
& powershell -ExecutionPolicy Bypass -NoProfile -File $Cert
Write-Host "Done. Review the reports folder." -ForegroundColor Green
'@
Set-ManagedTextFile (Join-Path $ScriptsRoot "Run-PHASE12.0E-All-ReadOnly.ps1") $RunAllScript

# =========================
# 9. RUN ORDER DOCUMENT
# =========================
$RunOrder = @"
# PHASE 12.0E RUN ORDER

## 1. Run Discovery Pack Creator

You have already run or are about to run:

```powershell
powershell -ExecutionPolicy Bypass -NoProfile -File "$PhaseRoot\PHASE12.0E-CREATE-DISCOVERY-PACK.ps1"
```

## 2. Run Read-Only Discovery

```powershell
powershell -ExecutionPolicy Bypass -NoProfile -File "$ScriptsRoot\Run-PHASE12.0E-ReadOnly-Discovery.ps1"
```

## 3. Optional: Run All Read-Only Discovery + Certification

```powershell
powershell -ExecutionPolicy Bypass -NoProfile -File "$ScriptsRoot\Run-PHASE12.0E-All-ReadOnly.ps1"
```

## 4. Start Live Monitor

Open a separate PowerShell window and run:

```powershell
powershell -ExecutionPolicy Bypass -NoProfile -File "$ScriptsRoot\Start-PHASE12.0E-Live-Monitor.ps1" -IntervalSeconds 10
```

Stop the monitor with CTRL+C.

## 5. Create Final Certification Report

```powershell
powershell -ExecutionPolicy Bypass -NoProfile -File "$ScriptsRoot\Create-PHASE12.0E-Final-Certification-Report.ps1"
```

## 6. Read Reports

Reports folder:

`$ReportsRoot`

Evidence folder:

`$EvidenceRoot`

Live monitoring folder:

`$MonitorRoot`

## 7. Decision Rule

Do not patch until the final certification report is reviewed.
"@
Set-ManagedTextFile (Join-Path $DocsRoot "PHASE12.0E-RUN-ORDER.md") $RunOrder
Set-ManagedTextFile (Join-Path $PhaseRoot "README-RUN-ORDER.md") $RunOrder

# =========================
# 10. PLACE A COPY OF THIS CREATOR INTO PHASE ROOT
# =========================
$SelfCopyPath = Join-Path $PhaseRoot "PHASE12.0E-CREATE-DISCOVERY-PACK.ps1"
try {
    if ($PSCommandPath -and (Test-Path -LiteralPath $PSCommandPath)) {
        Copy-Item -LiteralPath $PSCommandPath -Destination $SelfCopyPath -Force
    }
} catch {
    Add-Log "Self-copy skipped: $($_.Exception.Message)"
}

# =========================
# 11. SUMMARY REPORT
# =========================
$SummaryLines = @(
    "# PHASE 12.0E PACK CREATION SUMMARY",
    "",
    "Created: $RunStamp",
    "",
    "Phase Root: $PhaseRoot",
    "",
    "Created Main Folders:",
    "- $DocsRoot",
    "- $ProtocolsRoot",
    "- $ParametersRoot",
    "- $BlueprintsRoot",
    "- $ChecklistsRoot",
    "- $PromptsRoot",
    "- $ScriptsRoot",
    "- $ReportsRoot",
    "- $EvidenceRoot",
    "- $SnapshotsRoot",
    "- $MonitorRoot",
    "- $LogsRoot",
    "",
    "Created Main Scripts:",
    "- $ScriptsRoot\Run-PHASE12.0E-ReadOnly-Discovery.ps1",
    "- $ScriptsRoot\Start-PHASE12.0E-Live-Monitor.ps1",
    "- $ScriptsRoot\Create-PHASE12.0E-Final-Certification-Report.ps1",
    "- $ScriptsRoot\Run-PHASE12.0E-All-ReadOnly.ps1",
    "",
    "Safety Result:",
    "No active frontend, backend, or database files were modified by this pack creator.",
    "",
    "Next Command:",
    "powershell -ExecutionPolicy Bypass -NoProfile -File `"$ScriptsRoot\Run-PHASE12.0E-All-ReadOnly.ps1`"",
    "",
    "Optional Live Monitor Command:",
    "powershell -ExecutionPolicy Bypass -NoProfile -File `"$ScriptsRoot\Start-PHASE12.0E-Live-Monitor.ps1`" -IntervalSeconds 10"
)
$Summary = $SummaryLines -join [Environment]::NewLine
$SummaryPath = Join-Path $ReportsRoot "PHASE12.0E-PACK-CREATION-SUMMARY-$RunStamp.md"
Set-ManagedTextFile $SummaryPath $Summary

Add-Log "Created pack summary: $SummaryPath"
Write-Host ""
Write-Host "============================================================" -ForegroundColor Green
Write-Host "PHASE 12.0E DISCOVERY PACK CREATED SUCCESSFULLY" -ForegroundColor Green
Write-Host "============================================================" -ForegroundColor Green
Write-Host "Phase Root:" -ForegroundColor Cyan
Write-Host $PhaseRoot
Write-Host ""
Write-Host "Next recommended command:" -ForegroundColor Cyan
Write-Host "powershell -ExecutionPolicy Bypass -NoProfile -File `"$ScriptsRoot\Run-PHASE12.0E-All-ReadOnly.ps1`""
Write-Host ""
Write-Host "Optional live monitor command:" -ForegroundColor Cyan
Write-Host "powershell -ExecutionPolicy Bypass -NoProfile -File `"$ScriptsRoot\Start-PHASE12.0E-Live-Monitor.ps1`" -IntervalSeconds 10"
Write-Host ""
Write-Host "Summary report:" -ForegroundColor Cyan
Write-Host $SummaryPath
Write-Host "============================================================" -ForegroundColor Green

Write-Host ""
Write-Host "Script finished. Press ENTER to close." -ForegroundColor Yellow
Read-Host | Out-Null
