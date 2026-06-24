param(
    [ValidateSet("DRYRUN","APPLY")]
    [string]$Mode = "DRYRUN"
)

$ErrorActionPreference = "Continue"

$ProjectRoot = "C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software"
$PhaseDir = Join-Path $ProjectRoot "_operations\phase-10A-cleanup-and-handover-v3"
$Reports = Join-Path $PhaseDir "reports"
$Logs = Join-Path $PhaseDir "logs"
$Quarantine = Join-Path $PhaseDir "quarantine"
$Handover = Join-Path $PhaseDir "handover"

New-Item -ItemType Directory -Force -Path $PhaseDir,$Reports,$Logs,$Quarantine,$Handover | Out-Null

$LogFile = Join-Path $Logs "cleanup-v3-log.txt"

function Log {
    param([string]$Text)
    $stamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    Add-Content -LiteralPath $LogFile -Value "[$stamp] $Text"
}

Clear-Host
Write-Host "============================================================"
Write-Host "LITIGATION 360 - SAFE CLEANUP V3 DIRECT POWERSHELL"
Write-Host "============================================================"
Write-Host ""
Write-Host "Project root:"
Write-Host $ProjectRoot
Write-Host ""
Write-Host "Mode:"
Write-Host $Mode
Write-Host ""
Write-Host "Log:"
Write-Host $LogFile
Write-Host ""

Log "============================================================"
Log "L360 SAFE CLEANUP V3 START"
Log "Mode: $Mode"
Log "ProjectRoot: $ProjectRoot"

if (!(Test-Path -LiteralPath (Join-Path $ProjectRoot "backend"))) {
    Write-Host "ERROR: backend folder not found." -ForegroundColor Red
    Log "ERROR backend folder not found"
    Read-Host "Press Enter to close"
    exit 1
}

Write-Host "Creating inventories..."
Log "Creating inventories"

Get-ChildItem -LiteralPath $ProjectRoot -Force |
    Select-Object Mode,Length,LastWriteTime,Name |
    Out-File -LiteralPath (Join-Path $Reports "root-before-cleanup.txt") -Encoding UTF8

Get-ChildItem -LiteralPath $ProjectRoot -Force -Directory |
    Select-Object Name,FullName,LastWriteTime |
    Out-File -LiteralPath (Join-Path $Reports "folders-before-cleanup.txt") -Encoding UTF8

Get-ChildItem -LiteralPath $ProjectRoot -Force -File |
    Select-Object Name,Length,FullName,LastWriteTime |
    Out-File -LiteralPath (Join-Path $Reports "files-before-cleanup.txt") -Encoding UTF8

$HandoverText = @"
LITIGATION 360 - MASTER HANDOVER PATH MAP
==========================================

Project Root:
$ProjectRoot

Backend:
$ProjectRoot\backend

Backend Source:
$ProjectRoot\backend\src

Frontend:
$ProjectRoot\frontend

Operations:
$ProjectRoot\_operations

Phase 9.9 Golden Snapshot:
$ProjectRoot\_operations\phase-09-9-hardening\06-golden-snapshot

Phase 10A Handler Registry:
$ProjectRoot\_operations\phase-10A-handler-registry

Phase 10A Cleanup V3:
$PhaseDir

Rule:
No direct deletion. Quarantine first. Verify system. Delete later only after confidence.
"@

$HandoverText | Out-File -LiteralPath (Join-Path $Handover "MASTER-HANDOVER-PATH-MAP.txt") -Encoding UTF8

$NextPrompt = @"
Continue Litigation 360 from this exact location:

Project root:
$ProjectRoot

Backend:
$ProjectRoot\backend

Frontend:
$ProjectRoot\frontend

Operations:
$ProjectRoot\_operations

Golden Snapshot:
$ProjectRoot\_operations\phase-09-9-hardening\06-golden-snapshot

Phase 10A Handler Registry:
$ProjectRoot\_operations\phase-10A-handler-registry

Cleanup V3:
$PhaseDir

Continue with Phase 10A cleanup verification, handler route mounting, startup validation, and report update.
"@

$NextPrompt | Out-File -LiteralPath (Join-Path $Handover "NEXT-THREAD-OPENING-PROMPT.txt") -Encoding UTF8

# Known accidental CMD artifact names visible from your root listing.
# This list uses PowerShell LiteralPath, so names with brackets, quotes, parentheses, and backticks are handled safely.
$JunkNames = @(
    '%NODE%',
    '(',
    'clearInterval(timer)',
    "console.log('-'",
    "console.log('[CLEANUP]",
    'console.log(`[CLEANUP]',
    'fs.existsSync(candidate))',
    "r.name).join('",
    '{',
    '{)',
    "'No",
    "'`'",
    "'```sql",
    '+',
    'at',
    'bytes',
    'count',
    'Database',
    'Date().toString()',
    'dbPath',
    'ERROR',
    'executed',
    'expected',
    'file',
    'Files',
    'Found',
    'Inventory',
    'migration',
    'modified',
    'new',
    'No',
    'not',
    'only',
    'path',
    'READ',
    'Row',
    'Safety',
    'SQLite',
    'stat.mtime.toString()',
    'stat.size',
    'Status',
    'table.name',
    'table.sql',
    'Tables',
    'Target',
    'YES'
)

$Moved = New-Object System.Collections.Generic.List[object]
$WouldMove = New-Object System.Collections.Generic.List[object]
$Missing = New-Object System.Collections.Generic.List[object]
$Errors = New-Object System.Collections.Generic.List[object]

Write-Host "Scanning known junk artifacts..."
Log "Scanning known junk artifacts"

foreach ($Name in $JunkNames) {
    $Target = Join-Path $ProjectRoot $Name

    if (Test-Path -LiteralPath $Target) {
        $SafeName = $Name

        foreach ($c in [IO.Path]::GetInvalidFileNameChars()) {
            $SafeName = $SafeName.Replace($c, "_")
        }

        if ([string]::IsNullOrWhiteSpace($SafeName)) {
            $SafeName = "blank-name-artifact"
        }

        $Destination = Join-Path $Quarantine $SafeName

        if ($Mode -eq "APPLY") {
            try {
                if (Test-Path -LiteralPath $Destination) {
                    $Destination = Join-Path $Quarantine ($SafeName + "_" + (Get-Date -Format "yyyyMMdd_HHmmss"))
                }

                Move-Item -LiteralPath $Target -Destination $Destination -Force
                $Moved.Add([pscustomobject]@{
                    Name = $Name
                    From = $Target
                    To = $Destination
                }) | Out-Null

                Write-Host "MOVED: $Name"
                Log "MOVED: $Target --> $Destination"
            }
            catch {
                $Errors.Add([pscustomobject]@{
                    Name = $Name
                    Path = $Target
                    Error = $_.Exception.Message
                }) | Out-Null

                Write-Host "ERROR MOVING: $Name" -ForegroundColor Yellow
                Log "ERROR MOVING: $Target :: $($_.Exception.Message)"
            }
        }
        else {
            $WouldMove.Add([pscustomobject]@{
                Name = $Name
                Path = $Target
            }) | Out-Null

            Write-Host "DRYRUN would move: $Name"
            Log "DRYRUN WOULD MOVE: $Target"
        }
    }
    else {
        $Missing.Add($Name) | Out-Null
    }
}

$WouldMove | Format-Table -AutoSize | Out-File -LiteralPath (Join-Path $Reports "dryrun-would-move.txt") -Encoding UTF8
$Moved | Format-Table -AutoSize | Out-File -LiteralPath (Join-Path $Reports "apply-moved-items.txt") -Encoding UTF8
$Errors | Format-Table -AutoSize | Out-File -LiteralPath (Join-Path $Reports "apply-errors.txt") -Encoding UTF8
$Missing | Out-File -LiteralPath (Join-Path $Reports "missing-known-junk.txt") -Encoding UTF8

Get-ChildItem -LiteralPath $ProjectRoot -Force |
    Select-Object Mode,Length,LastWriteTime,Name |
    Out-File -LiteralPath (Join-Path $Reports "root-after-cleanup.txt") -Encoding UTF8

Get-ChildItem -LiteralPath $Quarantine -Force |
    Select-Object Mode,Length,LastWriteTime,Name |
    Out-File -LiteralPath (Join-Path $Reports "quarantine-inventory.txt") -Encoding UTF8

Write-Host ""
Write-Host "============================================================"
Write-Host "SAFE CLEANUP V3 COMPLETE"
Write-Host "============================================================"
Write-Host ""

if ($Mode -eq "APPLY") {
    Write-Host "Moved to quarantine: $($Moved.Count)"
    Write-Host "Errors: $($Errors.Count)"
}
else {
    Write-Host "DRYRUN only. Nothing moved."
    Write-Host "Would move: $($WouldMove.Count)"
    Write-Host ""
    Write-Host "To apply quarantine, run:"
    Write-Host 'powershell -NoProfile -ExecutionPolicy Bypass -File ".\L360-SAFE-CLEANUP-V3.ps1" -Mode APPLY'
}

Write-Host ""
Write-Host "Reports:"
Write-Host $Reports
Write-Host ""
Write-Host "Quarantine:"
Write-Host $Quarantine
Write-Host ""
Write-Host "Handover:"
Write-Host $Handover
Write-Host ""
Log "L360 SAFE CLEANUP V3 COMPLETE"

Read-Host "Press Enter to close"
