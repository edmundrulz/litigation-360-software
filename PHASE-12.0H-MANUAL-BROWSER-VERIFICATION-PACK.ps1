# ============================================================
# LITIGATION 360 LEOS
# PHASE 12.0H MANUAL BROWSER VERIFICATION PACK
#
# PURPOSE:
#   Create the manual verification checklist and result template
#   for the modules that Phase 12.0G marked as lab smoke pass candidates.
#
# SAFE MODE:
#   - DOES NOT delete
#   - DOES NOT rename
#   - DOES NOT move files
#   - DOES NOT modify source code
#   - DOES NOT modify database
#   - DOES NOT unlock production
#   - DOES NOT start Phase 11
# ============================================================

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$ProjectRoot = "C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software"

function Write-Step {
    param([string]$Message)
    Write-Host "[PHASE 12.0H] $Message" -ForegroundColor Cyan
}

function Write-Pass {
    param([string]$Message)
    Write-Host "[PASS] $Message" -ForegroundColor Green
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

if (!(Test-Path -LiteralPath $ProjectRoot -PathType Container)) {
    $ProjectRoot = (Get-Location).Path
}

Set-Location -LiteralPath $ProjectRoot

$ControlRoot = Join-Path $ProjectRoot "_LEOS_CONTROL"
$ManualRoot = Join-Path $ControlRoot "feature-exploration\manual-verification"
$ReportRoot = Join-Path $ControlRoot "reports"

New-Item -ItemType Directory -Path $ManualRoot -Force | Out-Null
New-Item -ItemType Directory -Path $ReportRoot -Force | Out-Null

Write-Step "Creating Phase 12.0H manual browser verification pack..."

$Checklist = @"
# PHASE 12.0H MANUAL BROWSER VERIFICATION CHECKLIST

Generated: $(Get-Date -Format "yyyy-MM-dd HH:mm:ss")

Project Root:
$ProjectRoot

## Current Starting Position

Phase 12.0G confirmed GET-only lab smoke pass candidates:

- Workspace
- Clients
- Matters
- Deadlines
- Documents

Phase 12.0G did NOT approve production unlock.

Court Dates remains blocked.

Authentication and RBAC require separate security-route verification because common guessed GET endpoints did not respond.

---

# 1. Safety Rule

This phase is manual visual/browser verification only.

Allowed:

- Open pages
- Observe whether page loads
- Observe browser console
- Observe backend terminal
- Click navigation links
- Use existing test/dev data if already visible

Not allowed:

- Create new client
- Create new matter
- Create new deadline
- Upload document
- Edit records
- Delete records
- Run migrations
- Modify source code
- Modify database
- Unlock production
- Start Phase 11

---

# 2. Start Servers

Open PowerShell Window 1:

cd "$ProjectRoot\backend"
node server.js

Open PowerShell Window 2:

cd "$ProjectRoot\frontend"
npm run dev

Expected active ports from Phase 12.0G:

Frontend:
http://localhost:5173

Backend:
http://localhost:5000

---

# 3. Manual Browser Pages To Open

Open these one by one in Chrome:

## Workspace

http://localhost:5173/
http://localhost:5173/dashboard

PASS if:
- Page opens
- No white screen
- Navigation/sidebar/header appears
- No fatal browser console error
- Backend terminal does not crash

FAIL if:
- White screen
- Infinite loading
- Fatal React error
- Backend crash
- Broken navigation

## Clients

http://localhost:5173/clients

PASS if:
- Clients page opens
- Existing client list/table/card area appears OR empty-state appears properly
- No fatal console error
- No backend crash

Do NOT create, edit, or delete a client yet.

## Matters

http://localhost:5173/cases
http://localhost:5173/matters
http://localhost:5173/matter-intake

PASS if:
- At least one matters/cases/intake page opens
- No fatal console error
- No backend crash
- Intake page does not need final submit testing yet

Do NOT submit a new matter yet.

## Deadlines

http://localhost:5173/deadlines

PASS if:
- Deadlines page opens
- Existing list/table/empty-state appears properly
- No fatal console error
- No backend crash

Do NOT create or edit a deadline yet.

## Documents

http://localhost:5173/documents

PASS if:
- Documents page opens
- Existing list/table/empty-state appears properly
- No fatal console error
- No backend crash

Do NOT upload a document yet.

---

# 4. Court Dates Rule

Do not connect Court Dates yet.

Reason:
Phase 12.0F found backend evidence but no frontend file evidence.

The Phase 12.0G frontend response for Court Dates may be only the React/Vite fallback page, not a real implemented Court Dates module.

Current Court Dates status:
BLOCKED / BACKEND ONLY / FRONTEND REQUIRED

---

# 5. Authentication / RBAC Rule

Do not change Authentication or RBAC yet.

Phase 12.0G common GET route guesses did not confirm Authentication/RBAC endpoints.

This is not automatically a failure.

It means the routes may be:

- POST-only
- mounted under a different path
- protected
- session/token based
- not exposed as GET endpoints

Next verification must inspect exact route definitions before testing Auth/RBAC.

---

# 6. Result Format To Paste Back

Paste results in this format:

Workspace:
PASS / FAIL / PARTIAL
Notes:

Clients:
PASS / FAIL / PARTIAL
Notes:

Matters:
PASS / FAIL / PARTIAL
Notes:

Deadlines:
PASS / FAIL / PARTIAL
Notes:

Documents:
PASS / FAIL / PARTIAL
Notes:

Browser console errors:
YES / NO
Details:

Backend terminal errors:
YES / NO
Details:

Did you create/edit/delete/upload anything?
NO

Court Dates touched?
NO

Production unlocked?
NO
"@

$ChecklistPath = Join-Path $ManualRoot "PHASE-12.0H-MANUAL-BROWSER-VERIFICATION-CHECKLIST.md"
Save-Text -Path $ChecklistPath -Content $Checklist

$Csv = @'
Feature,FrontendURL,ManualResult,PageLoaded,WhiteScreen,ConsoleError,BackendCrash,Notes,ProductionUnlockAllowed
Workspace,http://localhost:5173/,PENDING,,,,,,NO
Workspace,http://localhost:5173/dashboard,PENDING,,,,,,NO
Clients,http://localhost:5173/clients,PENDING,,,,,,NO
Matters,http://localhost:5173/cases,PENDING,,,,,,NO
Matters,http://localhost:5173/matters,PENDING,,,,,,NO
Matters,http://localhost:5173/matter-intake,PENDING,,,,,,NO
Deadlines,http://localhost:5173/deadlines,PENDING,,,,,,NO
Documents,http://localhost:5173/documents,PENDING,,,,,,NO
Court Dates,http://localhost:5173/court-dates,BLOCKED,,,,,Do not connect yet,NO
Authentication,N/A,SECURITY VERIFY LATER,,,,,Common GET paths not confirmed,NO
RBAC,N/A,SECURITY VERIFY LATER,,,,,Common GET paths not confirmed,NO
Audit Logging,N/A,BACKEND FOUNDATION VERIFY LATER,,,,,Backend responded but no frontend page required yet,NO
'@

$CsvPath = Join-Path $ManualRoot "PHASE-12.0H-MANUAL-BROWSER-VERIFICATION-RESULTS-TEMPLATE.csv"
Save-Text -Path $CsvPath -Content $Csv

$Report = @"
# PHASE 12.0H MANUAL BROWSER VERIFICATION PACK REPORT

Generated: $(Get-Date -Format "yyyy-MM-dd HH:mm:ss")

Project Root:
$ProjectRoot

## Files Created

- _LEOS_CONTROL\feature-exploration\manual-verification\PHASE-12.0H-MANUAL-BROWSER-VERIFICATION-CHECKLIST.md
- _LEOS_CONTROL\feature-exploration\manual-verification\PHASE-12.0H-MANUAL-BROWSER-VERIFICATION-RESULTS-TEMPLATE.csv

## Current Safe Ruling

Proceed with manual browser verification only for:

- Workspace
- Clients
- Matters
- Deadlines
- Documents

Do not connect Court Dates.

Do not production unlock.

Do not create/edit/delete/upload records yet.

## Next Action

Open:

notepad "_LEOS_CONTROL\feature-exploration\manual-verification\PHASE-12.0H-MANUAL-BROWSER-VERIFICATION-CHECKLIST.md"

Then manually test the listed browser pages and paste the result back into ChatGPT.
"@

$ReportPath = Join-Path $ReportRoot "PHASE-12.0H-MANUAL-BROWSER-VERIFICATION-PACK-REPORT.md"
Save-Text -Path $ReportPath -Content $Report

Write-Host ""
Write-Pass "PHASE 12.0H MANUAL BROWSER VERIFICATION PACK CREATED"
Write-Host ""
Write-Host "Open checklist:" -ForegroundColor Cyan
Write-Host "notepad `"_LEOS_CONTROL\feature-exploration\manual-verification\PHASE-12.0H-MANUAL-BROWSER-VERIFICATION-CHECKLIST.md`""
Write-Host ""
Write-Host "Open results template:" -ForegroundColor Cyan
Write-Host "notepad `"_LEOS_CONTROL\feature-exploration\manual-verification\PHASE-12.0H-MANUAL-BROWSER-VERIFICATION-RESULTS-TEMPLATE.csv`""
Write-Host ""
Write-Pass "Manual browser verification is the next step."
