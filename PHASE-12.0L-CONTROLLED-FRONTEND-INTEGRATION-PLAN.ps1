# ============================================================
# LITIGATION 360 LEOS
# PHASE 12.0L CONTROLLED FRONTEND INTEGRATION PLAN
#
# PURPOSE:
#   Prepare the safe integration plan for the Legal Management UI shell.
#
# WHAT THIS DOES:
#   - Checks whether the Phase 12.0K prototype files exist
#   - Checks the active frontend structure
#   - Detects App.jsx / App.tsx / routes / pages / components
#   - Creates an integration plan
#   - Creates candidate copy structure under _LEOS_CONTROL only
#   - Creates a manual integration checklist
#
# SAFE MODE:
#   - DOES NOT overwrite frontend/src
#   - DOES NOT modify App.jsx
#   - DOES NOT modify routes
#   - DOES NOT modify database
#   - DOES NOT unlock production
#   - DOES NOT start Phase 11
# ============================================================

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$ProjectRoot = "C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software"

function Write-Step {
    param([string]$Message)
    Write-Host "[PHASE 12.0L] $Message" -ForegroundColor Cyan
}

function Write-Pass {
    param([string]$Message)
    Write-Host "[PASS] $Message" -ForegroundColor Green
}

function Write-Warn {
    param([string]$Message)
    Write-Host "[WARN] $Message" -ForegroundColor Yellow
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

function Read-File-Safe {
    param([string]$Path)

    if (Test-Path -LiteralPath $Path -PathType Leaf) {
        try {
            return [System.IO.File]::ReadAllText($Path)
        }
        catch {
            return ""
        }
    }

    return ""
}

function Extract-Lines {
    param(
        [string]$FilePath,
        [string[]]$Patterns
    )

    $Rows = @()

    if (!(Test-Path -LiteralPath $FilePath -PathType Leaf)) {
        return $Rows
    }

    $Lines = Get-Content -LiteralPath $FilePath -ErrorAction SilentlyContinue
    $LineNo = 0

    foreach ($Line in $Lines) {
        $LineNo++

        foreach ($Pattern in $Patterns) {
            if ($Line -match $Pattern) {
                $Rows += [PSCustomObject]@{
                    File = $FilePath
                    Line = $LineNo
                    Pattern = $Pattern
                    Text = $Line.Trim()
                }
            }
        }
    }

    return $Rows
}

# ------------------------------------------------------------
# 1. Resolve project
# ------------------------------------------------------------
Write-Step "Resolving project root..."

if (!(Test-Path -LiteralPath $ProjectRoot -PathType Container)) {
    $ProjectRoot = (Get-Location).Path
}

Set-Location -LiteralPath $ProjectRoot

$ControlRoot = Join-Path $ProjectRoot "_LEOS_CONTROL"
$ReportRoot = Join-Path $ControlRoot "reports"
$PrototypeRoot = Join-Path $ControlRoot "feature-exploration\ui-prototypes\legal-management-interface"
$IntegrationRoot = Join-Path $ControlRoot "feature-exploration\ui-integration-plan"
$CandidateRoot = Join-Path $IntegrationRoot "candidate-frontend-files"

New-Item -ItemType Directory -Path $ReportRoot -Force | Out-Null
New-Item -ItemType Directory -Path $IntegrationRoot -Force | Out-Null
New-Item -ItemType Directory -Path $CandidateRoot -Force | Out-Null

Write-Pass "Project root:"
Write-Host $ProjectRoot -ForegroundColor Green

# ------------------------------------------------------------
# 2. Check Phase 12.0K prototype files
# ------------------------------------------------------------
Write-Step "Checking Phase 12.0K UI prototype files..."

$PrototypeFiles = @(
    "LegalManagementShell.jsx",
    "LegalManagementShell.css",
    "firmProfile.config.json",
    "legalNewsLinks.config.json",
    "IMPLEMENTATION-GUIDE.md"
)

$PrototypeRows = foreach ($File in $PrototypeFiles) {
    $FullPath = Join-Path $PrototypeRoot $File
    [PSCustomObject]@{
        File = $File
        FullPath = $FullPath
        Exists = Test-Path -LiteralPath $FullPath -PathType Leaf
    }
}

$PrototypeRows | Export-Csv -Path (Join-Path $IntegrationRoot "PHASE-12.0L-PROTOTYPE-FILE-CHECK.csv") -NoTypeInformation -Encoding UTF8

$PrototypeReady = (($PrototypeRows | Where-Object { $_.Exists -eq $false }) | Measure-Object).Count -eq 0

if ($PrototypeReady) {
    Write-Pass "Phase 12.0K prototype files found."
}
else {
    Write-Warn "Some Phase 12.0K prototype files are missing. Re-run Phase 12.0K first if needed."
}

# ------------------------------------------------------------
# 3. Check active frontend structure
# ------------------------------------------------------------
Write-Step "Inspecting active frontend structure..."

$FrontendRoot = Join-Path $ProjectRoot "frontend"
$FrontendSrc = Join-Path $FrontendRoot "src"

$FrontendCheck = @(
    [PSCustomObject]@{ Item="frontend folder"; Path=$FrontendRoot; Exists=(Test-Path -LiteralPath $FrontendRoot -PathType Container) },
    [PSCustomObject]@{ Item="frontend/src folder"; Path=$FrontendSrc; Exists=(Test-Path -LiteralPath $FrontendSrc -PathType Container) },
    [PSCustomObject]@{ Item="frontend/package.json"; Path=(Join-Path $FrontendRoot "package.json"); Exists=(Test-Path -LiteralPath (Join-Path $FrontendRoot "package.json") -PathType Leaf) },
    [PSCustomObject]@{ Item="frontend/src/App.jsx"; Path=(Join-Path $FrontendSrc "App.jsx"); Exists=(Test-Path -LiteralPath (Join-Path $FrontendSrc "App.jsx") -PathType Leaf) },
    [PSCustomObject]@{ Item="frontend/src/App.tsx"; Path=(Join-Path $FrontendSrc "App.tsx"); Exists=(Test-Path -LiteralPath (Join-Path $FrontendSrc "App.tsx") -PathType Leaf) },
    [PSCustomObject]@{ Item="frontend/src/main.jsx"; Path=(Join-Path $FrontendSrc "main.jsx"); Exists=(Test-Path -LiteralPath (Join-Path $FrontendSrc "main.jsx") -PathType Leaf) },
    [PSCustomObject]@{ Item="frontend/src/main.tsx"; Path=(Join-Path $FrontendSrc "main.tsx"); Exists=(Test-Path -LiteralPath (Join-Path $FrontendSrc "main.tsx") -PathType Leaf) },
    [PSCustomObject]@{ Item="frontend/src/pages folder"; Path=(Join-Path $FrontendSrc "pages"); Exists=(Test-Path -LiteralPath (Join-Path $FrontendSrc "pages") -PathType Container) },
    [PSCustomObject]@{ Item="frontend/src/components folder"; Path=(Join-Path $FrontendSrc "components"); Exists=(Test-Path -LiteralPath (Join-Path $FrontendSrc "components") -PathType Container) }
)

$FrontendCheck | Export-Csv -Path (Join-Path $IntegrationRoot "PHASE-12.0L-FRONTEND-STRUCTURE-CHECK.csv") -NoTypeInformation -Encoding UTF8

# ------------------------------------------------------------
# 4. Locate App file and route patterns
# ------------------------------------------------------------
Write-Step "Detecting App file, route imports and routing patterns..."

$AppCandidates = @(
    Join-Path $FrontendSrc "App.jsx",
    Join-Path $FrontendSrc "App.tsx"
)

$AppFile = ""
foreach ($Candidate in $AppCandidates) {
    if (Test-Path -LiteralPath $Candidate -PathType Leaf) {
        $AppFile = $Candidate
        break
    }
}

$RouteRows = @()

if ($AppFile -ne "") {
    $RouteRows += Extract-Lines -FilePath $AppFile -Patterns @(
        "import\s+",
        "<Route",
        "Routes",
        "BrowserRouter",
        "HashRouter",
        "path\s*=",
        "Navigate",
        "Dashboard",
        "Clients",
        "Cases",
        "Matters",
        "Deadlines",
        "Documents"
    )
}

$RouteRows | Export-Csv -Path (Join-Path $IntegrationRoot "PHASE-12.0L-APP-ROUTE-PATTERN-SCAN.csv") -NoTypeInformation -Encoding UTF8

# ------------------------------------------------------------
# 5. Create candidate frontend file plan under _LEOS_CONTROL only
# ------------------------------------------------------------
Write-Step "Creating candidate frontend file package under _LEOS_CONTROL only..."

$CandidateComponentRoot = Join-Path $CandidateRoot "frontend\src\components\legal-management-shell"
New-Item -ItemType Directory -Path $CandidateComponentRoot -Force | Out-Null

if ($PrototypeReady) {
    foreach ($File in @("LegalManagementShell.jsx","LegalManagementShell.css","firmProfile.config.json","legalNewsLinks.config.json")) {
        Copy-Item -LiteralPath (Join-Path $PrototypeRoot $File) -Destination (Join-Path $CandidateComponentRoot $File) -Force
    }
}

$LegalHomePage = @'
import React from "react";
import LegalManagementShell from "../components/legal-management-shell/LegalManagementShell";

export default function LegalHomePage() {
  return <LegalManagementShell />;
}
'@

Save-Text -Path (Join-Path $CandidateRoot "frontend\src\pages\LegalHomePage.jsx") -Content $LegalHomePage

$CandidateReadme = @"
# Candidate Frontend Files

These files are staged under _LEOS_CONTROL only.

They are NOT active frontend source files yet.

Candidate destination later:

frontend\src\components\legal-management-shell\LegalManagementShell.jsx
frontend\src\components\legal-management-shell\LegalManagementShell.css
frontend\src\components\legal-management-shell\firmProfile.config.json
frontend\src\components\legal-management-shell\legalNewsLinks.config.json
frontend\src\pages\LegalHomePage.jsx

Do not copy these into frontend\src until Phase 12.0M active integration is approved.
"@

Save-Text -Path (Join-Path $CandidateRoot "README-CANDIDATE-FRONTEND-FILES.md") -Content $CandidateReadme

# ------------------------------------------------------------
# 6. Generate App.jsx integration guidance
# ------------------------------------------------------------
Write-Step "Generating App route integration guidance..."

$AppFileRelative = "NOT FOUND"
if ($AppFile -ne "") {
    $AppFileRelative = $AppFile.Substring($ProjectRoot.Length).TrimStart("\")
}

$RecommendedMount = @"
# PHASE 12.0L CONTROLLED FRONTEND INTEGRATION PLAN

Generated: $(Get-Date -Format "yyyy-MM-dd HH:mm:ss")

Project Root:
$ProjectRoot

## Current Finding

Active App file detected:
$AppFileRelative

Phase 12.0K prototype ready:
$PrototypeReady

## Recommended Integration Strategy

Use a new isolated route first:

/legal-home

Do not replace the current dashboard.
Do not replace existing Clients, Matters, Deadlines or Documents pages.
Do not touch Court Dates.
Do not modify Authentication or RBAC yet.

## Candidate File Destination

Later, only after Phase 12.0M approval, copy the staged candidate files into:

frontend\src\components\legal-management-shell\
frontend\src\pages\LegalHomePage.jsx

## Suggested React Import

Add this to App.jsx only after approval:

import LegalHomePage from "./pages/LegalHomePage";

## Suggested Route

Inside the existing <Routes> block, add only one new route:

<Route path="/legal-home" element={<LegalHomePage />} />

## Why /legal-home First?

Because it is isolated.
It does not disturb your working modules:

- Workspace
- Clients
- Matters
- Deadlines
- Documents

It lets you open and test the new interface here:

http://localhost:5173/legal-home

## Safety Rule

Phase 12.0L is plan-only.

No active source files were changed.

## Production Rule

Production unlock remains NO.

Phase 11 remains locked.

Court Dates remains blocked.
"@

$PlanPath = Join-Path $IntegrationRoot "PHASE-12.0L-CONTROLLED-FRONTEND-INTEGRATION-PLAN.md"
Save-Text -Path $PlanPath -Content $RecommendedMount

# ------------------------------------------------------------
# 7. Create Phase 12.0M draft commands but locked
# ------------------------------------------------------------
$LockedNextScript = @'
# PHASE 12.0M ACTIVE FRONTEND INTEGRATION - LOCKED DRAFT ONLY
#
# DO NOT RUN THIS FILE YET.
#
# This is a draft of the next step after the Phase 12.0L plan is reviewed.
# Phase 12.0M would:
# 1. Backup App.jsx
# 2. Copy LegalManagementShell files into frontend/src/components/legal-management-shell
# 3. Copy LegalHomePage.jsx into frontend/src/pages
# 4. Add import and route to App.jsx
# 5. Run npm build or smoke test
#
# This draft is intentionally saved as .txt so it is not accidentally executed.
#
# WAIT FOR APPROVAL BEFORE ACTIVE INTEGRATION.
'@

Save-Text -Path (Join-Path $IntegrationRoot "PHASE-12.0M-ACTIVE-INTEGRATION-LOCKED-DRAFT-DO-NOT-RUN.txt") -Content $LockedNextScript

# ------------------------------------------------------------
# 8. Report
# ------------------------------------------------------------
$Report = @"
# PHASE 12.0L CONTROLLED FRONTEND INTEGRATION PLAN REPORT

Generated: $(Get-Date -Format "yyyy-MM-dd HH:mm:ss")

Project Root:
$ProjectRoot

## Safety Confirmation

No active frontend source files were overwritten.
No App.jsx route was modified.
No database was modified.
No production feature was unlocked.
No Phase 11 work was started.

## Prototype Status

Phase 12.0K prototype ready:
$PrototypeReady

Prototype source:
$PrototypeRoot

## Active Frontend Detection

Active App file:
$AppFileRelative

Frontend route/import scan rows:
$(@($RouteRows).Count)

## Candidate Package Created

Candidate files were staged under:

_LEOS_CONTROL\feature-exploration\ui-integration-plan\candidate-frontend-files

These are not active frontend files.

## Recommended Route

/ legal-home

Actual route string:

/legal-home

Target test URL after future approved integration:

http://localhost:5173/legal-home

## Current Recommendation

Proceed to manual review of:

notepad "_LEOS_CONTROL\feature-exploration\ui-integration-plan\PHASE-12.0L-CONTROLLED-FRONTEND-INTEGRATION-PLAN.md"

Do not run active integration yet.

## Files Created

- _LEOS_CONTROL\feature-exploration\ui-integration-plan\PHASE-12.0L-PROTOTYPE-FILE-CHECK.csv
- _LEOS_CONTROL\feature-exploration\ui-integration-plan\PHASE-12.0L-FRONTEND-STRUCTURE-CHECK.csv
- _LEOS_CONTROL\feature-exploration\ui-integration-plan\PHASE-12.0L-APP-ROUTE-PATTERN-SCAN.csv
- _LEOS_CONTROL\feature-exploration\ui-integration-plan\PHASE-12.0L-CONTROLLED-FRONTEND-INTEGRATION-PLAN.md
- _LEOS_CONTROL\feature-exploration\ui-integration-plan\candidate-frontend-files
- _LEOS_CONTROL\feature-exploration\ui-integration-plan\PHASE-12.0M-ACTIVE-INTEGRATION-LOCKED-DRAFT-DO-NOT-RUN.txt

## Final Ruling

Phase 12.0L:
COMPLETE AS PLAN-ONLY

Active integration:
NOT YET APPROVED

Production unlock:
NO

Phase 11:
LOCKED
"@

$ReportPath = Join-Path $ReportRoot "PHASE-12.0L-CONTROLLED-FRONTEND-INTEGRATION-PLAN-REPORT.md"
Save-Text -Path $ReportPath -Content $Report

Write-Host ""
Write-Pass "PHASE 12.0L CONTROLLED FRONTEND INTEGRATION PLAN COMPLETE"
Write-Host ""
Write-Host "Open report:" -ForegroundColor Cyan
Write-Host "notepad `"_LEOS_CONTROL\reports\PHASE-12.0L-CONTROLLED-FRONTEND-INTEGRATION-PLAN-REPORT.md`""
Write-Host ""
Write-Host "Open integration plan:" -ForegroundColor Cyan
Write-Host "notepad `"_LEOS_CONTROL\feature-exploration\ui-integration-plan\PHASE-12.0L-CONTROLLED-FRONTEND-INTEGRATION-PLAN.md`""
Write-Host ""
Write-Host "Open candidate README:" -ForegroundColor Cyan
Write-Host "notepad `"_LEOS_CONTROL\feature-exploration\ui-integration-plan\candidate-frontend-files\README-CANDIDATE-FRONTEND-FILES.md`""
Write-Host ""
Write-Pass "Paste the Phase 12.0L report back into ChatGPT."
