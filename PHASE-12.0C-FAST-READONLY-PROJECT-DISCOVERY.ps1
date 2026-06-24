# ============================================================
# LITIGATION 360 LEOS
# PHASE 12.0C FAST READ-ONLY PROJECT DISCOVERY
# PURPOSE:
#   Replace the slower discovery script that looked like it was blinking/stuck.
#
# SAFE MODE:
#   - DOES NOT delete
#   - DOES NOT rename
#   - DOES NOT move source files
#   - DOES NOT modify databases
#   - DOES NOT modify source code
#   - DOES NOT unlock production
# ============================================================

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$DeclaredProjectRoot = "C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software"

function Write-Step {
    param([string]$Message)
    Write-Host "[PHASE 12.0C FAST] $Message" -ForegroundColor Cyan
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

function Export-ObjectCsv {
    param(
        [Parameter(Mandatory=$true)]$Rows,
        [Parameter(Mandatory=$true)][string]$Path
    )

    $Folder = Split-Path -Path $Path -Parent
    if (!(Test-Path -LiteralPath $Folder)) {
        New-Item -ItemType Directory -Path $Folder -Force | Out-Null
    }

    @($Rows) | Export-Csv -Path $Path -NoTypeInformation -Encoding UTF8
}

# ------------------------------------------------------------
# 1. RESOLVE PROJECT ROOT
# ------------------------------------------------------------
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
        $ProjectRoot = $Current
        Write-Warn "Declared path not found; using current folder because it looks like a project root."
    }
    else {
        throw "Project root not found. Run this from C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software"
    }
}

Set-Location -LiteralPath $ProjectRoot

$ControlRoot = Join-Path $ProjectRoot "_LEOS_CONTROL"
$DiscoveryRoot = Join-Path $ControlRoot "feature-exploration\discovery"
$ReportRoot = Join-Path $ControlRoot "reports"

New-Item -ItemType Directory -Path $DiscoveryRoot -Force | Out-Null
New-Item -ItemType Directory -Path $ReportRoot -Force | Out-Null

Write-Pass "Project root:"
Write-Host $ProjectRoot -ForegroundColor Green

# ------------------------------------------------------------
# 2. FAST SAFE FILE SCAN
#    This excludes heavy folders BEFORE entering them.
# ------------------------------------------------------------
Write-Step "Starting fast read-only file discovery..."

$ExcludedDirectoryNames = @(
    "node_modules",
    ".git",
    "_LEOS_CONTROL",
    "dist",
    "build",
    ".vite",
    ".next",
    ".nuxt",
    ".cache",
    "coverage",
    "tmp",
    "temp",
    "logs",
    ".turbo",
    ".parcel-cache",
    ".angular",
    ".svelte-kit"
)

$MaxFiles = 50000
$ScannedDirectoryCount = 0
$SkippedDirectoryCount = 0
$ErrorList = New-Object System.Collections.Generic.List[object]
$FileList = New-Object System.Collections.Generic.List[object]
$SkippedList = New-Object System.Collections.Generic.List[object]

$Stack = New-Object System.Collections.Stack
$RootItem = Get-Item -LiteralPath $ProjectRoot
$Stack.Push($RootItem)

while ($Stack.Count -gt 0) {
    $CurrentDir = $Stack.Pop()
    $ScannedDirectoryCount++

    if (($ScannedDirectoryCount % 100) -eq 0) {
        Write-Host "[SCAN] Directories scanned: $ScannedDirectoryCount | Files found: $($FileList.Count)" -ForegroundColor DarkCyan
    }

    try {
        $Children = Get-ChildItem -LiteralPath $CurrentDir.FullName -Force -ErrorAction Stop

        foreach ($Child in $Children) {
            if ($Child.PSIsContainer) {
                if ($ExcludedDirectoryNames -contains $Child.Name) {
                    $SkippedDirectoryCount++
                    $SkippedList.Add([PSCustomObject]@{
                        SkippedFolder = $Child.FullName
                        Reason = "Excluded heavy/generated/control folder"
                    }) | Out-Null
                }
                else {
                    $Stack.Push($Child)
                }
            }
            else {
                $FileList.Add([PSCustomObject]@{
                    FullName = $Child.FullName
                    Name = $Child.Name
                    Extension = $Child.Extension
                    Length = $Child.Length
                    LastWriteTime = $Child.LastWriteTime
                }) | Out-Null

                if ($FileList.Count -ge $MaxFiles) {
                    Write-Warn "Reached safety cap of $MaxFiles files. Discovery will stop early to prevent hanging."
                    break
                }
            }
        }

        if ($FileList.Count -ge $MaxFiles) {
            break
        }
    }
    catch {
        $ErrorList.Add([PSCustomObject]@{
            Folder = $CurrentDir.FullName
            Error = $_.Exception.Message
        }) | Out-Null
    }
}

$AllFiles = @($FileList)

Write-Pass "Fast file discovery finished."
Write-Host "Directories scanned: $ScannedDirectoryCount"
Write-Host "Directories skipped: $SkippedDirectoryCount"
Write-Host "Files discovered: $($AllFiles.Count)"

# ------------------------------------------------------------
# 3. EXPORT DISCOVERY OUTPUTS
# ------------------------------------------------------------
Write-Step "Exporting discovery files..."

Get-ChildItem -LiteralPath $ProjectRoot -Force |
    Select-Object FullName, Name, Mode, Length, LastWriteTime |
    Export-Csv -Path (Join-Path $DiscoveryRoot "ROOT-FILES-AND-FOLDERS.csv") -NoTypeInformation -Encoding UTF8

Export-ObjectCsv -Rows $AllFiles -Path (Join-Path $DiscoveryRoot "PROJECT-FILE-INVENTORY-FAST.csv")
Export-ObjectCsv -Rows $SkippedList -Path (Join-Path $DiscoveryRoot "SKIPPED-HEAVY-FOLDERS.csv")
Export-ObjectCsv -Rows $ErrorList -Path (Join-Path $DiscoveryRoot "DISCOVERY-SCAN-ERRORS.csv")

$CodeCandidates = $AllFiles | Where-Object {
    $_.Extension -match "^\.(js|jsx|ts|tsx|css|html|json|mjs|cjs)$"
}
Export-ObjectCsv -Rows $CodeCandidates -Path (Join-Path $DiscoveryRoot "CODE-CANDIDATE-FILES.csv")

$FrontendCandidates = $AllFiles | Where-Object {
    $_.FullName -match "\\src\\" -or
    $_.FullName -match "\\frontend\\" -or
    $_.Name -match "App|main|index|router|route|page|component|view|screen|dashboard|client|matter|deadline|document"
}
Export-ObjectCsv -Rows $FrontendCandidates -Path (Join-Path $DiscoveryRoot "FRONTEND-CANDIDATE-FILES.csv")

$BackendCandidates = $AllFiles | Where-Object {
    $_.FullName -match "\\backend\\" -or
    $_.FullName -match "\\server\\" -or
    $_.FullName -match "\\routes\\" -or
    $_.FullName -match "\\controllers\\" -or
    $_.FullName -match "\\middleware\\" -or
    $_.FullName -match "\\models\\" -or
    $_.Name -match "server|app|route|controller|middleware|auth|rbac|audit"
}
Export-ObjectCsv -Rows $BackendCandidates -Path (Join-Path $DiscoveryRoot "BACKEND-CANDIDATE-FILES.csv")

$DatabaseCandidates = $AllFiles | Where-Object {
    $_.Extension -match "^\.(db|sqlite|sqlite3)$" -or
    $_.Name -match "database|sqlite|prisma|schema|migration|knex"
}
Export-ObjectCsv -Rows $DatabaseCandidates -Path (Join-Path $DiscoveryRoot "DATABASE-CANDIDATE-FILES.csv")

$DocumentationCandidates = $AllFiles | Where-Object {
    $_.Extension -match "^\.(md|txt|pdf|docx)$" -or
    $_.FullName -match "\\docs\\" -or
    $_.FullName -match "\\documentation\\"
}
Export-ObjectCsv -Rows $DocumentationCandidates -Path (Join-Path $DiscoveryRoot "DOCUMENTATION-FILES.csv")

$StartupFiles = @(
    "package.json",
    "package-lock.json",
    "vite.config.js",
    "vite.config.ts",
    "server.js",
    "app.js",
    "backend\server.js",
    "backend\app.js",
    "frontend\package.json",
    "src\App.jsx",
    "src\App.tsx",
    "src\main.jsx",
    "src\main.tsx"
)

$StartupReport = foreach ($RelativePath in $StartupFiles) {
    $FullPath = Join-Path $ProjectRoot $RelativePath
    [PSCustomObject]@{
        RelativePath = $RelativePath
        Exists = Test-Path -LiteralPath $FullPath
        FullPath = $FullPath
    }
}
Export-ObjectCsv -Rows $StartupReport -Path (Join-Path $DiscoveryRoot "PACKAGE-AND-STARTUP-FILE-CHECK.csv")

try {
    git status --short | Out-File -FilePath (Join-Path $DiscoveryRoot "GIT-STATUS.txt") -Encoding UTF8
}
catch {
    "Git status unavailable: $($_.Exception.Message)" | Out-File -FilePath (Join-Path $DiscoveryRoot "GIT-STATUS.txt") -Encoding UTF8
}

try {
    netstat -ano | Select-String ":3000|:5000|:5060|:5061|:5100|:5173|:8080" |
        Out-File -FilePath (Join-Path $DiscoveryRoot "ACTIVE-PORTS.txt") -Encoding UTF8
}
catch {
    "Port check unavailable: $($_.Exception.Message)" |
        Out-File -FilePath (Join-Path $DiscoveryRoot "ACTIVE-PORTS.txt") -Encoding UTF8
}

# ------------------------------------------------------------
# 4. CREATE FEATURE CONNECTION MATRIX STARTER
# ------------------------------------------------------------
Write-Step "Creating feature connection matrix starter..."

$FeatureList = @(
    "Workspace",
    "Clients",
    "Matters",
    "Deadlines",
    "Documents",
    "Court Dates",
    "Staff",
    "Dashboard ECC",
    "Authentication",
    "RBAC",
    "Audit Logging",
    "Notifications",
    "Automation",
    "Reports",
    "Client Portal",
    "Communications Hub",
    "Finance Billing",
    "Knowledge Graph",
    "AI Copilot",
    "Mobile App"
)

$FeatureRows = foreach ($Feature in $FeatureList) {
    $Pattern = ($Feature -replace " ", "|").ToLower()

    $FrontendHits = @($FrontendCandidates | Where-Object { $_.FullName.ToLower() -match $Pattern }).Count
    $BackendHits = @($BackendCandidates | Where-Object { $_.FullName.ToLower() -match $Pattern }).Count
    $DbHits = @($DatabaseCandidates | Where-Object { $_.FullName.ToLower() -match $Pattern }).Count

    $Status = "PENDING REVIEW"
    if ($FrontendHits -gt 0 -and $BackendHits -gt 0) {
        $Status = "POSSIBLY CONNECTABLE - VERIFY"
    }
    elseif ($FrontendHits -gt 0 -and $BackendHits -eq 0) {
        $Status = "FRONTEND ONLY - BACKEND MISSING/PENDING"
    }
    elseif ($FrontendHits -eq 0 -and $BackendHits -gt 0) {
        $Status = "BACKEND ONLY - FRONTEND MISSING/PENDING"
    }

    [PSCustomObject]@{
        Feature = $Feature
        Status = $Status
        FrontendCandidateCount = $FrontendHits
        BackendCandidateCount = $BackendHits
        DatabaseCandidateCount = $DbHits
        ProductionUnlockAllowed = "NO"
        LabExplorationAllowed = "YES"
        NextAction = "Open candidate CSVs and verify exact files/routes."
    }
}

Export-ObjectCsv -Rows $FeatureRows -Path (Join-Path $ControlRoot "feature-exploration\matrix\FEATURE-CONNECTION-MATRIX-FAST.csv")

# ------------------------------------------------------------
# 5. FINAL REPORT
# ------------------------------------------------------------
$FileCount = @($AllFiles).Count
$CodeCount = @($CodeCandidates).Count
$FrontendCount = @($FrontendCandidates).Count
$BackendCount = @($BackendCandidates).Count
$DatabaseCount = @($DatabaseCandidates).Count
$DocumentationCount = @($DocumentationCandidates).Count
$ErrorCount = @($ErrorList).Count

$ReportPath = Join-Path $ReportRoot "PHASE-12.0C-FAST-READONLY-PROJECT-DISCOVERY-REPORT.md"

$Report = @"
# PHASE 12.0C FAST READ-ONLY PROJECT DISCOVERY REPORT

Generated: $(Get-Date -Format "yyyy-MM-dd HH:mm:ss")

Project Root:
$ProjectRoot

Control Root:
$ControlRoot

Discovery Root:
$DiscoveryRoot

## Result

Status:
PASS - FAST READ-ONLY DISCOVERY COMPLETED

## Safety Confirmation

No files were deleted.
No files were renamed.
No files were moved.
No source code was modified.
No database was modified.
No production features were unlocked.
No Phase 11 work was started.

## Scan Summary

Directories scanned:
$ScannedDirectoryCount

Directories skipped before scanning:
$SkippedDirectoryCount

Files discovered:
$FileCount

Code candidate files:
$CodeCount

Frontend candidate files:
$FrontendCount

Backend candidate files:
$BackendCount

Database candidate files:
$DatabaseCount

Documentation files:
$DocumentationCount

Scan errors:
$ErrorCount

Safety file cap:
$MaxFiles

## Main Output Files

1. _LEOS_CONTROL\feature-exploration\discovery\PROJECT-FILE-INVENTORY-FAST.csv
2. _LEOS_CONTROL\feature-exploration\discovery\CODE-CANDIDATE-FILES.csv
3. _LEOS_CONTROL\feature-exploration\discovery\FRONTEND-CANDIDATE-FILES.csv
4. _LEOS_CONTROL\feature-exploration\discovery\BACKEND-CANDIDATE-FILES.csv
5. _LEOS_CONTROL\feature-exploration\discovery\DATABASE-CANDIDATE-FILES.csv
6. _LEOS_CONTROL\feature-exploration\discovery\DOCUMENTATION-FILES.csv
7. _LEOS_CONTROL\feature-exploration\discovery\PACKAGE-AND-STARTUP-FILE-CHECK.csv
8. _LEOS_CONTROL\feature-exploration\discovery\GIT-STATUS.txt
9. _LEOS_CONTROL\feature-exploration\discovery\ACTIVE-PORTS.txt
10. _LEOS_CONTROL\feature-exploration\matrix\FEATURE-CONNECTION-MATRIX-FAST.csv

## Next Action

Open the fast report and feature matrix:

notepad "_LEOS_CONTROL\reports\PHASE-12.0C-FAST-READONLY-PROJECT-DISCOVERY-REPORT.md"

notepad "_LEOS_CONTROL\feature-exploration\matrix\FEATURE-CONNECTION-MATRIX-FAST.csv"

Then paste the report back into ChatGPT.

## Governance Ruling

Feature exploration remains LAB ONLY.

Production unlock remains BLOCKED.

Phase 11 remains LOCKED.
"@

Save-Text -Path $ReportPath -Content $Report

Write-Host ""
Write-Pass "PHASE 12.0C FAST READ-ONLY DISCOVERY COMPLETE"
Write-Host ""
Write-Host "Open fast report:" -ForegroundColor Cyan
Write-Host "notepad `"_LEOS_CONTROL\reports\PHASE-12.0C-FAST-READONLY-PROJECT-DISCOVERY-REPORT.md`""
Write-Host ""
Write-Host "Open feature matrix:" -ForegroundColor Cyan
Write-Host "notepad `"_LEOS_CONTROL\feature-exploration\matrix\FEATURE-CONNECTION-MATRIX-FAST.csv`""
Write-Host ""
Write-Pass "Safe to proceed to feature connection review after you paste the report."
