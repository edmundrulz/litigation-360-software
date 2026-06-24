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