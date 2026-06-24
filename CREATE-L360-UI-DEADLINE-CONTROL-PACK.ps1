<#
LITIGATION 360 - PHASE 12.1A UI + DEADLINE CONTROL PACK CREATOR
Purpose:
- Create a safe documentation, protocol, monitoring, and Cursor handover pack.
- Does NOT modify backend, database, authentication, RBAC, API routes, or production logic.
- Creates only control/documentation/helper files under _L360_CONTROL.

How to run:
powershell -NoProfile -ExecutionPolicy Bypass -File "C:\Users\jep_edmundrulz\Downloads\CREATE-L360-UI-DEADLINE-CONTROL-PACK.ps1"

Optional custom project root:
powershell -NoProfile -ExecutionPolicy Bypass -File "C:\Users\jep_edmundrulz\Downloads\CREATE-L360-UI-DEADLINE-CONTROL-PACK.ps1" -ProjectRoot "C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software"
#>

[CmdletBinding()]
param(
    [string]$ProjectRoot = "C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software"
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

function Write-Step {
    param([string]$Message, [string]$Color = "White")
    Write-Host ("[{0}] {1}" -f (Get-Date -Format "yyyy-MM-dd HH:mm:ss"), $Message) -ForegroundColor $Color
}

function Ensure-Directory {
    param([string]$Path)
    if (-not (Test-Path -LiteralPath $Path)) {
        New-Item -ItemType Directory -Path $Path -Force | Out-Null
        Write-Step ("Created folder: {0}" -f $Path) "Green"
    }
    else {
        Write-Step ("Folder already exists: {0}" -f $Path) "DarkGray"
    }
}

function Write-Doc {
    param(
        [string]$Path,
        [string]$Content
    )

    $parent = Split-Path -Parent $Path
    Ensure-Directory $parent

    if (Test-Path -LiteralPath $Path) {
        $timestamp = Get-Date -Format "yyyyMMdd-HHmmss"
        $backup = "{0}.bak-{1}" -f $Path, $timestamp
        Copy-Item -LiteralPath $Path -Destination $backup -Force
        Write-Step ("Backup created before overwrite: {0}" -f $backup) "Yellow"
    }

    Set-Content -LiteralPath $Path -Value $Content -Encoding UTF8
    Write-Step ("Wrote file: {0}" -f $Path) "Cyan"
}

function Append-Progress {
    param(
        [string]$Stage,
        [string]$Status,
        [string]$Notes
    )

    $line = '"{0}","{1}","{2}","{3}"' -f (Get-Date -Format "yyyy-MM-dd HH:mm:ss"), $Stage.Replace('"','""'), $Status.Replace('"','""'), $Notes.Replace('"','""')
    Add-Content -LiteralPath $script:ProgressCsv -Value $line -Encoding UTF8
}

Write-Host ""
Write-Host "============================================================" -ForegroundColor Cyan
Write-Host " LITIGATION 360 - UI + DEADLINE CONTROL PACK CREATOR" -ForegroundColor Cyan
Write-Host "============================================================" -ForegroundColor Cyan
Write-Host ""

if (-not (Test-Path -LiteralPath $ProjectRoot)) {
    throw "Project root not found: $ProjectRoot. Confirm the exact project path before running this script."
}

$timestamp = Get-Date -Format "yyyyMMdd-HHmmss"
$ControlRoot = Join-Path $ProjectRoot "_L360_CONTROL"
$PhaseRoot = Join-Path $ControlRoot "PHASE-12-1A-UI-DEADLINE-STANDARDIZATION"
$ToolsRoot = Join-Path $PhaseRoot "TOOLS"
$ProgressCsv = Join-Path $PhaseRoot "08_LOGS\LIVE-PROGRESS-LOG.csv"
$ProgressJson = Join-Path $PhaseRoot "05_MONITORING\phase-progress-current.json"

$folders = @(
    $ControlRoot,
    $PhaseRoot,
    (Join-Path $PhaseRoot "00_READ_FIRST"),
    (Join-Path $PhaseRoot "01_BLUEPRINTS"),
    (Join-Path $PhaseRoot "02_PROTOCOLS"),
    (Join-Path $PhaseRoot "03_CURSOR_PROMPTS"),
    (Join-Path $PhaseRoot "04_TESTING"),
    (Join-Path $PhaseRoot "05_MONITORING"),
    (Join-Path $PhaseRoot "06_REPORTS"),
    (Join-Path $PhaseRoot "07_ROLLBACK"),
    (Join-Path $PhaseRoot "08_LOGS"),
    (Join-Path $PhaseRoot "09_SCREENSHOTS_PLACEHOLDER"),
    (Join-Path $PhaseRoot "10_HANDOVER"),
    $ToolsRoot
)

foreach ($folder in $folders) {
    Ensure-Directory $folder
}

if (-not (Test-Path -LiteralPath $ProgressCsv)) {
    Set-Content -LiteralPath $ProgressCsv -Value '"Timestamp","Stage","Status","Notes"' -Encoding UTF8
}

Append-Progress -Stage "Pack Creation" -Status "STARTED" -Notes "Creating safe UI/deadline control documentation pack."

$readme = @'
# Litigation 360 - Phase 12.1A UI + Deadline Standardization Control Pack

## Purpose

This folder is the safe Single Source of Truth for the next workstream:

1. Standardize the sidebar.
2. Upgrade the Deadline page from a basic form/list into a legal Deadline Control Centre.
3. Add documentation, protocols, verification, testing, monitoring, and rollback rules.
4. Reduce manual wrong-folder / wrong-file edits.
5. Keep work conservative and safe.

## Absolute Rule

This control pack does not authorize random backend edits.

Do not edit the following unless there is a separate written approval:

- database schema
- migrations
- authentication
- RBAC
- production API routes
- server boot files
- payment/financial logic
- production deployment configuration

## Current Visual Finding

From the screenshots, the sidebar is not visually contained. The dark sidebar background stops before all menu items have completed, causing lower menu buttons to appear on a white background.

The Deadline page is currently a basic prototype. It needs:

- warning states
- countdowns
- reminder triggers
- top alert cards
- status badges
- empty state
- filter/sort
- audit-safe prompts
- completion/archive actions
- notification placeholders

## Working Method

1. Read this folder first.
2. Run preflight checks.
3. Let Cursor inspect file locations.
4. Make frontend-only changes.
5. Test visually.
6. Log every step.
7. Do not touch protected areas.
8. If uncertain, stop and document.
'@

$noBackend = @'
# No Direct Backend Edit Rules

## Protected Files / Areas

Unless separately approved, do not modify:

- server.js
- app.js
- database connection files
- migration files
- seed files
- authentication files
- RBAC / permissions files
- API route handlers
- production environment files
- .env files
- package-lock.json unless dependency changes are approved
- deployment scripts

## Allowed Safe Work For This Phase

Allowed:

- frontend component layout
- CSS / styling
- sidebar visual containment
- reusable sidebar item component
- Deadline page UI improvements
- frontend-only status calculation
- static placeholder notification panel
- documentation
- test checklists
- screenshots
- progress logs

## Stop Conditions

Stop immediately if any requested change requires:

- schema change
- backend route change
- auth/RBAC change
- deletion of existing records
- production logic edit
- unclear file ownership
- unclear data source

When a stop condition happens, write the issue into:

08_LOGS/LIVE-PROGRESS-LOG.csv
'@

$sidebarBlueprint = @'
# Sidebar Standardization Blueprint

## Problem Observed

The sidebar dark background does not extend behind every menu item. Lower items appear outside the dark panel.

## Likely Causes

1. Sidebar container has fixed height and content overflows.
2. Some navigation items are outside the sidebar wrapper.
3. There are separate sidebar sections instead of one parent container.
4. Parent layout allows white page background to appear behind menu items.
5. Overflow handling is missing or incorrect.

## Required Final Result

The sidebar must be one continuous dark vertical panel from top to bottom.

All items must be inside the same sidebar container:

- Litigation 360
- End User Workspace
- Operations Centre
- Admin Centre
- Developer Centre
- Legal Tools section
- Legal Web Links
- Launch Apps / Docs
- Search Repository
- Instructions
- Glossary
- Firm Info
- Managing Partner
- Settings

## UI Standard Parameters

Use one standard nav-item design:

- same width
- same min-height
- same border radius
- same horizontal padding
- same icon box size
- same font size
- same font weight
- same gap between icon and label
- same margin between items
- same active state
- same hover state

## CSS Direction

Recommended safe CSS concepts:

- sidebar root: min-height: 100vh
- sidebar root: background: dark theme color
- sidebar root: overflow-y: auto
- nav content stays inside aside/sidebar
- page content uses margin-left or grid layout; must not overlap sidebar
- avoid hardcoded heights that clip content

## Acceptance Criteria

Pass only when:

1. No sidebar item appears on white background.
2. Scrolling still keeps dark background behind all sidebar items.
3. Active item style is consistent.
4. Normal item style is consistent.
5. The sidebar does not overlap the page content.
6. No console errors appear.
7. No backend files were touched.
'@

$deadlineBlueprint = @'
# Deadline Control Centre Blueprint

## Current State

The Deadline page currently appears to provide:

- Add Deadline button
- filter dropdown
- Deadline Title
- Due Date
- Reminder days before deadline
- Associated Case
- Notes
- Create Deadline
- Cancel
- list area

This is not enough for a legal operations platform. It is only a basic data entry screen.

## Required Final State

The page must become a Deadline Control Centre.

## Top Summary Cards

Add summary cards:

- Total Deadlines
- Overdue
- Due Today
- Due This Week
- Upcoming
- Completed

## Status Calculation

Suggested frontend-safe status logic:

1. If completed is true: Completed
2. Else if due date is before today: Overdue
3. Else if due date is today: Due Today
4. Else if due date is within reminder-days window: Due Soon
5. Else: Upcoming

## Visual Status Parameters

Use strong labels:

- Overdue: immediate attention required
- Due Today: due today, review now
- Due Soon: reminder window active
- Upcoming: scheduled
- Completed: done
- Archived: inactive / retained

## Required Deadline Fields

Each deadline card/row should display:

- deadline title
- associated case
- due date
- days remaining
- reminder days
- reminder trigger date
- status
- assigned person if available
- notes if available
- created date if available
- last updated date if available

## User Attention Prompts

Show prompts when needed:

- Overdue: Immediate action required.
- Due today: Due today. Please review now.
- Due soon: Reminder window active.
- No associated case: No case linked. Please attach this deadline to a case.
- No notes: Consider adding notes or filing instructions.

## Actions Per Deadline

Use safe actions:

- View
- Edit
- Mark Complete
- Snooze Reminder
- Archive

Prefer Archive over permanent Delete.

## Filters

Required filters:

- All Deadlines
- Overdue
- Due Today
- Due This Week
- Upcoming
- Completed
- Archived, if supported

## Sorting

Default:

1. Overdue first
2. Due today next
3. Due soon next
4. Upcoming by nearest due date
5. Completed last

## Notification Placeholder

If real notifications are not implemented yet, include a visible placeholder:

Notification Engine: Pending Integration

Planned channels:

- in-app alerts
- dashboard alerts
- browser notification permission
- email
- WhatsApp/SMS future option

## Acceptance Criteria

Pass only when:

1. Empty state looks professional.
2. Add Deadline opens and closes correctly.
3. Required fields validate correctly.
4. Deadline status appears correctly.
5. Overdue and due-today items are visually obvious.
6. Reminder text appears clearly.
7. Filter works.
8. Sort works.
9. No backend files were modified.
10. No console errors appear.
'@

$safeEditProtocol = @'
# Safe Edit Protocol

## Before Any Edit

1. Confirm current branch.
2. Confirm project root.
3. Run preflight script.
4. Locate actual sidebar file.
5. Locate actual Deadline page file.
6. Read file before editing.
7. Make the smallest safe change.
8. Test.
9. Log progress.

## Conservative Edit Rule

Only one work unit at a time:

1. Sidebar containment fix.
2. Sidebar item standardization.
3. Deadline page visual layout.
4. Deadline status calculations.
5. Deadline prompts and summary cards.
6. Testing and report.

Do not combine all changes in one risky edit.

## Files To Identify Before Editing

Cursor must locate the real files before modifying anything.

Possible locations to search:

- src
- app
- pages
- components
- layouts
- client
- frontend
- views

Possible file keywords:

- Sidebar
- Navigation
- Layout
- Deadline
- Deadlines
- deadline
- deadlines

## Required Check After Every Edit

Run the app locally and check:

- page loads
- sidebar renders correctly
- Deadline page renders correctly
- no console errors
- no terminal errors
- no broken route
- no blank screen
- no accidental backend edits
'@

$noContinuation = @'
# PowerShell No Continuation Prompt Protocol

## What The >> Prompt Means

If PowerShell shows:

>>

it means PowerShell thinks your command is not finished.

Common causes:

- missing closing quote
- missing closing bracket
- missing closing brace
- unfinished pipe symbol
- incomplete here-string
- copy/paste was cut off halfway
- curly/smart quotes from formatted text

## Immediate Fix

If you see >> and you are stuck:

Press:

Ctrl + C

Then wait until the normal prompt returns:

PS C:\...>

Do not continue typing random lines into >>.

## Safe Method For Large Scripts

Do not paste huge scripts directly into the PowerShell console.

Use this method:

1. Save the script as a .ps1 file.
2. Run it with -File.

Example:

powershell -NoProfile -ExecutionPolicy Bypass -File "C:\Users\jep_edmundrulz\Downloads\CREATE-L360-UI-DEADLINE-CONTROL-PACK.ps1"

## Parser Check Before Running

Use this before running any saved script:

$ScriptPath = "C:\Users\jep_edmundrulz\Downloads\CREATE-L360-UI-DEADLINE-CONTROL-PACK.ps1"
$Raw = Get-Content -LiteralPath $ScriptPath -Raw
[void][scriptblock]::Create($Raw)
Write-Host "Parser check passed." -ForegroundColor Green

If this throws an error, do not run the script.
'@

$cursorSidebar = @'
# Cursor Prompt 01 - Sidebar Fix

You are working inside this project:

C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software

Task:
Fix the Litigation 360 sidebar layout and standardize its menu styling.

Current visual problem:
The dark sidebar background stops partway down the menu. Lower menu items such as Glossary, Firm Info, Managing Partner, and Settings appear against a white background instead of inside one continuous sidebar.

Non-negotiable safety rules:
- Do not modify backend files.
- Do not modify database schema.
- Do not modify auth/RBAC.
- Do not modify API routes.
- Do not modify production deployment files.
- Frontend/layout/CSS/component work only.

Required result:
1. All sidebar items must be inside one continuous sidebar container.
2. Dark background must extend behind all sidebar items from top to bottom.
3. Sidebar should support internal scrolling if content is taller than viewport.
4. All nav items must share one standardized style.
5. Active, hover, and normal states must be consistent.
6. Page content must not overlap the sidebar.

Implementation direction:
- Locate sidebar/navigation/layout files first.
- Inspect before editing.
- Prefer reusable class/component instead of duplicated styles.
- Use min-height: 100vh and overflow-y: auto where appropriate.
- Avoid fixed heights that clip content.
- Ensure lower items are not outside the aside/sidebar wrapper.

After editing:
- Report exact files changed.
- Confirm no protected files were changed.
- Confirm visual acceptance criteria.
- Confirm no console errors.
'@

$cursorDeadline = @'
# Cursor Prompt 02 - Deadline Control Centre Upgrade

You are working inside this project:

C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software

Task:
Upgrade the Deadline page from a basic form/list into a proper legal Deadline Control Centre.

Non-negotiable safety rules:
- Do not modify backend files.
- Do not modify database schema.
- Do not modify auth/RBAC.
- Do not modify API routes.
- Do not modify production deployment files.
- Prefer frontend-safe improvements only.

Current page:
- Add Deadline button
- Filter dropdown
- Add New Deadline form
- Deadline Title
- Due Date
- Reminder days before deadline
- Associated Case
- Notes
- Create Deadline / Cancel
- Empty deadline list

Required improvements:
1. Add top summary cards:
   - Total
   - Overdue
   - Due Today
   - Due This Week
   - Upcoming
   - Completed

2. Add deadline status calculation:
   - Completed
   - Overdue
   - Due Today
   - Due Soon
   - Upcoming

3. Add visual status badges:
   - Overdue
   - Due Today
   - Due Soon
   - Upcoming
   - Completed

4. Add reminder text:
   - reminder days
   - reminder trigger date
   - days remaining
   - warning when reminder window is active

5. Add user attention prompts:
   - Immediate action required.
   - Due today. Please review now.
   - Reminder window active.
   - No case linked. Please attach this deadline to a case.
   - Consider adding notes or filing instructions.

6. Add action buttons where supported:
   - View
   - Edit
   - Mark Complete
   - Snooze Reminder
   - Archive

7. Add proper filters:
   - All Deadlines
   - Overdue
   - Due Today
   - Due This Week
   - Upcoming
   - Completed
   - Archived if supported

8. Add professional empty state:
   "No deadlines yet. Create your first legal deadline to track court filings, hearings, submissions, limitation dates, and internal reminders."

9. Add Notification Engine placeholder:
   - In-app alerts
   - Dashboard alerts
   - Browser notifications
   - Email notifications
   - WhatsApp/SMS future option

Testing required:
- zero deadlines
- one upcoming deadline
- one due-soon deadline
- one due-today deadline
- one overdue deadline
- one completed deadline
- filter each status
- check console errors
- check responsive layout
- confirm no protected files changed

After editing:
- Report exact files changed.
- Report what remains pending.
- Do not claim real notifications exist unless actually implemented.
'@

$cursorTesting = @'
# Cursor Prompt 03 - Testing Only

You are working inside this project:

C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software

Task:
Perform verification only. Do not make code changes unless separately instructed.

Check:

1. Sidebar:
- dark background covers all menu items
- all nav items are inside sidebar
- no white gap behind lower items
- scrolling works
- active state works
- hover state works
- no overlap with main content

2. Deadline page:
- empty state appears correctly
- Add Deadline opens
- Cancel closes form
- required fields validate
- created deadline appears
- status badge appears
- overdue warning appears
- due-today warning appears
- due-soon warning appears
- filter works
- sort works
- no console errors

3. Safety:
- no backend files changed
- no auth/RBAC files changed
- no database files changed
- no API route files changed
- no .env files changed

Output:
- exact result
- pass/fail table
- exact files inspected
- exact files changed, if any
- remaining risks
'@

$manualQa = @'
# Manual QA Checklist

## Sidebar QA

| Check | Expected | Pass/Fail | Notes |
|---|---|---|---|
| Sidebar loads | Visible on left |  |  |
| Dark background continuous | No white gap behind items |  |  |
| Legal Web Links active state | Active style clear |  |  |
| Glossary item | Inside dark sidebar |  |  |
| Firm Info item | Inside dark sidebar |  |  |
| Managing Partner item | Inside dark sidebar |  |  |
| Settings item | Inside dark sidebar |  |  |
| Sidebar scroll | Works if content exceeds height |  |  |
| Main content | Does not overlap sidebar |  |  |

## Deadline QA

| Check | Expected | Pass/Fail | Notes |
|---|---|---|---|
| Page loads | No blank screen |  |  |
| Empty state | Professional message |  |  |
| Add Deadline | Opens form |  |  |
| Cancel | Closes form |  |  |
| Required title | Validated |  |  |
| Required due date | Validated |  |  |
| Reminder days | Must be 0 or more |  |  |
| Deadline list | New item appears |  |  |
| Overdue status | Urgent warning |  |  |
| Due today status | Urgent warning |  |  |
| Due soon status | Reminder active |  |  |
| Upcoming status | Normal upcoming |  |  |
| Completed status | Clearly completed |  |  |
| Filter | Works |  |  |
| Sort | Nearest/urgent first |  |  |
| Console | No errors |  |  |
'@

$testCases = @'
# Deadline Test Cases

## Test Case 1 - Zero Deadlines

Expected:
- summary cards show zero
- empty state appears
- no error

## Test Case 2 - Upcoming Deadline

Input:
- title: File Written Submission
- due date: 30 days from today
- reminder: 7 days

Expected:
- status: Upcoming
- reminder trigger date shown
- no urgent warning

## Test Case 3 - Due Soon

Input:
- title: Prepare Bundle
- due date: 5 days from today
- reminder: 7 days

Expected:
- status: Due Soon
- message: Reminder window active

## Test Case 4 - Due Today

Input:
- title: Attend Hearing
- due date: today
- reminder: 7 days

Expected:
- status: Due Today
- message: Due today. Please review now.

## Test Case 5 - Overdue

Input:
- title: File Affidavit
- due date: yesterday
- reminder: 7 days

Expected:
- status: Overdue
- message: Immediate action required.

## Test Case 6 - No Case Linked

Input:
- title: Internal Review
- due date: next week
- associated case: blank

Expected:
- allowed to save if current system allows
- warning: No case linked. Please attach this deadline to a case.

## Test Case 7 - No Notes

Input:
- notes: blank

Expected:
- optional warning: Consider adding notes or filing instructions.
'@

$liveMonitorDoc = @'
# Live Progress Monitor

## Purpose

This phase uses a simple file-based monitoring method.

Main log file:

08_LOGS/LIVE-PROGRESS-LOG.csv

Current progress file:

05_MONITORING/phase-progress-current.json

## How To Watch Progress Live

Run:

powershell -NoProfile -ExecutionPolicy Bypass -File ".\_L360_CONTROL\PHASE-12-1A-UI-DEADLINE-STANDARDIZATION\TOOLS\Start-L360-Live-Monitor.ps1"

## How To Add A Progress Entry

Run:

powershell -NoProfile -ExecutionPolicy Bypass -File ".\_L360_CONTROL\PHASE-12-1A-UI-DEADLINE-STANDARDIZATION\TOOLS\Update-L360-Progress.ps1" -Stage "Sidebar Fix" -Status "IN_PROGRESS" -Notes "Cursor is locating sidebar files."

## Status Values

Use only:

- NOT_STARTED
- IN_PROGRESS
- BLOCKED
- TESTING
- PASSED
- FAILED
- COMPLETED
- ROLLED_BACK

## Progress Rules

1. Log before starting.
2. Log after every file edit.
3. Log after every test.
4. Log all blockers.
5. Log rollback actions.
'@

$performanceBaseline = @'
# Performance Baseline

## Purpose

Track whether UI changes make the app slower or unstable.

## Manual Baseline Fields

Record before and after UI changes:

| Area | Before | After | Notes |
|---|---:|---:|---|
| App startup time |  |  |  |
| Deadline page load time |  |  |  |
| Sidebar render issue | Yes |  |  |
| Console errors |  |  |  |
| Terminal errors |  |  |  |
| Browser freeze |  |  |  |
| Blank screen occurrence |  |  |  |

## Conservative Acceptance Rule

A visual improvement fails if it causes:

- slower startup
- blank screen
- console errors
- broken navigation
- broken deadline creation
- broken filters
- backend errors
'@

$rollback = @'
# Rollback Protocol

## Primary Rule

Do not panic-edit.

If a change breaks the app:

1. Stop.
2. Take screenshot.
3. Copy terminal error.
4. Copy browser console error.
5. Identify last changed file.
6. Revert only the last changed file.
7. Retest.

## Git Rollback If Git Is Available

Check status:

git status --short

See changed files:

git diff --name-only

Review exact changes:

git diff

Rollback one file only:

git checkout -- "path\to\file"

Do not run broad destructive rollback unless approved.

## If No Git

Use backups created by editor or restore from copied previous version.

## What Not To Do

- Do not randomly edit backend.
- Do not delete node_modules.
- Do not reinstall dependencies unless dependency issue is proven.
- Do not change database schema.
- Do not wipe the project.
'@

$handover = @'
# Single Source Of Truth Handover - Phase 12.1A

## Project Root

C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software

## Phase Name

Phase 12.1A - UI Standardization + Deadline Control Centre

## Mission

Fix the sidebar visual containment issue and upgrade the Deadline page into a legal-grade Deadline Control Centre.

## Current Evidence

Screenshots show:

1. Sidebar lower items appear outside the continuous dark background.
2. Deadline page is basic and not yet a full alert/reminder/control module.

## Safe Scope

Allowed:

- Sidebar layout
- Sidebar styling
- Sidebar nav item standardization
- Deadline page UI
- Deadline frontend status calculation
- Deadline summary cards
- Deadline empty state
- Deadline prompts
- Notification placeholder
- Testing documentation

Not allowed without approval:

- backend edits
- API route edits
- auth/RBAC edits
- database schema edits
- production deployment edits

## Recommended Execution Order

1. Run preflight checks.
2. Locate Sidebar files.
3. Fix sidebar containment only.
4. Test sidebar.
5. Standardize sidebar items.
6. Test sidebar again.
7. Locate Deadline page files.
8. Add Deadline summary cards and empty state.
9. Add status calculation and badges.
10. Add warning prompts.
11. Add filter/sort improvements.
12. Add notification placeholder.
13. Run full QA.
14. Produce completion report.

## Required Completion Report

Completion report must include:

- files changed
- files inspected
- test results
- screenshots before/after
- remaining limitations
- whether notifications are real or placeholder only
- confirmation protected files were not modified
'@

$startupReport = @"
# Phase 12.1A Startup Report

Generated: $(Get-Date -Format "yyyy-MM-dd HH:mm:ss")

## Project Root

$ProjectRoot

## Control Root

$PhaseRoot

## Status

Control pack created.

## Next Step

1. Run preflight:
   powershell -NoProfile -ExecutionPolicy Bypass -File "$ToolsRoot\Run-L360-Preflight-Checks.ps1"

2. Locate UI files:
   powershell -NoProfile -ExecutionPolicy Bypass -File "$ToolsRoot\Find-L360-Ui-Files.ps1"

3. Give Cursor:
   03_CURSOR_PROMPTS\01-CURSOR-SIDEBAR-FIX-PROMPT.md

4. Test.

5. Then give Cursor:
   03_CURSOR_PROMPTS\02-CURSOR-DEADLINE-UPGRADE-PROMPT.md
"@

Write-Doc -Path (Join-Path $PhaseRoot "00_READ_FIRST\README-FIRST.md") -Content $readme
Write-Doc -Path (Join-Path $PhaseRoot "00_READ_FIRST\NO-DIRECT-BACKEND-EDIT-RULES.md") -Content $noBackend
Write-Doc -Path (Join-Path $PhaseRoot "01_BLUEPRINTS\SIDEBAR-STANDARDIZATION-BLUEPRINT.md") -Content $sidebarBlueprint
Write-Doc -Path (Join-Path $PhaseRoot "01_BLUEPRINTS\DEADLINE-CONTROL-CENTRE-BLUEPRINT.md") -Content $deadlineBlueprint
Write-Doc -Path (Join-Path $PhaseRoot "02_PROTOCOLS\SAFE-EDIT-PROTOCOL.md") -Content $safeEditProtocol
Write-Doc -Path (Join-Path $PhaseRoot "02_PROTOCOLS\POWERSHELL-NO-CONTINUATION-PROMPT-PROTOCOL.md") -Content $noContinuation
Write-Doc -Path (Join-Path $PhaseRoot "03_CURSOR_PROMPTS\01-CURSOR-SIDEBAR-FIX-PROMPT.md") -Content $cursorSidebar
Write-Doc -Path (Join-Path $PhaseRoot "03_CURSOR_PROMPTS\02-CURSOR-DEADLINE-UPGRADE-PROMPT.md") -Content $cursorDeadline
Write-Doc -Path (Join-Path $PhaseRoot "03_CURSOR_PROMPTS\03-CURSOR-TESTING-ONLY-PROMPT.md") -Content $cursorTesting
Write-Doc -Path (Join-Path $PhaseRoot "04_TESTING\MANUAL-QA-CHECKLIST.md") -Content $manualQa
Write-Doc -Path (Join-Path $PhaseRoot "04_TESTING\TEST-CASES-DEADLINES.md") -Content $testCases
Write-Doc -Path (Join-Path $PhaseRoot "05_MONITORING\LIVE-PROGRESS-MONITOR.md") -Content $liveMonitorDoc
Write-Doc -Path (Join-Path $PhaseRoot "05_MONITORING\PERFORMANCE-BASELINE.md") -Content $performanceBaseline
Write-Doc -Path (Join-Path $PhaseRoot "07_ROLLBACK\ROLLBACK-PROTOCOL.md") -Content $rollback
Write-Doc -Path (Join-Path $PhaseRoot "10_HANDOVER\SSOT-HANDOVER-CURSOR.md") -Content $handover
Write-Doc -Path (Join-Path $PhaseRoot ("06_REPORTS\PHASE-12-1A-STARTUP-REPORT-{0}.md" -f $timestamp)) -Content $startupReport

$progressObject = [ordered]@{
    phase = "PHASE-12.1A-UI-DEADLINE-STANDARDIZATION"
    projectRoot = $ProjectRoot
    phaseRoot = $PhaseRoot
    status = "CONTROL_PACK_CREATED"
    generatedAt = (Get-Date).ToString("s")
    protectedAreas = @("backend", "database", "auth", "RBAC", "API routes", ".env", "production deployment")
    nextCommands = @(
        "powershell -NoProfile -ExecutionPolicy Bypass -File `"$ToolsRoot\Run-L360-Preflight-Checks.ps1`"",
        "powershell -NoProfile -ExecutionPolicy Bypass -File `"$ToolsRoot\Find-L360-Ui-Files.ps1`"",
        "powershell -NoProfile -ExecutionPolicy Bypass -File `"$ToolsRoot\Start-L360-Live-Monitor.ps1`""
    )
}

$progressObject | ConvertTo-Json -Depth 6 | Set-Content -LiteralPath $ProgressJson -Encoding UTF8
Append-Progress -Stage "Pack Creation" -Status "COMPLETED" -Notes "Control pack files created successfully."

$preflightScript = @'
[CmdletBinding()]
param(
    [string]$ProjectRoot = "C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software"
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

Write-Host ""
Write-Host "L360 PREFLIGHT CHECKS" -ForegroundColor Cyan
Write-Host ""

if (-not (Test-Path -LiteralPath $ProjectRoot)) {
    throw "Project root not found: $ProjectRoot"
}

Write-Host "Project root exists: $ProjectRoot" -ForegroundColor Green

$checks = @(
    @{ Name = "package.json"; Path = (Join-Path $ProjectRoot "package.json") },
    @{ Name = "src folder"; Path = (Join-Path $ProjectRoot "src") },
    @{ Name = "app folder"; Path = (Join-Path $ProjectRoot "app") },
    @{ Name = "pages folder"; Path = (Join-Path $ProjectRoot "pages") },
    @{ Name = "components folder"; Path = (Join-Path $ProjectRoot "components") },
    @{ Name = "client folder"; Path = (Join-Path $ProjectRoot "client") },
    @{ Name = "frontend folder"; Path = (Join-Path $ProjectRoot "frontend") }
)

foreach ($check in $checks) {
    if (Test-Path -LiteralPath $check.Path) {
        Write-Host ("FOUND: {0} => {1}" -f $check.Name, $check.Path) -ForegroundColor Green
    }
    else {
        Write-Host ("NOT FOUND: {0} => {1}" -f $check.Name, $check.Path) -ForegroundColor DarkGray
    }
}

Write-Host ""
Write-Host "Git status:" -ForegroundColor Cyan
try {
    Push-Location $ProjectRoot
    git status --short
}
catch {
    Write-Host "Git not available or not a git repo. Continue carefully." -ForegroundColor Yellow
}
finally {
    Pop-Location
}

Write-Host ""
Write-Host "Port check for common dev ports:" -ForegroundColor Cyan
try {
    Get-NetTCPConnection -State Listen -ErrorAction SilentlyContinue |
        Where-Object { $_.LocalPort -in @(3000, 5000, 5060, 5061, 5100, 5173, 8080) } |
        Select-Object LocalAddress, LocalPort, State, OwningProcess |
        Format-Table -AutoSize
}
catch {
    Write-Host "Port check unavailable on this PowerShell environment." -ForegroundColor Yellow
}

Write-Host ""
Write-Host "Preflight completed. No project source files were modified." -ForegroundColor Green
'@

$findFilesScript = @'
[CmdletBinding()]
param(
    [string]$ProjectRoot = "C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software"
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

Write-Host ""
Write-Host "L360 UI FILE LOCATOR" -ForegroundColor Cyan
Write-Host ""

if (-not (Test-Path -LiteralPath $ProjectRoot)) {
    throw "Project root not found: $ProjectRoot"
}

$excludeDirs = @("node_modules", ".git", "dist", "build", ".next", "coverage", "_L360_CONTROL")

$files = Get-ChildItem -LiteralPath $ProjectRoot -Recurse -File -ErrorAction SilentlyContinue |
    Where-Object {
        $full = $_.FullName
        foreach ($dir in $excludeDirs) {
            if ($full -like "*\$dir\*") { return $false }
        }
        return $true
    }

Write-Host "Potential sidebar/navigation files:" -ForegroundColor Yellow
$files |
    Where-Object { $_.Name -match "sidebar|navigation|nav|layout|menu" } |
    Select-Object FullName |
    Format-Table -AutoSize

Write-Host ""
Write-Host "Potential deadline files:" -ForegroundColor Yellow
$files |
    Where-Object { $_.Name -match "deadline|deadlines" -or (Select-String -LiteralPath $_.FullName -Pattern "Deadline|Deadlines" -SimpleMatch -Quiet -ErrorAction SilentlyContinue) } |
    Select-Object FullName |
    Format-Table -AutoSize

Write-Host ""
Write-Host "Locator completed. No files were modified." -ForegroundColor Green
'@

$updateProgressScript = @'
[CmdletBinding()]
param(
    [Parameter(Mandatory=$true)][string]$Stage,
    [Parameter(Mandatory=$true)][ValidateSet("NOT_STARTED","IN_PROGRESS","BLOCKED","TESTING","PASSED","FAILED","COMPLETED","ROLLED_BACK")][string]$Status,
    [Parameter(Mandatory=$true)][string]$Notes,
    [string]$ProjectRoot = "C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software"
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$PhaseRoot = Join-Path $ProjectRoot "_L360_CONTROL\PHASE-12-1A-UI-DEADLINE-STANDARDIZATION"
$ProgressCsv = Join-Path $PhaseRoot "08_LOGS\LIVE-PROGRESS-LOG.csv"
$ProgressJson = Join-Path $PhaseRoot "05_MONITORING\phase-progress-current.json"

if (-not (Test-Path -LiteralPath $ProgressCsv)) {
    New-Item -ItemType Directory -Path (Split-Path -Parent $ProgressCsv) -Force | Out-Null
    Set-Content -LiteralPath $ProgressCsv -Value '"Timestamp","Stage","Status","Notes"' -Encoding UTF8
}

$line = '"{0}","{1}","{2}","{3}"' -f (Get-Date -Format "yyyy-MM-dd HH:mm:ss"), $Stage.Replace('"','""'), $Status.Replace('"','""'), $Notes.Replace('"','""')
Add-Content -LiteralPath $ProgressCsv -Value $line -Encoding UTF8

$current = [ordered]@{
    phase = "PHASE-12.1A-UI-DEADLINE-STANDARDIZATION"
    updatedAt = (Get-Date).ToString("s")
    stage = $Stage
    status = $Status
    notes = $Notes
}

$current | ConvertTo-Json -Depth 6 | Set-Content -LiteralPath $ProgressJson -Encoding UTF8

Write-Host "Progress updated." -ForegroundColor Green
Write-Host ("Stage : {0}" -f $Stage)
Write-Host ("Status: {0}" -f $Status)
Write-Host ("Notes : {0}" -f $Notes)
'@

$liveMonitorScript = @'
[CmdletBinding()]
param(
    [string]$ProjectRoot = "C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software"
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$PhaseRoot = Join-Path $ProjectRoot "_L360_CONTROL\PHASE-12-1A-UI-DEADLINE-STANDARDIZATION"
$ProgressCsv = Join-Path $PhaseRoot "08_LOGS\LIVE-PROGRESS-LOG.csv"
$ProgressJson = Join-Path $PhaseRoot "05_MONITORING\phase-progress-current.json"

Write-Host ""
Write-Host "L360 LIVE MONITOR" -ForegroundColor Cyan
Write-Host "Progress CSV : $ProgressCsv"
Write-Host "Progress JSON: $ProgressJson"
Write-Host ""
Write-Host "Press Ctrl+C to stop monitoring." -ForegroundColor Yellow
Write-Host ""

while ($true) {
    Clear-Host
    Write-Host "L360 LIVE MONITOR - $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')" -ForegroundColor Cyan
    Write-Host ""

    if (Test-Path -LiteralPath $ProgressJson) {
        Write-Host "Current Progress:" -ForegroundColor Yellow
        Get-Content -LiteralPath $ProgressJson -Raw
    }
    else {
        Write-Host "No current progress JSON found." -ForegroundColor Yellow
    }

    Write-Host ""
    Write-Host "Last 10 Log Entries:" -ForegroundColor Yellow
    if (Test-Path -LiteralPath $ProgressCsv) {
        Get-Content -LiteralPath $ProgressCsv | Select-Object -Last 10
    }
    else {
        Write-Host "No progress CSV found."
    }

    Write-Host ""
    Write-Host "Listening Dev Ports:" -ForegroundColor Yellow
    try {
        Get-NetTCPConnection -State Listen -ErrorAction SilentlyContinue |
            Where-Object { $_.LocalPort -in @(3000, 5000, 5060, 5061, 5100, 5173, 8080) } |
            Select-Object LocalAddress, LocalPort, State, OwningProcess |
            Format-Table -AutoSize
    }
    catch {
        Write-Host "Port check unavailable."
    }

    Start-Sleep -Seconds 5
}
'@

Write-Doc -Path (Join-Path $ToolsRoot "Run-L360-Preflight-Checks.ps1") -Content $preflightScript
Write-Doc -Path (Join-Path $ToolsRoot "Find-L360-Ui-Files.ps1") -Content $findFilesScript
Write-Doc -Path (Join-Path $ToolsRoot "Update-L360-Progress.ps1") -Content $updateProgressScript
Write-Doc -Path (Join-Path $ToolsRoot "Start-L360-Live-Monitor.ps1") -Content $liveMonitorScript

Append-Progress -Stage "Tools Creation" -Status "COMPLETED" -Notes "Preflight, file locator, progress updater, and live monitor scripts created."

Write-Host ""
Write-Host "============================================================" -ForegroundColor Green
Write-Host " CONTROL PACK CREATED SUCCESSFULLY" -ForegroundColor Green
Write-Host "============================================================" -ForegroundColor Green
Write-Host ""
Write-Host ("Project Root : {0}" -f $ProjectRoot) -ForegroundColor White
Write-Host ("Phase Root   : {0}" -f $PhaseRoot) -ForegroundColor White
Write-Host ""
Write-Host "NEXT COMMAND 1 - PREFLIGHT:" -ForegroundColor Cyan
Write-Host ("powershell -NoProfile -ExecutionPolicy Bypass -File `"{0}`"" -f (Join-Path $ToolsRoot "Run-L360-Preflight-Checks.ps1")) -ForegroundColor White
Write-Host ""
Write-Host "NEXT COMMAND 2 - LOCATE UI FILES:" -ForegroundColor Cyan
Write-Host ("powershell -NoProfile -ExecutionPolicy Bypass -File `"{0}`"" -f (Join-Path $ToolsRoot "Find-L360-Ui-Files.ps1")) -ForegroundColor White
Write-Host ""
Write-Host "NEXT COMMAND 3 - LIVE MONITOR:" -ForegroundColor Cyan
Write-Host ("powershell -NoProfile -ExecutionPolicy Bypass -File `"{0}`"" -f (Join-Path $ToolsRoot "Start-L360-Live-Monitor.ps1")) -ForegroundColor White
Write-Host ""
Write-Host "Read first:" -ForegroundColor Cyan
Write-Host (Join-Path $PhaseRoot "00_READ_FIRST\README-FIRST.md")
Write-Host ""
