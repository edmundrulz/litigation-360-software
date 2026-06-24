# ============================================================
# L360_START_ALL.ps1
# PowerShell 7 compatible launcher for Litigation 360 / LEOS
#
# What it does:
# 1. Uses the CLEANROOM folder first.
# 2. Stops old Node/Vite/backend processes on common project ports.
# 3. Starts backend in its own PowerShell window.
# 4. Starts frontend in its own PowerShell window.
# 5. Starts a live monitor in its own PowerShell window.
# 6. Does NOT delete folders.
# 7. Does NOT touch LEOS_CONTROL.
# ============================================================

$ErrorActionPreference = "Continue"

# ----------------------------
# FIXED PROJECT PATHS
# ----------------------------
$Workspace = "C:\Users\jep_edmundrulz\litigation-360-workspace"

$CleanroomRoot = Join-Path $Workspace "litigation-360-software-CLEANROOM-13C"
$MainRoot      = Join-Path $Workspace "litigation-360-software"
$ControlRoot   = Join-Path $Workspace "litigation-360-software_LEOS_CONTROL"

# Prefer cleanroom if it exists, because cutover is not certified yet.
if (Test-Path -LiteralPath $CleanroomRoot) {
    $ProjectRoot = $CleanroomRoot
    $Mode = "CLEANROOM-13C"
}
elseif (Test-Path -LiteralPath $MainRoot) {
    $ProjectRoot = $MainRoot
    $Mode = "MAIN"
}
else {
    Write-Host ""
    Write-Host "ERROR: No project folder found." -ForegroundColor Red
    Write-Host "Checked:"
    Write-Host "  $CleanroomRoot"
    Write-Host "  $MainRoot"
    Read-Host "Press ENTER to exit"
    exit 1
}

$BackendDir  = Join-Path $ProjectRoot "backend"
$FrontendDir = Join-Path $ProjectRoot "frontend"
$RunnerDir   = Join-Path $Workspace "_L360_RUNNER"
$LogDir      = Join-Path $RunnerDir "logs"

New-Item -ItemType Directory -Force -Path $RunnerDir | Out-Null
New-Item -ItemType Directory -Force -Path $LogDir | Out-Null

$Stamp = Get-Date -Format "yyyyMMdd_HHmmss"
$BackendLog  = Join-Path $LogDir "backend_$Stamp.log"
$FrontendLog = Join-Path $LogDir "frontend_$Stamp.log"
$MonitorLog  = Join-Path $LogDir "monitor_$Stamp.log"
$StateFile   = Join-Path $RunnerDir "L360_LAST_LAUNCH_STATE.txt"

# ----------------------------
# DISPLAY HEADER
# ----------------------------
Clear-Host
Write-Host "============================================================" -ForegroundColor Cyan
Write-Host " L360 / LEOS MASTER LAUNCHER" -ForegroundColor Cyan
Write-Host "============================================================" -ForegroundColor Cyan
Write-Host "Mode        : $Mode"
Write-Host "ProjectRoot : $ProjectRoot"
Write-Host "BackendDir  : $BackendDir"
Write-Host "FrontendDir : $FrontendDir"
Write-Host "RunnerDir   : $RunnerDir"
Write-Host "LEOS_CONTROL: $ControlRoot"
Write-Host "============================================================" -ForegroundColor Cyan
Write-Host ""

# ----------------------------
# BASIC FOLDER VERIFICATION
# ----------------------------
$checks = @(
    [pscustomobject]@{ Item="Project root"; Path=$ProjectRoot; Exists=(Test-Path -LiteralPath $ProjectRoot) },
    [pscustomobject]@{ Item="Backend folder"; Path=$BackendDir; Exists=(Test-Path -LiteralPath $BackendDir) },
    [pscustomobject]@{ Item="Frontend folder"; Path=$FrontendDir; Exists=(Test-Path -LiteralPath $FrontendDir) },
    [pscustomobject]@{ Item="Backend package.json"; Path=(Join-Path $BackendDir "package.json"); Exists=(Test-Path -LiteralPath (Join-Path $BackendDir "package.json")) },
    [pscustomobject]@{ Item="Frontend package.json"; Path=(Join-Path $FrontendDir "package.json"); Exists=(Test-Path -LiteralPath (Join-Path $FrontendDir "package.json")) },
    [pscustomobject]@{ Item="LEOS_CONTROL untouched"; Path=$ControlRoot; Exists=(Test-Path -LiteralPath $ControlRoot) }
)

$checks | Format-Table -AutoSize

$failed = $checks | Where-Object { $_.Item -ne "LEOS_CONTROL untouched" -and $_.Exists -eq $false }
if ($failed.Count -gt 0) {
    Write-Host ""
    Write-Host "ERROR: Required files/folders are missing. Launcher stopped safely." -ForegroundColor Red
    $failed | Format-Table -AutoSize
    Read-Host "Press ENTER to exit"
    exit 1
}

# ----------------------------
# FIND POWERSHELL EXECUTABLE
# ----------------------------
$Pwsh = (Get-Command pwsh -ErrorAction SilentlyContinue).Source
if (-not $Pwsh) {
    $Pwsh = (Get-Command powershell -ErrorAction SilentlyContinue).Source
}
if (-not $Pwsh) {
    Write-Host "ERROR: No PowerShell executable found." -ForegroundColor Red
    Read-Host "Press ENTER to exit"
    exit 1
}

# ----------------------------
# PORT CLEANUP
# ----------------------------
# Conservative project ports based on previous L360 usage.
$PortsToClean = @(3000, 4173, 5000, 5060, 5061, 5100, 5173, 8080)

Write-Host ""
Write-Host "Stopping old processes on known L360 dev ports..." -ForegroundColor Yellow

foreach ($port in $PortsToClean) {
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
                            Write-Host "  Port $port => stopping PID $procId ($($proc.ProcessName))"
                            Stop-Process -Id $procId -Force -ErrorAction SilentlyContinue
                        }
                    }
                }
            }
        }
    }
    catch {
        Write-Host "  Port $port cleanup skipped: $($_.Exception.Message)" -ForegroundColor DarkYellow
    }
}

Start-Sleep -Seconds 2

# ----------------------------
# HELPERS
# ----------------------------
function Get-NpmCommand {
    param(
        [Parameter(Mandatory=$true)][string]$Dir,
        [Parameter(Mandatory=$true)][ValidateSet("backend","frontend")][string]$Kind
    )

    $pkgPath = Join-Path $Dir "package.json"
    if (-not (Test-Path -LiteralPath $pkgPath)) {
        return $null
    }

    try {
        $pkg = Get-Content -Raw -LiteralPath $pkgPath | ConvertFrom-Json
        $names = @()
        if ($pkg.scripts) {
            $names = @($pkg.scripts.PSObject.Properties.Name)
        }

        if ($Kind -eq "backend") {
            if ($names -contains "dev")   { return "npm run dev" }
            if ($names -contains "start") { return "npm start" }
            if (Test-Path -LiteralPath (Join-Path $Dir "server.js")) { return "node server.js" }
            if (Test-Path -LiteralPath (Join-Path $Dir "src\server.js")) { return "node src\server.js" }
            if (Test-Path -LiteralPath (Join-Path $Dir "src\index.js")) { return "node src\index.js" }
        }

        if ($Kind -eq "frontend") {
            if ($names -contains "dev")     { return "npm run dev" }
            if ($names -contains "start")   { return "npm start" }
            if ($names -contains "preview") { return "npm run preview" }
        }
    }
    catch {
        return $null
    }

    return $null
}

$BackendCmd = Get-NpmCommand -Dir $BackendDir -Kind "backend"
$FrontendCmd = Get-NpmCommand -Dir $FrontendDir -Kind "frontend"

if (-not $BackendCmd) {
    Write-Host "ERROR: Could not determine backend start command." -ForegroundColor Red
    Read-Host "Press ENTER to exit"
    exit 1
}
if (-not $FrontendCmd) {
    Write-Host "ERROR: Could not determine frontend start command." -ForegroundColor Red
    Read-Host "Press ENTER to exit"
    exit 1
}

# ----------------------------
# CREATE CHILD SCRIPTS
# ----------------------------
$BackendRunner = Join-Path $RunnerDir "RUN_BACKEND.ps1"
$FrontendRunner = Join-Path $RunnerDir "RUN_FRONTEND.ps1"
$MonitorRunner = Join-Path $RunnerDir "RUN_MONITOR.ps1"

$backendScript = @"
`$ErrorActionPreference = "Continue"
`$Host.UI.RawUI.WindowTitle = "L360 BACKEND - $Mode"
Set-Location -LiteralPath "$BackendDir"
Clear-Host
Write-Host "============================================================" -ForegroundColor Green
Write-Host " L360 BACKEND WINDOW" -ForegroundColor Green
Write-Host "============================================================" -ForegroundColor Green
Write-Host "Project : $ProjectRoot"
Write-Host "Backend : $BackendDir"
Write-Host "Command : $BackendCmd"
Write-Host "Log     : $BackendLog"
Write-Host "============================================================" -ForegroundColor Green
Write-Host ""
Write-Host "Starting backend..." -ForegroundColor Green
Write-Host ""
cmd /c "$BackendCmd 2>&1" | Tee-Object -FilePath "$BackendLog" -Append
Write-Host ""
Write-Host "Backend process ended. Review the log above." -ForegroundColor Yellow
Read-Host "Press ENTER to close backend window"
"@

$frontendScript = @"
`$ErrorActionPreference = "Continue"
`$Host.UI.RawUI.WindowTitle = "L360 FRONTEND - $Mode"
Set-Location -LiteralPath "$FrontendDir"
Clear-Host
Write-Host "============================================================" -ForegroundColor Magenta
Write-Host " L360 FRONTEND WINDOW" -ForegroundColor Magenta
Write-Host "============================================================" -ForegroundColor Magenta
Write-Host "Project  : $ProjectRoot"
Write-Host "Frontend : $FrontendDir"
Write-Host "Command  : $FrontendCmd"
Write-Host "Log      : $FrontendLog"
Write-Host "============================================================" -ForegroundColor Magenta
Write-Host ""
Write-Host "Starting frontend..." -ForegroundColor Magenta
Write-Host ""
cmd /c "$FrontendCmd 2>&1" | Tee-Object -FilePath "$FrontendLog" -Append
Write-Host ""
Write-Host "Frontend process ended. Review the log above." -ForegroundColor Yellow
Read-Host "Press ENTER to close frontend window"
"@

$monitorScript = @"
`$ErrorActionPreference = "Continue"
`$Host.UI.RawUI.WindowTitle = "L360 LIVE MONITOR - $Mode"

`$BackendPorts = @(5000,5100,5060,5061,8080)
`$FrontendPorts = @(5173,3000,4173)
`$BackendPaths = @("/api/status","/api/health")
`$MonitorLog = "$MonitorLog"
`$ProjectRoot = "$ProjectRoot"
`$Mode = "$Mode"

function Test-UrlSafe {
    param([string]`$Url, [int]`$TimeoutSec = 2)
    try {
        `$r = Invoke-WebRequest -UseBasicParsing -TimeoutSec `$TimeoutSec -Uri `$Url
        return [pscustomobject]@{ Url=`$Url; Status=`$r.StatusCode; Result="PASS" }
    }
    catch {
        return [pscustomobject]@{ Url=`$Url; Status=""; Result="WAIT" }
    }
}

while (`$true) {
    Clear-Host
    `$now = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    Write-Host "============================================================" -ForegroundColor Cyan
    Write-Host " L360 LIVE MONITOR" -ForegroundColor Cyan
    Write-Host "============================================================" -ForegroundColor Cyan
    Write-Host "Time       : `$now"
    Write-Host "Mode       : `$Mode"
    Write-Host "Project    : `$ProjectRoot"
    Write-Host "MonitorLog : `$MonitorLog"
    Write-Host "============================================================" -ForegroundColor Cyan
    Write-Host ""

    `$backendResults = @()
    foreach (`$p in `$BackendPorts) {
        foreach (`$path in `$BackendPaths) {
            `$backendResults += Test-UrlSafe -Url "http://localhost:`$p`$path" -TimeoutSec 2
        }
    }

    `$frontendResults = @()
    foreach (`$p in `$FrontendPorts) {
        `$frontendResults += Test-UrlSafe -Url "http://localhost:`$p" -TimeoutSec 2
    }

    Write-Host "BACKEND API CHECKS" -ForegroundColor Green
    `$backendResults | Format-Table -AutoSize

    Write-Host ""
    Write-Host "FRONTEND CHECKS" -ForegroundColor Magenta
    `$frontendResults | Format-Table -AutoSize

    `$backendPass = `$backendResults | Where-Object { `$_.Result -eq "PASS" }
    `$frontendPass = `$frontendResults | Where-Object { `$_.Result -eq "PASS" }

    Write-Host ""
    Write-Host "SUMMARY" -ForegroundColor Yellow
    if (`$backendPass.Count -gt 0) {
        Write-Host "Backend : PASS - at least one backend endpoint responded." -ForegroundColor Green
    } else {
        Write-Host "Backend : WAIT - no backend API response yet." -ForegroundColor Yellow
    }

    if (`$frontendPass.Count -gt 0) {
        Write-Host "Frontend: PASS - frontend responded." -ForegroundColor Green
    } else {
        Write-Host "Frontend: WAIT - no frontend response yet." -ForegroundColor Yellow
    }

    if ((`$backendPass.Count -gt 0) -and (`$frontendPass.Count -gt 0)) {
        Write-Host ""
        Write-Host "OPEN THIS IN BROWSER:" -ForegroundColor Cyan
        if (`$frontendResults | Where-Object { `$_.Url -eq "http://localhost:5173" -and `$_.Result -eq "PASS" }) {
            Write-Host "http://localhost:5173" -ForegroundColor Cyan
        } elseif (`$frontendPass.Count -gt 0) {
            Write-Host `$frontendPass[0].Url -ForegroundColor Cyan
        }
    }

    "`$now | BackendPass=`$(`$backendPass.Count) | FrontendPass=`$(`$frontendPass.Count)" | Out-File -LiteralPath `$MonitorLog -Append

    Write-Host ""
    Write-Host "Refreshes every 5 seconds. Press CTRL+C to stop monitor." -ForegroundColor DarkGray
    Start-Sleep -Seconds 5
}
"@

Set-Content -LiteralPath $BackendRunner -Value $backendScript -Encoding UTF8
Set-Content -LiteralPath $FrontendRunner -Value $frontendScript -Encoding UTF8
Set-Content -LiteralPath $MonitorRunner -Value $monitorScript -Encoding UTF8

# ----------------------------
# WRITE STATE FILE
# ----------------------------
@"
L360 / LEOS LAST LAUNCH STATE
Generated: $(Get-Date -Format "yyyy-MM-dd HH:mm:ss")
Mode: $Mode
ProjectRoot: $ProjectRoot
BackendDir: $BackendDir
FrontendDir: $FrontendDir
BackendCmd: $BackendCmd
FrontendCmd: $FrontendCmd
BackendLog: $BackendLog
FrontendLog: $FrontendLog
MonitorLog: $MonitorLog
Ports cleaned: $($PortsToClean -join ", ")
NOTE:
- This launcher does not delete folders.
- This launcher does not touch litigation-360-software_LEOS_CONTROL.
- Cleanroom is preferred if present.
"@ | Set-Content -LiteralPath $StateFile -Encoding UTF8

# ----------------------------
# LAUNCH WINDOWS
# ----------------------------
Write-Host ""
Write-Host "Launching required windows..." -ForegroundColor Cyan
Write-Host "1. Backend window"
Write-Host "2. Frontend window"
Write-Host "3. Live monitor window"
Write-Host ""

Start-Process -FilePath $Pwsh -ArgumentList @("-NoLogo","-NoProfile","-ExecutionPolicy","Bypass","-File",$BackendRunner) -WindowStyle Normal
Start-Sleep -Seconds 4

Start-Process -FilePath $Pwsh -ArgumentList @("-NoLogo","-NoProfile","-ExecutionPolicy","Bypass","-File",$FrontendRunner) -WindowStyle Normal
Start-Sleep -Seconds 4

Start-Process -FilePath $Pwsh -ArgumentList @("-NoLogo","-NoProfile","-ExecutionPolicy","Bypass","-File",$MonitorRunner) -WindowStyle Normal

Write-Host "============================================================" -ForegroundColor Green
Write-Host " LAUNCH COMPLETE" -ForegroundColor Green
Write-Host "============================================================" -ForegroundColor Green
Write-Host "Keep these windows open:"
Write-Host "  1. L360 BACKEND"
Write-Host "  2. L360 FRONTEND"
Write-Host "  3. L360 LIVE MONITOR"
Write-Host ""
Write-Host "State file:"
Write-Host "  $StateFile"
Write-Host ""
Write-Host "Logs folder:"
Write-Host "  $LogDir"
Write-Host ""
Write-Host "When monitor shows Backend PASS and Frontend PASS, open:"
Write-Host "  http://localhost:5173"
Write-Host "============================================================" -ForegroundColor Green
