# ============================================================
# L360_PHASE13C_FINALIZER_V4_AFTER_REBOOT.ps1
#
# Purpose:
#   Run ONCE immediately after reboot/login to complete Phase 13C
#   before VS Code/File Explorer/dev servers relock the project folder.
#
# Safe behavior:
#   - Does NOT delete anything.
#   - Does NOT touch litigation-360-software_LEOS_CONTROL.
#   - Does NOT run git clean.
#   - Does NOT run git reset --hard.
#   - Does NOT edit backend/database/RBAC/auth/routes/package/env files.
#
# Final target:
#   litigation-360-software
#     = official active MAIN
#
#   litigation-360-software-POLLUTED-ARCHIVE-CUTOVER-V4...
#     = old main preserved
#
#   litigation-360-software-CLEANROOM-13C
#     = should no longer exist after success
# ============================================================

$ErrorActionPreference = "Stop"

$Workspace = "C:\Users\jep_edmundrulz\litigation-360-workspace"
$RunnerDir = Join-Path $Workspace "_L360_RUNNER"
$LogDir = Join-Path $RunnerDir "logs"

$MainRoot = Join-Path $Workspace "litigation-360-software"
$CleanroomRoot = Join-Path $Workspace "litigation-360-software-CLEANROOM-13C"
$ControlRoot = Join-Path $Workspace "litigation-360-software_LEOS_CONTROL"

New-Item -ItemType Directory -Force -Path $RunnerDir | Out-Null
New-Item -ItemType Directory -Force -Path $LogDir | Out-Null

$Stamp = Get-Date -Format "yyyyMMdd_HHmmss"
$LogFile = Join-Path $LogDir "phase13c_finalizer_v4_after_reboot_$Stamp.log"
$ResultFile = Join-Path $RunnerDir "PHASE13C_V4_AFTER_REBOOT_RESULT.txt"

Set-Location -LiteralPath $Workspace

function Write-Step {
    param([string]$Message, [string]$Color = "White")
    $line = "[$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')] $Message"
    Write-Host $line -ForegroundColor $Color
    $line | Out-File -LiteralPath $LogFile -Append -Encoding UTF8
}

function Require-Path {
    param([string]$Label, [string]$Path)
    if (-not (Test-Path -LiteralPath $Path)) {
        throw "Missing required path: $Label => $Path"
    }
    Write-Step "Verified: $Label => $Path" "Green"
}

function Close-ProjectExplorerWindows {
    try {
        $shell = New-Object -ComObject Shell.Application
        $windows = @($shell.Windows())
        foreach ($w in $windows) {
            try {
                $loc = [string]$w.LocationURL
                $decoded = [System.Uri]::UnescapeDataString($loc)
                if ($decoded -like "*litigation-360-workspace*" -or $decoded -like "*litigation-360-software*") {
                    Write-Step "Closing File Explorer window at: $decoded" "DarkYellow"
                    $w.Quit()
                }
            } catch {}
        }
    } catch {
        Write-Step "Explorer window scan skipped: $($_.Exception.Message)" "DarkYellow"
    }
}

function Stop-ProjectPorts {
    $Ports = @(3000,4173,5000,5060,5061,5100,5173,8080)
    Write-Step "Stopping known project dev ports if any are active." "Yellow"

    foreach ($port in $Ports) {
        try {
            $lines = netstat -ano | Select-String ":$port\s"
            foreach ($line in $lines) {
                $parts = ($line.ToString() -split "\s+") | Where-Object { $_ -ne "" }
                if ($parts.Count -ge 5) {
                    $pidText = $parts[-1]
                    $procId = 0
                    if ([int]::TryParse($pidText, [ref]$procId)) {
                        if ($procId -gt 0 -and $procId -ne $PID) {
                            $proc = Get-Process -Id $procId -ErrorAction SilentlyContinue
                            if ($proc) {
                                Write-Step "Port $port => stopping PID $procId ($($proc.ProcessName))" "DarkYellow"
                                Stop-Process -Id $procId -Force -ErrorAction SilentlyContinue
                            }
                        }
                    }
                }
            }
        } catch {
            Write-Step "Port $port cleanup skipped: $($_.Exception.Message)" "DarkYellow"
        }
    }

    Start-Sleep -Seconds 2
}

function Close-VSCode {
    $codes = @(Get-Process -Name "Code" -ErrorAction SilentlyContinue)
    foreach ($p in $codes) {
        try {
            Write-Step "Closing VS Code PID $($p.Id)" "DarkYellow"
            $null = $p.CloseMainWindow()
        } catch {}
    }

    Start-Sleep -Seconds 2

    $codes = @(Get-Process -Name "Code" -ErrorAction SilentlyContinue)
    foreach ($p in $codes) {
        try {
            Write-Step "Force closing VS Code PID $($p.Id)" "DarkYellow"
            Stop-Process -Id $p.Id -Force -ErrorAction SilentlyContinue
        } catch {}
    }
}

function Has-CutoverMarker {
    param([string]$Root)
    $active = Join-Path $Root "_L360_ACTIVE_CONTROL"
    if (-not (Test-Path -LiteralPath $active)) { return $false }

    $markers = @()
    $markers += @(Get-ChildItem -LiteralPath $active -File -Filter "*CUTOVER*" -ErrorAction SilentlyContinue)
    $markers += @(Get-ChildItem -LiteralPath $active -File -Filter "*FINALIZED*" -ErrorAction SilentlyContinue)

    $status = Join-Path $active "00_PHASE_13C_CLEANROOM_CUTOVER_STATUS.md"
    if (Test-Path -LiteralPath $status) { $markers += @(Get-Item -LiteralPath $status) }

    return ($markers.Count -gt 0)
}

function Get-ArchiveFolders {
    return @(Get-ChildItem -LiteralPath $Workspace -Directory -Filter "litigation-360-software-POLLUTED-ARCHIVE-CUTOVER*" -ErrorAction SilentlyContinue)
}

function Get-UniqueName {
    param([string]$BaseName)
    $candidatePath = Join-Path $Workspace $BaseName
    if (-not (Test-Path -LiteralPath $candidatePath)) { return $BaseName }
    return ($BaseName + "-" + $Stamp)
}

function Rename-With-Retry {
    param(
        [string]$FromPath,
        [string]$ToName,
        [int]$Retries = 8
    )

    for ($i = 1; $i -le $Retries; $i++) {
        try {
            Set-Location -LiteralPath $Workspace
            Write-Step "Rename attempt $i/$Retries FROM: $FromPath" "Cyan"
            Write-Step "Rename attempt $i/$Retries TO  : $ToName" "Cyan"
            Rename-Item -LiteralPath $FromPath -NewName $ToName -ErrorAction Stop
            Write-Step "Rename succeeded on attempt $i." "Green"
            return
        }
        catch {
            Write-Step "Rename attempt $i failed: $($_.Exception.Message)" "Red"
            Close-ProjectExplorerWindows
            Close-VSCode
            Stop-ProjectPorts
            Start-Sleep -Seconds 3
        }
    }

    throw "Rename failed after $Retries attempts: $FromPath"
}

function Write-ResultFile {
    param([bool]$Pass, [string]$Message)

    $archiveFolders = Get-ArchiveFolders
    $cleanroomExists = Test-Path -LiteralPath $CleanroomRoot

    $content = @"
L360 PHASE 13C FINALIZER V4 AFTER REBOOT RESULT
Generated: $(Get-Date -Format "yyyy-MM-dd HH:mm:ss")

PASS: $Pass
Message: $Message

MainRoot:
$MainRoot

CleanroomRootExists:
$cleanroomExists

ArchiveFolderCount:
$($archiveFolders.Count)

LogFile:
$LogFile

Next if PASS:
1. Run:
   $RunnerDir\L360_START_ALL.bat

2. Confirm:
   Mode: MAIN
   Backend: PASS
   Frontend: PASS

3. Rerun:
   L360_PHASE13B_FRONTEND_STATUS_CLARITY.bat

Next if FAIL:
- Copy this result file and latest V4 log back to ChatGPT.
- Do not run Phase 13B yet.
"@

    $content | Set-Content -LiteralPath $ResultFile -Encoding UTF8
}

try {
    Clear-Host
    Write-Host "============================================================" -ForegroundColor Cyan
    Write-Host " L360 PHASE 13C FINALIZER V4 — AFTER REBOOT" -ForegroundColor Cyan
    Write-Host "============================================================" -ForegroundColor Cyan
    Write-Host "Workspace : $Workspace"
    Write-Host "Main      : $MainRoot"
    Write-Host "Cleanroom : $CleanroomRoot"
    Write-Host "Control   : $ControlRoot"
    Write-Host "Log       : $LogFile"
    Write-Host "============================================================" -ForegroundColor Cyan
    Write-Host ""

    Write-Step "V4 after-reboot finalizer started." "Cyan"
    Write-Step "Working directory: $(Get-Location)" "Cyan"

    Require-Path "Workspace" $Workspace
    Require-Path "Main folder" $MainRoot

    if (Test-Path -LiteralPath $ControlRoot) {
        Write-Step "Verified: LEOS_CONTROL exists and will not be touched." "Green"
    }

    Close-ProjectExplorerWindows
    Close-VSCode
    Stop-ProjectPorts
    Set-Location -LiteralPath $Workspace

    $mainHasMarker = Has-CutoverMarker -Root $MainRoot
    $cleanroomExists = Test-Path -LiteralPath $CleanroomRoot
    $archiveFolders = Get-ArchiveFolders

    Write-Step "Main has cutover/finalizer marker: $mainHasMarker" "Cyan"
    Write-Step "Original cleanroom exists: $cleanroomExists" "Cyan"
    Write-Step "Polluted archive count: $($archiveFolders.Count)" "Cyan"

    if (-not $cleanroomExists) {
        Write-Step "Cleanroom no longer exists. Folder state already final." "Green"
    }
    elseif ($mainHasMarker -and $archiveFolders.Count -ge 1) {
        Write-Step "Main already has marker and archive exists. Renaming leftover cleanroom only." "Green"
        $leftoverName = Get-UniqueName -BaseName "litigation-360-software-CLEANROOM-13C-LEFTOVER-AFTER-CUTOVER-V4"
        Rename-With-Retry -FromPath $CleanroomRoot -ToName $leftoverName
    }
    else {
        Write-Step "Completing full cutover: archive current main, promote cleanroom." "Yellow"

        Require-Path "Cleanroom folder" $CleanroomRoot
        Require-Path "Cleanroom backend package.json" (Join-Path $CleanroomRoot "backend\package.json")
        Require-Path "Cleanroom frontend package.json" (Join-Path $CleanroomRoot "frontend\package.json")

        $archiveName = Get-UniqueName -BaseName "litigation-360-software-POLLUTED-ARCHIVE-CUTOVER-V4"
        Rename-With-Retry -FromPath $MainRoot -ToName $archiveName
        Rename-With-Retry -FromPath $CleanroomRoot -ToName "litigation-360-software"
    }

    # Final checks.
    $finalMainExists = Test-Path -LiteralPath $MainRoot
    $finalCleanroomExists = Test-Path -LiteralPath $CleanroomRoot
    $finalBackendPkg = Test-Path -LiteralPath (Join-Path $MainRoot "backend\package.json")
    $finalFrontendPkg = Test-Path -LiteralPath (Join-Path $MainRoot "frontend\package.json")
    $finalArchives = Get-ArchiveFolders

    $checks = @(
        [pscustomobject]@{ Check="Official MAIN exists"; Expected=$true; Actual=$finalMainExists; Path=$MainRoot },
        [pscustomobject]@{ Check="Original CLEANROOM path removed"; Expected=$false; Actual=$finalCleanroomExists; Path=$CleanroomRoot },
        [pscustomobject]@{ Check="Archive exists"; Expected=$true; Actual=($finalArchives.Count -ge 1); Path=$Workspace },
        [pscustomobject]@{ Check="Backend package in MAIN"; Expected=$true; Actual=$finalBackendPkg; Path=(Join-Path $MainRoot "backend\package.json") },
        [pscustomobject]@{ Check="Frontend package in MAIN"; Expected=$true; Actual=$finalFrontendPkg; Path=(Join-Path $MainRoot "frontend\package.json") }
    )

    Write-Host ""
    Write-Host "FINAL CHECKS:" -ForegroundColor Yellow
    $checks | Format-Table -AutoSize

    $bad = @($checks | Where-Object { $_.Expected -ne $_.Actual })
    if ($bad.Count -gt 0) {
        throw "V4 final checks failed."
    }

    $ActiveControl = Join-Path $MainRoot "_L360_ACTIVE_CONTROL"
    New-Item -ItemType Directory -Force -Path $ActiveControl | Out-Null

    $StatusFile = Join-Path $ActiveControl "00_PHASE_13C_CLEANROOM_CUTOVER_STATUS.md"
    $MarkerFile = Join-Path $ActiveControl ("PHASE13C_FINALIZED_V4_AFTER_REBOOT_" + $Stamp + ".md")

    $status = @"
# L360 / LEOS — Phase 13C Finalized By V4 After Reboot

Generated: $(Get-Date -Format "yyyy-MM-dd HH:mm:ss")

## Verdict

Phase 13C folder-state finalization completed after reboot.

## Final State

| Purpose | Path |
|---|---|
| Official active main folder | `$MainRoot` |
| Original cleanroom path | `$CleanroomRoot` |
| Archive folders location | `$Workspace` |
| LEOS control folder | `$ControlRoot` |

## Safety Notes

- No folder was deleted.
- LEOS_CONTROL was not touched.
- git clean was not run.
- git reset --hard was not run.
- Backend/auth/RBAC/database/package/env files were not edited.

## Next

Run:

`$RunnerDir\L360_START_ALL.bat`

Expected:

- Mode: MAIN
- Backend: PASS
- Frontend: PASS

Then rerun Phase 13B frontend status clarity patch.
"@

    $status | Set-Content -LiteralPath $StatusFile -Encoding UTF8
    $status | Set-Content -LiteralPath $MarkerFile -Encoding UTF8

    Write-Step "Status file written: $StatusFile" "Green"
    Write-Step "Marker file written: $MarkerFile" "Green"

    Write-Host ""
    Write-Host "CURRENT FOLDER STATE:" -ForegroundColor Yellow
    Get-ChildItem -LiteralPath $Workspace -Directory -Filter "litigation-360-software*" |
        Select-Object Name, FullName |
        Format-Table -AutoSize

    Write-Step "PHASE 13C FINALIZER V4 AFTER REBOOT COMPLETED SUCCESSFULLY." "Green"
    Write-ResultFile -Pass $true -Message "Phase 13C finalized successfully after reboot."

    Write-Host ""
    Write-Host "============================================================" -ForegroundColor Green
    Write-Host " V4 SUCCESS" -ForegroundColor Green
    Write-Host "============================================================" -ForegroundColor Green
    Write-Host "Next run:"
    Write-Host "  $RunnerDir\L360_START_ALL.bat"
    Write-Host ""
    Write-Host "Expected:"
    Write-Host "  Mode: MAIN"
    Write-Host "  Backend: PASS"
    Write-Host "  Frontend: PASS"
    Write-Host ""
    Write-Host "Then rerun Phase 13B frontend status clarity patch."
    Write-Host "============================================================" -ForegroundColor Green
}
catch {
    Write-Step "V4 FAILED: $($_.Exception.Message)" "Red"
    Write-ResultFile -Pass $false -Message $_.Exception.Message

    Write-Host ""
    Write-Host "============================================================" -ForegroundColor Red
    Write-Host " V4 FAILED" -ForegroundColor Red
    Write-Host "============================================================" -ForegroundColor Red
    Write-Host "Result file:"
    Write-Host "  $ResultFile"
    Write-Host ""
    Write-Host "Log file:"
    Write-Host "  $LogFile"
    Write-Host ""
    Write-Host "Do not run Phase 13B yet."
    Write-Host "============================================================" -ForegroundColor Red
}

Write-Host ""
Read-Host "Press ENTER to close this V4 window"
