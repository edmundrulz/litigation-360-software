# ============================================================
# LITIGATION 360 LEOS
# PHASE 12.0G GET-ONLY LAB SMOKE TESTS
#
# PURPOSE:
#   Safely test whether candidate frontend pages and backend APIs respond.
#
# SAFE MODE:
#   - GET requests only
#   - DOES NOT POST / PUT / PATCH / DELETE
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
    Write-Host "[PHASE 12.0G] $Message" -ForegroundColor Cyan
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

function Test-Url-Get {
    param(
        [string]$Url,
        [string]$Feature,
        [string]$Type
    )

    try {
        $Response = Invoke-WebRequest -Uri $Url -Method GET -UseBasicParsing -TimeoutSec 5
        return [PSCustomObject]@{
            Feature = $Feature
            Type = $Type
            Url = $Url
            Result = "RESPONDED"
            StatusCode = [int]$Response.StatusCode
            Meaning = "GET returned HTTP $($Response.StatusCode)"
        }
    }
    catch {
        $Status = ""
        $Meaning = $_.Exception.Message

        try {
            if ($_.Exception.Response -ne $null) {
                $Status = [int]$_.Exception.Response.StatusCode
                if ($Status -eq 401 -or $Status -eq 403) {
                    return [PSCustomObject]@{
                        Feature = $Feature
                        Type = $Type
                        Url = $Url
                        Result = "PROTECTED / EXISTS"
                        StatusCode = $Status
                        Meaning = "Endpoint responded with auth/RBAC protection. This can still mean route exists."
                    }
                }
                else {
                    $Meaning = "HTTP error $Status"
                }
            }
        }
        catch {}

        return [PSCustomObject]@{
            Feature = $Feature
            Type = $Type
            Url = $Url
            Result = "NO CONFIRMED RESPONSE"
            StatusCode = $Status
            Meaning = $Meaning
        }
    }
}

function Test-Port-Listening {
    param([int]$Port)

    try {
        $Output = netstat -ano | Select-String ":$Port "
        if ($Output) { return $true }
        return $false
    }
    catch {
        return $false
    }
}

# ------------------------------------------------------------
# 1. RESOLVE ROOT
# ------------------------------------------------------------
Write-Step "Resolving project root..."

if (!(Test-Path -LiteralPath $ProjectRoot -PathType Container)) {
    $ProjectRoot = (Get-Location).Path
}

Set-Location -LiteralPath $ProjectRoot

$ControlRoot = Join-Path $ProjectRoot "_LEOS_CONTROL"
$SmokeRoot = Join-Path $ControlRoot "feature-exploration\smoke-tests"
$ReportRoot = Join-Path $ControlRoot "reports"

New-Item -ItemType Directory -Path $SmokeRoot -Force | Out-Null
New-Item -ItemType Directory -Path $ReportRoot -Force | Out-Null

Write-Pass "Project root:"
Write-Host $ProjectRoot -ForegroundColor Green

# ------------------------------------------------------------
# 2. PORT CHECK
# ------------------------------------------------------------
Write-Step "Checking common frontend/backend ports..."

$PortRows = foreach ($Port in @(3000, 5000, 5060, 5061, 5100, 5173, 8080)) {
    [PSCustomObject]@{
        Port = $Port
        Listening = Test-Port-Listening -Port $Port
    }
}

$PortRows | Export-Csv -Path (Join-Path $SmokeRoot "PHASE-12.0G-PORT-CHECK.csv") -NoTypeInformation -Encoding UTF8

# Prefer known frontend and backend ports
$FrontendBaseUrls = @()
if (($PortRows | Where-Object { $_.Port -eq 5173 -and $_.Listening -eq $true })) { $FrontendBaseUrls += "http://localhost:5173" }
if (($PortRows | Where-Object { $_.Port -eq 3000 -and $_.Listening -eq $true })) { $FrontendBaseUrls += "http://localhost:3000" }

$BackendBaseUrls = @()
if (($PortRows | Where-Object { $_.Port -eq 5100 -and $_.Listening -eq $true })) { $BackendBaseUrls += "http://localhost:5100" }
if (($PortRows | Where-Object { $_.Port -eq 5000 -and $_.Listening -eq $true })) { $BackendBaseUrls += "http://localhost:5000" }
if (($PortRows | Where-Object { $_.Port -eq 5060 -and $_.Listening -eq $true })) { $BackendBaseUrls += "http://localhost:5060" }
if (($PortRows | Where-Object { $_.Port -eq 8080 -and $_.Listening -eq $true })) { $BackendBaseUrls += "http://localhost:8080" }

# If nothing is listening, still produce manual command guide.
if ($FrontendBaseUrls.Count -eq 0) {
    $FrontendBaseUrls += "http://localhost:5173"
}

if ($BackendBaseUrls.Count -eq 0) {
    $BackendBaseUrls += "http://localhost:5100"
    $BackendBaseUrls += "http://localhost:5000"
}

# ------------------------------------------------------------
# 3. FRONTEND PAGE GET CHECKS
# ------------------------------------------------------------
Write-Step "Running GET-only frontend page checks..."

$FrontendPaths = @(
    [PSCustomObject]@{ Feature="Workspace"; Path="/" },
    [PSCustomObject]@{ Feature="Workspace"; Path="/dashboard" },
    [PSCustomObject]@{ Feature="Clients"; Path="/clients" },
    [PSCustomObject]@{ Feature="Matters"; Path="/cases" },
    [PSCustomObject]@{ Feature="Matters"; Path="/matters" },
    [PSCustomObject]@{ Feature="Matters"; Path="/matter-intake" },
    [PSCustomObject]@{ Feature="Deadlines"; Path="/deadlines" },
    [PSCustomObject]@{ Feature="Documents"; Path="/documents" },
    [PSCustomObject]@{ Feature="Court Dates"; Path="/court-dates" }
)

$FrontendResults = @()

foreach ($Base in $FrontendBaseUrls) {
    foreach ($Item in $FrontendPaths) {
        $FrontendResults += (Test-Url-Get -Url ($Base + $Item.Path) -Feature $Item.Feature -Type "FRONTEND_PAGE_GET")
    }
}

$FrontendResults | Export-Csv -Path (Join-Path $SmokeRoot "PHASE-12.0G-FRONTEND-PAGE-GET-RESULTS.csv") -NoTypeInformation -Encoding UTF8

# ------------------------------------------------------------
# 4. BACKEND API GET CHECKS
# ------------------------------------------------------------
Write-Step "Running GET-only backend API checks..."

$BackendPaths = @(
    [PSCustomObject]@{ Feature="Workspace"; Path="/health" },
    [PSCustomObject]@{ Feature="Workspace"; Path="/api/health" },
    [PSCustomObject]@{ Feature="Workspace"; Path="/api/status" },
    [PSCustomObject]@{ Feature="Workspace"; Path="/api/dashboard" },

    [PSCustomObject]@{ Feature="Authentication"; Path="/api/auth/me" },
    [PSCustomObject]@{ Feature="Authentication"; Path="/api/auth/status" },
    [PSCustomObject]@{ Feature="Authentication"; Path="/auth/me" },

    [PSCustomObject]@{ Feature="RBAC"; Path="/api/roles" },
    [PSCustomObject]@{ Feature="RBAC"; Path="/api/permissions" },
    [PSCustomObject]@{ Feature="RBAC"; Path="/api/admin/roles" },

    [PSCustomObject]@{ Feature="Audit Logging"; Path="/api/audit-logs" },
    [PSCustomObject]@{ Feature="Audit Logging"; Path="/api/auditLogs" },
    [PSCustomObject]@{ Feature="Audit Logging"; Path="/api/audit" },

    [PSCustomObject]@{ Feature="Clients"; Path="/api/clients" },
    [PSCustomObject]@{ Feature="Clients"; Path="/clients" },

    [PSCustomObject]@{ Feature="Matters"; Path="/api/matters" },
    [PSCustomObject]@{ Feature="Matters"; Path="/api/cases" },
    [PSCustomObject]@{ Feature="Matters"; Path="/matters" },

    [PSCustomObject]@{ Feature="Deadlines"; Path="/api/deadlines" },
    [PSCustomObject]@{ Feature="Deadlines"; Path="/api/court-deadline" },
    [PSCustomObject]@{ Feature="Deadlines"; Path="/api/courtDeadline" },

    [PSCustomObject]@{ Feature="Documents"; Path="/api/documents" },
    [PSCustomObject]@{ Feature="Documents"; Path="/api/document-lifecycle" },
    [PSCustomObject]@{ Feature="Documents"; Path="/api/documentLifecycle" },

    [PSCustomObject]@{ Feature="Court Dates"; Path="/api/court" },
    [PSCustomObject]@{ Feature="Court Dates"; Path="/api/court-navigation" },
    [PSCustomObject]@{ Feature="Court Dates"; Path="/api/courtNavigation" }
)

$BackendResults = @()

foreach ($Base in $BackendBaseUrls) {
    foreach ($Item in $BackendPaths) {
        $BackendResults += (Test-Url-Get -Url ($Base + $Item.Path) -Feature $Item.Feature -Type "BACKEND_API_GET")
    }
}

$BackendResults | Export-Csv -Path (Join-Path $SmokeRoot "PHASE-12.0G-BACKEND-API-GET-RESULTS.csv") -NoTypeInformation -Encoding UTF8

# ------------------------------------------------------------
# 5. FEATURE SUMMARY
# ------------------------------------------------------------
Write-Step "Creating lab smoke test summary..."

$Features = @(
    "Workspace",
    "Authentication",
    "RBAC",
    "Audit Logging",
    "Clients",
    "Matters",
    "Deadlines",
    "Documents",
    "Court Dates"
)

$SummaryRows = foreach ($Feature in $Features) {
    $Front = @($FrontendResults | Where-Object { $_.Feature -eq $Feature -and ($_.Result -eq "RESPONDED" -or $_.Result -eq "PROTECTED / EXISTS") })
    $Back = @($BackendResults | Where-Object { $_.Feature -eq $Feature -and ($_.Result -eq "RESPONDED" -or $_.Result -eq "PROTECTED / EXISTS") })

    $Recommendation = "REVIEW ONLY"

    if ($Feature -eq "Court Dates") {
        $Recommendation = "DO NOT CONNECT YET - FRONTEND ROUTE MISSING FROM 12.0F"
    }
    elseif ($Front.Count -gt 0 -and $Back.Count -gt 0) {
        $Recommendation = "LAB SMOKE PASS CANDIDATE - MANUAL BROWSER VERIFY NEXT"
    }
    elseif ($Front.Count -gt 0 -and $Back.Count -eq 0) {
        $Recommendation = "FRONTEND RESPONDS - BACKEND API NOT CONFIRMED"
    }
    elseif ($Front.Count -eq 0 -and $Back.Count -gt 0) {
        $Recommendation = "BACKEND RESPONDS - FRONTEND PAGE NOT CONFIRMED"
    }
    else {
        $Recommendation = "NO CONFIRMED RESPONSE - SERVER MAY BE OFF OR ROUTE UNKNOWN"
    }

    [PSCustomObject]@{
        Feature = $Feature
        FrontendConfirmedResponses = $Front.Count
        BackendConfirmedResponses = $Back.Count
        Recommendation = $Recommendation
        ProductionUnlockAllowed = "NO"
    }
}

$SummaryRows | Export-Csv -Path (Join-Path $SmokeRoot "PHASE-12.0G-FEATURE-SMOKE-SUMMARY.csv") -NoTypeInformation -Encoding UTF8

# ------------------------------------------------------------
# 6. MANUAL CHECKLIST
# ------------------------------------------------------------
$ManualChecklist = @"
# PHASE 12.0G MANUAL BROWSER / API SMOKE TEST CHECKLIST

Generated: $(Get-Date -Format "yyyy-MM-dd HH:mm:ss")

Project Root:
$ProjectRoot

## Safety

This phase uses GET-only checks.

No create, edit, delete, migration, source change, database write, production unlock, or Phase 11 work is allowed.

## Start Servers Manually If Needed

Backend examples:

cd "$ProjectRoot\backend"
node server.js

or from project root:

cd "$ProjectRoot"
node server.js

Frontend example:

cd "$ProjectRoot\frontend"
npm run dev

## Browser Pages To Check

Open these manually if frontend is running:

- http://localhost:5173/
- http://localhost:5173/dashboard
- http://localhost:5173/clients
- http://localhost:5173/cases
- http://localhost:5173/matters
- http://localhost:5173/matter-intake
- http://localhost:5173/deadlines
- http://localhost:5173/documents

Do not treat Court Dates as connectable yet unless a frontend route/page exists.

## Backend GET Checks

The script tested common GET endpoints on detected backend ports.

HTTP 200 means route responded.
HTTP 401 / 403 means route likely exists but is protected.
Connection failure means server may be off or route/port is different.
404 means route path not confirmed.

## Manual PASS Criteria

A feature can be considered LAB-SMOKE-PASS only if:

1. Frontend page opens without white screen.
2. Backend GET endpoint responds with 200, 401, or 403.
3. Browser console has no fatal error.
4. Backend terminal has no crash.
5. No database write was attempted.
6. No production unlock was performed.

## Current Court Dates Rule

Court Dates remains blocked for connection because Phase 12.0F found backend evidence but no frontend file evidence.

## Next Step After This

Paste the Phase 12.0G report into ChatGPT.

Then proceed to Phase 12.0H:
- classify which modules are lab-smoke-pass
- identify missing frontend API calls for Deadlines/Documents
- decide the first safe manual connection repair, if needed
"@

$ChecklistPath = Join-Path $SmokeRoot "PHASE-12.0G-MANUAL-SMOKE-TEST-CHECKLIST.md"
Save-Text -Path $ChecklistPath -Content $ManualChecklist

# ------------------------------------------------------------
# 7. REPORT
# ------------------------------------------------------------
$ReportLines = New-Object System.Collections.Generic.List[string]

$ReportLines.Add("# PHASE 12.0G GET-ONLY LAB SMOKE TEST REPORT") | Out-Null
$ReportLines.Add("") | Out-Null
$ReportLines.Add("Generated: $(Get-Date -Format "yyyy-MM-dd HH:mm:ss")") | Out-Null
$ReportLines.Add("") | Out-Null
$ReportLines.Add("Project Root:") | Out-Null
$ReportLines.Add($ProjectRoot) | Out-Null
$ReportLines.Add("") | Out-Null
$ReportLines.Add("## Safety Confirmation") | Out-Null
$ReportLines.Add("") | Out-Null
$ReportLines.Add("GET requests only.") | Out-Null
$ReportLines.Add("No files were deleted.") | Out-Null
$ReportLines.Add("No files were renamed.") | Out-Null
$ReportLines.Add("No files were moved.") | Out-Null
$ReportLines.Add("No source code was modified.") | Out-Null
$ReportLines.Add("No database was modified.") | Out-Null
$ReportLines.Add("No production features were unlocked.") | Out-Null
$ReportLines.Add("No Phase 11 work was started.") | Out-Null
$ReportLines.Add("") | Out-Null
$ReportLines.Add("## Detected Ports") | Out-Null
$ReportLines.Add("") | Out-Null

foreach ($Row in $PortRows) {
    $ReportLines.Add("Port $($Row.Port): Listening = $($Row.Listening)") | Out-Null
}

$ReportLines.Add("") | Out-Null
$ReportLines.Add("## Base URLs Tested") | Out-Null
$ReportLines.Add("") | Out-Null
$ReportLines.Add("Frontend base URLs: $($FrontendBaseUrls -join ', ')") | Out-Null
$ReportLines.Add("Backend base URLs: $($BackendBaseUrls -join ', ')") | Out-Null
$ReportLines.Add("") | Out-Null
$ReportLines.Add("## Feature Smoke Summary") | Out-Null
$ReportLines.Add("") | Out-Null

foreach ($Row in $SummaryRows) {
    $ReportLines.Add("### $($Row.Feature)") | Out-Null
    $ReportLines.Add("Frontend confirmed responses: $($Row.FrontendConfirmedResponses)") | Out-Null
    $ReportLines.Add("Backend confirmed responses: $($Row.BackendConfirmedResponses)") | Out-Null
    $ReportLines.Add("Recommendation: $($Row.Recommendation)") | Out-Null
    $ReportLines.Add("Production unlock allowed: $($Row.ProductionUnlockAllowed)") | Out-Null
    $ReportLines.Add("") | Out-Null
}

$ReportLines.Add("## Files Created") | Out-Null
$ReportLines.Add("") | Out-Null
$ReportLines.Add("- _LEOS_CONTROL\feature-exploration\smoke-tests\PHASE-12.0G-PORT-CHECK.csv") | Out-Null
$ReportLines.Add("- _LEOS_CONTROL\feature-exploration\smoke-tests\PHASE-12.0G-FRONTEND-PAGE-GET-RESULTS.csv") | Out-Null
$ReportLines.Add("- _LEOS_CONTROL\feature-exploration\smoke-tests\PHASE-12.0G-BACKEND-API-GET-RESULTS.csv") | Out-Null
$ReportLines.Add("- _LEOS_CONTROL\feature-exploration\smoke-tests\PHASE-12.0G-FEATURE-SMOKE-SUMMARY.csv") | Out-Null
$ReportLines.Add("- _LEOS_CONTROL\feature-exploration\smoke-tests\PHASE-12.0G-MANUAL-SMOKE-TEST-CHECKLIST.md") | Out-Null
$ReportLines.Add("") | Out-Null
$ReportLines.Add("## Next Safe Step") | Out-Null
$ReportLines.Add("") | Out-Null
$ReportLines.Add("Paste this report into ChatGPT.") | Out-Null
$ReportLines.Add("Do not unlock production.") | Out-Null
$ReportLines.Add("Do not connect Court Dates yet.") | Out-Null

$ReportPath = Join-Path $ReportRoot "PHASE-12.0G-GET-ONLY-LAB-SMOKE-TEST-REPORT.md"
Save-Text -Path $ReportPath -Content ($ReportLines -join "`r`n")

Write-Host ""
Write-Pass "PHASE 12.0G GET-ONLY LAB SMOKE TESTS COMPLETE"
Write-Host ""
Write-Host "Open report:" -ForegroundColor Cyan
Write-Host "notepad `"_LEOS_CONTROL\reports\PHASE-12.0G-GET-ONLY-LAB-SMOKE-TEST-REPORT.md`""
Write-Host ""
Write-Host "Open summary CSV:" -ForegroundColor Cyan
Write-Host "notepad `"_LEOS_CONTROL\feature-exploration\smoke-tests\PHASE-12.0G-FEATURE-SMOKE-SUMMARY.csv`""
Write-Host ""
Write-Host "Open manual checklist:" -ForegroundColor Cyan
Write-Host "notepad `"_LEOS_CONTROL\feature-exploration\smoke-tests\PHASE-12.0G-MANUAL-SMOKE-TEST-CHECKLIST.md`""
Write-Host ""
Write-Pass "Paste the Phase 12.0G report back into ChatGPT."
