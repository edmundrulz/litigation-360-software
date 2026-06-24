# ============================================================
# LITIGATION 360 LEOS
# PHASE 12.0M CONTROLLED ACTIVE FRONTEND INTEGRATION
#
# PURPOSE:
#   Safely integrate the Legal Management UI shell into the active
#   React frontend as an isolated route:
#
#   /legal-home
#
# WHAT THIS DOES:
#   - Backs up frontend\src\App.jsx
#   - Copies LegalManagementShell prototype files into frontend\src
#   - Creates/updates frontend\src\pages\LegalHomePage.jsx
#   - Adds one import to App.jsx
#   - Adds one isolated route to App.jsx
#   - Creates rollback instructions
#   - Creates a verification report
#
# WHAT THIS DOES NOT DO:
#   - Does NOT modify database
#   - Does NOT modify backend
#   - Does NOT touch Clients/Matters/Deadlines/Documents routes
#   - Does NOT touch Court Dates
#   - Does NOT modify Authentication/RBAC
#   - Does NOT unlock production
#   - Does NOT start Phase 11
# ============================================================

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$ProjectRoot = "C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software"

function Write-Step {
    param([string]$Message)
    Write-Host "[PHASE 12.0M] $Message" -ForegroundColor Cyan
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

function Backup-File-If-Exists {
    param(
        [string]$SourcePath,
        [string]$BackupFolder,
        [string]$Label
    )

    if (Test-Path -LiteralPath $SourcePath -PathType Leaf) {
        $SafeName = ($Label + "__" + ((Split-Path -Path $SourcePath -Leaf) -replace '[^\w\.\-]', '_'))
        $BackupPath = Join-Path $BackupFolder $SafeName
        Copy-Item -LiteralPath $SourcePath -Destination $BackupPath -Force
        return $BackupPath
    }

    return ""
}

function Insert-Import-And-Route {
    param(
        [string]$AppPath,
        [string]$ImportLine,
        [string]$RouteLine
    )

    $Result = [PSCustomObject]@{
        Modified = $false
        ImportStatus = "NOT ATTEMPTED"
        RouteStatus = "NOT ATTEMPTED"
        Reason = ""
    }

    if (!(Test-Path -LiteralPath $AppPath -PathType Leaf)) {
        $Result.Reason = "App file not found."
        return $Result
    }

    $Original = [System.IO.File]::ReadAllText($AppPath)
    $New = $Original

    $HasImport = $Original.Contains($ImportLine)
    $HasRoute = $Original.Contains('path="/legal-home"') -or $Original.Contains("path='/legal-home'")

    if ($HasImport) {
        $Result.ImportStatus = "ALREADY EXISTS"
    }

    if ($HasRoute) {
        $Result.RouteStatus = "ALREADY EXISTS"
    }

    if ($HasImport -and $HasRoute) {
        $Result.Modified = $false
        $Result.Reason = "Import and route already exist."
        return $Result
    }

    # Require a Routes closing tag for safe auto-integration.
    if (-not ($Original -match "</Routes>")) {
        $Result.Reason = "Could not find </Routes>. Manual integration required."
        $Result.RouteStatus = "FAILED - NO ROUTES CLOSING TAG"
        if (-not $HasImport) {
            $Result.ImportStatus = "SKIPPED"
        }
        return $Result
    }

    # Add import only if missing.
    if (-not $HasImport) {
        $Lines = $New -split "`r?`n"
        $LastImportIndex = -1

        for ($i = 0; $i -lt $Lines.Count; $i++) {
            if ($Lines[$i] -match "^\s*import\s+") {
                $LastImportIndex = $i
            }
        }

        if ($LastImportIndex -ge 0) {
            $Before = @()
            $After = @()

            if ($LastImportIndex -ge 0) {
                $Before = $Lines[0..$LastImportIndex]
            }

            if ($LastImportIndex + 1 -le $Lines.Count - 1) {
                $After = $Lines[($LastImportIndex + 1)..($Lines.Count - 1)]
            }

            $Lines = @($Before + $ImportLine + $After)
            $New = $Lines -join "`r`n"
            $Result.ImportStatus = "ADDED"
        }
        else {
            $Result.ImportStatus = "FAILED - NO IMPORT BLOCK"
            $Result.Reason = "Could not find import block."
            return $Result
        }
    }

    # Add route only if missing.
    if (-not $HasRoute) {
        $RouteToInsert = "          " + $RouteLine

        if ($New -match "\r\n") {
            $New = $New -replace "(\s*)</Routes>", "`r`n$RouteToInsert`$1</Routes>"
        }
        else {
            $New = $New -replace "(\s*)</Routes>", "`n$RouteToInsert`$1</Routes>"
        }

        if ($New.Contains('path="/legal-home"')) {
            $Result.RouteStatus = "ADDED"
        }
        else {
            $Result.RouteStatus = "FAILED - ROUTE INSERT DID NOT CONFIRM"
            $Result.Reason = "Route insertion did not confirm."
            return $Result
        }
    }

    if ($New -ne $Original) {
        $Utf8NoBom = New-Object System.Text.UTF8Encoding($false)
        [System.IO.File]::WriteAllText($AppPath, $New, $Utf8NoBom)
        $Result.Modified = $true
    }

    if ($Result.Reason -eq "") {
        $Result.Reason = "Safe isolated route integration completed."
    }

    return $Result
}

# ------------------------------------------------------------
# 1. Resolve project and paths
# ------------------------------------------------------------
Write-Step "Resolving project root..."

if (!(Test-Path -LiteralPath $ProjectRoot -PathType Container)) {
    $ProjectRoot = (Get-Location).Path
}

Set-Location -LiteralPath $ProjectRoot

$ControlRoot = Join-Path $ProjectRoot "_LEOS_CONTROL"
$ReportRoot = Join-Path $ControlRoot "reports"
$IntegrationRoot = Join-Path $ControlRoot "feature-exploration\ui-integration-plan"
$CandidateRoot = Join-Path $IntegrationRoot "candidate-frontend-files"

$PrototypeComponentRoot = Join-Path $CandidateRoot "frontend\src\components\legal-management-shell"
$PrototypePagePath = Join-Path $CandidateRoot "frontend\src\pages\LegalHomePage.jsx"

$FrontendRoot = Join-Path $ProjectRoot "frontend"
$FrontendSrc = Join-Path $FrontendRoot "src"
$FrontendComponents = Join-Path $FrontendSrc "components"
$FrontendPages = Join-Path $FrontendSrc "pages"

$ActiveComponentRoot = Join-Path $FrontendComponents "legal-management-shell"
$ActiveLegalHomePage = Join-Path $FrontendPages "LegalHomePage.jsx"
$AppPath = Join-Path $FrontendSrc "App.jsx"

$RunStamp = Get-Date -Format "yyyyMMdd-HHmmss"
$RollbackRoot = Join-Path $ControlRoot "rollback\PHASE-12.0M-$RunStamp"

New-Item -ItemType Directory -Path $ReportRoot -Force | Out-Null
New-Item -ItemType Directory -Path $RollbackRoot -Force | Out-Null

Write-Pass "Project root:"
Write-Host $ProjectRoot -ForegroundColor Green

# ------------------------------------------------------------
# 2. Preflight checks
# ------------------------------------------------------------
Write-Step "Running preflight checks..."

$PreflightRows = @()

$RequiredPaths = @()
$RequiredPaths += [PSCustomObject]@{ Name="Frontend src"; Path=$FrontendSrc; Type="Folder" }
$RequiredPaths += [PSCustomObject]@{ Name="Frontend pages"; Path=$FrontendPages; Type="Folder" }
$RequiredPaths += [PSCustomObject]@{ Name="Frontend components"; Path=$FrontendComponents; Type="Folder" }
$RequiredPaths += [PSCustomObject]@{ Name="App.jsx"; Path=$AppPath; Type="File" }
$RequiredPaths += [PSCustomObject]@{ Name="Candidate component root"; Path=$PrototypeComponentRoot; Type="Folder" }
$RequiredPaths += [PSCustomObject]@{ Name="Candidate LegalHomePage"; Path=$PrototypePagePath; Type="File" }

foreach ($Item in $RequiredPaths) {
    $Exists = $false
    if ($Item.Type -eq "Folder") {
        $Exists = Test-Path -LiteralPath $Item.Path -PathType Container
    }
    else {
        $Exists = Test-Path -LiteralPath $Item.Path -PathType Leaf
    }

    $PreflightRows += [PSCustomObject]@{
        Name = $Item.Name
        Type = $Item.Type
        Path = $Item.Path
        Exists = $Exists
    }
}

$PreflightPath = Join-Path $RollbackRoot "PHASE-12.0M-PREFLIGHT-CHECK.csv"
$PreflightRows | Export-Csv -Path $PreflightPath -NoTypeInformation -Encoding UTF8

$MissingRequired = @($PreflightRows | Where-Object { $_.Exists -eq $false })

if ($MissingRequired.Count -gt 0) {
    $MissingText = ($MissingRequired | ForEach-Object { "$($_.Name): $($_.Path)" }) -join "`r`n"
    $FailReport = @"
# PHASE 12.0M CONTROLLED ACTIVE FRONTEND INTEGRATION - FAILED PREFLIGHT

Generated: $(Get-Date -Format "yyyy-MM-dd HH:mm:ss")

Project Root:
$ProjectRoot

## Result

FAILED PREFLIGHT - NO ACTIVE INTEGRATION PERFORMED

## Missing Required Items

$MissingText

## Safety

No active frontend file was modified.
No database was modified.
No production feature was unlocked.
No Phase 11 work was started.

## Next Action

Re-run Phase 12.0K and Phase 12.0L V2 if candidate files are missing.
"@

    $FailReportPath = Join-Path $ReportRoot "PHASE-12.0M-CONTROLLED-ACTIVE-FRONTEND-INTEGRATION-FAILED-PREFLIGHT-REPORT.md"
    Save-Text -Path $FailReportPath -Content $FailReport

    Write-Fail "Preflight failed. No active integration performed."
    Write-Host "Open report:"
    Write-Host "notepad `"_LEOS_CONTROL\reports\PHASE-12.0M-CONTROLLED-ACTIVE-FRONTEND-INTEGRATION-FAILED-PREFLIGHT-REPORT.md`""
    exit 1
}

Write-Pass "Preflight passed."

# ------------------------------------------------------------
# 3. Backup existing active files
# ------------------------------------------------------------
Write-Step "Backing up active frontend files before integration..."

$BackupRows = @()

$AppBackup = Backup-File-If-Exists -SourcePath $AppPath -BackupFolder $RollbackRoot -Label "App.jsx"
$BackupRows += [PSCustomObject]@{ Item="App.jsx"; Original=$AppPath; Backup=$AppBackup }

$LegalHomeBackup = Backup-File-If-Exists -SourcePath $ActiveLegalHomePage -BackupFolder $RollbackRoot -Label "LegalHomePage.jsx"
if ($LegalHomeBackup -ne "") {
    $BackupRows += [PSCustomObject]@{ Item="Existing LegalHomePage.jsx"; Original=$ActiveLegalHomePage; Backup=$LegalHomeBackup }
}

if (Test-Path -LiteralPath $ActiveComponentRoot -PathType Container) {
    $ExistingComponentFiles = Get-ChildItem -LiteralPath $ActiveComponentRoot -File -Force -ErrorAction SilentlyContinue
    foreach ($File in $ExistingComponentFiles) {
        $B = Backup-File-If-Exists -SourcePath $File.FullName -BackupFolder $RollbackRoot -Label ("existing-component-" + $File.Name)
        $BackupRows += [PSCustomObject]@{ Item=("Existing component " + $File.Name); Original=$File.FullName; Backup=$B }
    }
}

$BackupRows | Export-Csv -Path (Join-Path $RollbackRoot "PHASE-12.0M-BACKUP-MANIFEST.csv") -NoTypeInformation -Encoding UTF8

Write-Pass "Backup completed:"
Write-Host $RollbackRoot -ForegroundColor Green

# ------------------------------------------------------------
# 4. Copy candidate files into active frontend
# ------------------------------------------------------------
Write-Step "Copying Legal Management UI files into active frontend..."

New-Item -ItemType Directory -Path $ActiveComponentRoot -Force | Out-Null
New-Item -ItemType Directory -Path $FrontendPages -Force | Out-Null

$FilesToCopy = @()
$FilesToCopy += "LegalManagementShell.jsx"
$FilesToCopy += "LegalManagementShell.css"
$FilesToCopy += "firmProfile.config.json"
$FilesToCopy += "legalNewsLinks.config.json"

$CopyRows = @()

foreach ($File in $FilesToCopy) {
    $Source = Join-Path $PrototypeComponentRoot $File
    $Destination = Join-Path $ActiveComponentRoot $File
    Copy-Item -LiteralPath $Source -Destination $Destination -Force

    $CopyRows += [PSCustomObject]@{
        File = $File
        Source = $Source
        Destination = $Destination
        Copied = (Test-Path -LiteralPath $Destination -PathType Leaf)
    }
}

Copy-Item -LiteralPath $PrototypePagePath -Destination $ActiveLegalHomePage -Force
$CopyRows += [PSCustomObject]@{
    File = "LegalHomePage.jsx"
    Source = $PrototypePagePath
    Destination = $ActiveLegalHomePage
    Copied = (Test-Path -LiteralPath $ActiveLegalHomePage -PathType Leaf)
}

$CopyRows | Export-Csv -Path (Join-Path $RollbackRoot "PHASE-12.0M-COPY-MANIFEST.csv") -NoTypeInformation -Encoding UTF8

# ------------------------------------------------------------
# 5. Add isolated route to App.jsx
# ------------------------------------------------------------
Write-Step "Adding isolated /legal-home route to App.jsx..."

$ImportLine = 'import LegalHomePage from "./pages/LegalHomePage";'
$RouteLine = '<Route path="/legal-home" element={<LegalHomePage />} />'

$IntegrationResult = Insert-Import-And-Route -AppPath $AppPath -ImportLine $ImportLine -RouteLine $RouteLine

$IntegrationResult | Export-Csv -Path (Join-Path $RollbackRoot "PHASE-12.0M-APP-INTEGRATION-RESULT.csv") -NoTypeInformation -Encoding UTF8

# ------------------------------------------------------------
# 6. Create rollback guide
# ------------------------------------------------------------
Write-Step "Creating rollback guide..."

$RollbackGuide = @"
# PHASE 12.0M ROLLBACK GUIDE

Generated: $(Get-Date -Format "yyyy-MM-dd HH:mm:ss")

Rollback Folder:
$RollbackRoot

## What Was Backed Up

See:
PHASE-12.0M-BACKUP-MANIFEST.csv

## Primary Restore Step

To restore App.jsx manually:

Copy this backup:

$AppBackup

Back to:

$AppPath

PowerShell command:

Copy-Item -LiteralPath "$AppBackup" -Destination "$AppPath" -Force

## New Files Added

The integration may have added or overwritten:

$ActiveComponentRoot
$ActiveLegalHomePage

If rollback is needed, restore backed-up files where available.

If these files were newly created and you want to remove them, do that only after confirming with ChatGPT.

## Safety

Do not delete anything unless you are intentionally rolling back and have confirmed the backup exists.
"@

Save-Text -Path (Join-Path $RollbackRoot "ROLLBACK-GUIDE.md") -Content $RollbackGuide

# ------------------------------------------------------------
# 7. Create post-integration smoke checklist
# ------------------------------------------------------------
$SmokeChecklist = @"
# PHASE 12.0M POST-INTEGRATION SMOKE CHECKLIST

Generated: $(Get-Date -Format "yyyy-MM-dd HH:mm:ss")

## Start / Restart Frontend

In PowerShell:

cd "$ProjectRoot\frontend"
npm run dev

## Open New Isolated Route

http://localhost:5173/legal-home

## Expected Result

The Legal Management UI shell should open with:

- left sidebar
- scales of justice branding
- Search button
- Instructions button
- Glossary button
- MY/SG Legal News button
- Settings button
- firm profile section
- managing partner profile section

## Check Existing Routes Still Work

Open:

http://localhost:5173/
http://localhost:5173/clients
http://localhost:5173/cases
http://localhost:5173/deadlines
http://localhost:5173/documents

## PASS Criteria

- /legal-home opens
- no white screen
- no fatal browser console error
- existing pages still open
- backend terminal does not crash

## FAIL Criteria

- frontend fails to compile
- white screen
- App.jsx route error
- import error
- existing pages stop working

## Important

Production unlock remains NO.
Phase 11 remains locked.
Court Dates remains blocked.
"@

Save-Text -Path (Join-Path $RollbackRoot "POST-INTEGRATION-SMOKE-CHECKLIST.md") -Content $SmokeChecklist

# ------------------------------------------------------------
# 8. Report
# ------------------------------------------------------------
$Report = @"
# PHASE 12.0M CONTROLLED ACTIVE FRONTEND INTEGRATION REPORT

Generated: $(Get-Date -Format "yyyy-MM-dd HH:mm:ss")

Project Root:
$ProjectRoot

## Safety Confirmation

App.jsx was backed up before route integration.
No database was modified.
No backend source was modified.
No Clients/Matters/Deadlines/Documents route was intentionally replaced.
Court Dates was not touched.
Authentication/RBAC was not modified.
Production feature unlock was NOT performed.
Phase 11 was NOT started.

## Active Files Targeted

Component folder:
$ActiveComponentRoot

Page file:
$ActiveLegalHomePage

App file:
$AppPath

## Backup Folder

$RollbackRoot

## Copy Result

Copied LegalManagementShell files:
$(@($CopyRows | Where-Object { $_.Copied -eq $true }).Count) / $(@($CopyRows).Count)

## App.jsx Integration Result

Modified:
$($IntegrationResult.Modified)

Import status:
$($IntegrationResult.ImportStatus)

Route status:
$($IntegrationResult.RouteStatus)

Reason:
$($IntegrationResult.Reason)

## New Route

/legal-home

Test URL:

http://localhost:5173/legal-home

## Files Created

- $RollbackRoot\PHASE-12.0M-PREFLIGHT-CHECK.csv
- $RollbackRoot\PHASE-12.0M-BACKUP-MANIFEST.csv
- $RollbackRoot\PHASE-12.0M-COPY-MANIFEST.csv
- $RollbackRoot\PHASE-12.0M-APP-INTEGRATION-RESULT.csv
- $RollbackRoot\ROLLBACK-GUIDE.md
- $RollbackRoot\POST-INTEGRATION-SMOKE-CHECKLIST.md

## Next Action

Restart or refresh frontend.

Then open:

http://localhost:5173/legal-home

Also confirm existing pages still open:

http://localhost:5173/
http://localhost:5173/clients
http://localhost:5173/cases
http://localhost:5173/deadlines
http://localhost:5173/documents

## Final Ruling

Phase 12.0M:
CONTROLLED ACTIVE FRONTEND INTEGRATION ATTEMPTED

Production unlock:
NO

Phase 11:
LOCKED
"@

$ReportPath = Join-Path $ReportRoot "PHASE-12.0M-CONTROLLED-ACTIVE-FRONTEND-INTEGRATION-REPORT.md"
Save-Text -Path $ReportPath -Content $Report

Write-Host ""
Write-Pass "PHASE 12.0M CONTROLLED ACTIVE FRONTEND INTEGRATION COMPLETE"
Write-Host ""
Write-Host "Open report:" -ForegroundColor Cyan
Write-Host "notepad `"_LEOS_CONTROL\reports\PHASE-12.0M-CONTROLLED-ACTIVE-FRONTEND-INTEGRATION-REPORT.md`""
Write-Host ""
Write-Host "Open smoke checklist:" -ForegroundColor Cyan
Write-Host "notepad `"$($RollbackRoot.Substring($ProjectRoot.Length).TrimStart("\"))\POST-INTEGRATION-SMOKE-CHECKLIST.md`""
Write-Host ""
Write-Host "Test URL:" -ForegroundColor Cyan
Write-Host "http://localhost:5173/legal-home"
Write-Host ""
Write-Pass "Paste the Phase 12.0M report and browser result back into ChatGPT."
