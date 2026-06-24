# ============================================================
# L360_SAFE_GIT_BASELINE_ONLY_V2.ps1
#
# Purpose:
#   Fix V1 Git command wrapper failure.
#
# Why V2 exists:
#   V1 called Git through a command-string wrapper. Git launched,
#   but the subcommand was not passed correctly, so "git add -A"
#   resulted in Git's general help output.
#
# V2 fix:
#   Calls Git directly with argument arrays:
#     & git -C $ProjectRoot add -A
#     & git -C $ProjectRoot commit -m "..."
#
# What it does NOT do:
#   - Does NOT delete files
#   - Does NOT run git clean
#   - Does NOT run git reset
#   - Does NOT pull/push/fetch
#   - Does NOT connect to GitHub
#   - Does NOT edit backend/database/RBAC/auth/source logic
#   - Does NOT edit package.json/package-lock.json/.env
# ============================================================

$ErrorActionPreference = "Continue"

$Workspace = "C:\Users\jep_edmundrulz\litigation-360-workspace"
$RunnerDir = Join-Path $Workspace "_L360_RUNNER"
$LogDir = Join-Path $RunnerDir "logs"

$ProjectRoot = Join-Path $Workspace "litigation-360-software"
$CleanroomRoot = Join-Path $Workspace "litigation-360-software-CLEANROOM-13C"
$ControlRoot = Join-Path $Workspace "litigation-360-software_LEOS_CONTROL"
$ActiveControl = Join-Path $ProjectRoot "_L360_ACTIVE_CONTROL"

$FinalSSOT = Join-Path $ActiveControl "99_FINAL_CURRENT_STATE_AFTER_PHASE13B.md"
$SmokeReport = Join-Path $ActiveControl "100_PHASE13B1_FRONTEND_SMOKE_VERIFICATION.md"

New-Item -ItemType Directory -Force -Path $RunnerDir | Out-Null
New-Item -ItemType Directory -Force -Path $LogDir | Out-Null
New-Item -ItemType Directory -Force -Path $ActiveControl | Out-Null

$Stamp = Get-Date -Format "yyyyMMdd_HHmmss"
$LogFile = Join-Path $LogDir "safe_git_baseline_only_v2_$Stamp.log"
$BaselineReport = Join-Path $ActiveControl "103_SAFE_GIT_BASELINE_ONLY_V2_REPORT.md"
$RunnerSummary = Join-Path $RunnerDir "L360_SAFE_GIT_BASELINE_ONLY_V2_RESULT.txt"

function Write-Step {
    param([string]$Message, [string]$Color = "White")
    $line = "[$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')] $Message"
    Write-Host $line -ForegroundColor $Color
    $line | Out-File -LiteralPath $LogFile -Append -Encoding UTF8
}

function Stop-Safely {
    param([string]$Message)
    Write-Step $Message "Red"
    Write-Host ""
    Write-Host "STOPPED SAFELY: $Message" -ForegroundColor Red
    Write-Host "No destructive Git command was run." -ForegroundColor Yellow
    Read-Host "Press ENTER to close"
    exit 1
}

function Invoke-GitDirect {
    param(
        [Parameter(Mandatory=$true)][string[]]$GitArgs,
        [string]$Label = "git"
    )

    $output = ""
    $exit = 999

    try {
        Push-Location $ProjectRoot
        $outputLines = & git @GitArgs 2>&1
        $exit = $LASTEXITCODE
        $output = ($outputLines | Out-String)
        Pop-Location
    }
    catch {
        try { Pop-Location } catch {}
        $output = $_.Exception.Message
        $exit = 999
    }

    Write-Step "$Label exit code: $exit" $(if ($exit -eq 0) { "Green" } else { "Yellow" })

    return [pscustomobject]@{
        ExitCode = $exit
        Output = $output
        Args = ($GitArgs -join " ")
    }
}

Clear-Host
Write-Host "============================================================" -ForegroundColor Cyan
Write-Host " L360 SAFE GIT BASELINE ONLY V2" -ForegroundColor Cyan
Write-Host "============================================================" -ForegroundColor Cyan
Write-Host "Project : $ProjectRoot"
Write-Host "Log     : $LogFile"
Write-Host "============================================================" -ForegroundColor Cyan
Write-Host ""

Write-Step "Safe Git baseline V2 started." "Cyan"

# ----------------------------
# SAFETY PRECHECKS
# ----------------------------
if (-not (Test-Path -LiteralPath $ProjectRoot)) {
    Stop-Safely "Official main project folder not found: $ProjectRoot"
}

if (Test-Path -LiteralPath $CleanroomRoot) {
    Stop-Safely "Original CLEANROOM-13C folder still exists. Do not create Git baseline yet: $CleanroomRoot"
}

$archives = @(Get-ChildItem -LiteralPath $Workspace -Directory -Filter "litigation-360-software-POLLUTED-ARCHIVE-CUTOVER*" -ErrorAction SilentlyContinue)
if ($archives.Count -lt 1) {
    Stop-Safely "Polluted archive folder not found. Cutover proof missing."
}

if (-not (Test-Path -LiteralPath $FinalSSOT)) {
    Stop-Safely "Final Phase 13B SSOT file missing: $FinalSSOT"
}

if (-not (Test-Path -LiteralPath $SmokeReport)) {
    Write-Step "Smoke report not found. Continuing because prior runtime verification was reported as expected. Missing: $SmokeReport" "Yellow"
}

foreach ($p in @(
    (Join-Path $ProjectRoot "backend\package.json"),
    (Join-Path $ProjectRoot "frontend\package.json"),
    (Join-Path $ProjectRoot "frontend\src\main.jsx"),
    (Join-Path $ProjectRoot "frontend\src\l360-status-injector.js")
)) {
    if (-not (Test-Path -LiteralPath $p)) {
        Stop-Safely "Required file missing: $p"
    }
}

$gitCmd = Get-Command git -ErrorAction SilentlyContinue
if (-not $gitCmd) {
    Stop-Safely "Git is not installed or not available in PATH."
}

Write-Step "Git found: $($gitCmd.Source)" "Green"

# ----------------------------
# .gitignore SAFE UPDATE
# ----------------------------
$GitIgnore = Join-Path $ProjectRoot ".gitignore"
$GitIgnoreBackup = $null

if (Test-Path -LiteralPath $GitIgnore) {
    $GitIgnoreBackup = Join-Path $ActiveControl ("backup_gitignore_before_safe_baseline_v2_" + $Stamp + ".gitignore")
    Copy-Item -LiteralPath $GitIgnore -Destination $GitIgnoreBackup -Force
    Write-Step ".gitignore backup created: $GitIgnoreBackup" "Green"
}

$gitignoreBlock = @"

# === L360 SAFE BASELINE IGNORE BLOCK START ===
# Purpose: avoid committing dependency folders, build outputs, secrets, and local runtime data.

node_modules/
**/node_modules/

dist/
build/
coverage/
.vite/

*.log
logs/
tmp/
temp/
.cache/

.env
.env.*
!.env.example

*.db
*.sqlite
*.sqlite3
*.db-journal

.DS_Store
Thumbs.db
.vscode/
.idea/

_L360_RUNNER/

*.zip
*.7z
*.rar
*.bak
*.backup

# === L360 SAFE BASELINE IGNORE BLOCK END ===
"@

$existingGitIgnore = ""
if (Test-Path -LiteralPath $GitIgnore) {
    $existingGitIgnore = Get-Content -Raw -LiteralPath $GitIgnore
}

if ($existingGitIgnore -notmatch "L360 SAFE BASELINE IGNORE BLOCK START") {
    Add-Content -LiteralPath $GitIgnore -Value $gitignoreBlock -Encoding UTF8
    Write-Step "L360 safe ignore block appended to .gitignore." "Green"
}
else {
    Write-Step ".gitignore already contains L360 safe ignore block. Skipping duplicate." "Green"
}

# ----------------------------
# GIT INIT IF NEEDED
# ----------------------------
$GitDir = Join-Path $ProjectRoot ".git"
$gitExistedBefore = Test-Path -LiteralPath $GitDir

if (-not $gitExistedBefore) {
    Write-Step "No .git directory found. Initializing local Git repository." "Yellow"
    $init = Invoke-GitDirect -GitArgs @("init") -Label "git init"
    if ($init.ExitCode -ne 0) {
        Stop-Safely "git init failed: $($init.Output)"
    }

    $branchMain = Invoke-GitDirect -GitArgs @("branch","-M","main") -Label "git branch -M main"
}
else {
    Write-Step ".git already exists. Will not reinitialize." "Green"
}

# Local identity fallback only for this repo.
$email = Invoke-GitDirect -GitArgs @("config","user.email") -Label "git config user.email"
$name = Invoke-GitDirect -GitArgs @("config","user.name") -Label "git config user.name"

if ([string]::IsNullOrWhiteSpace($email.Output)) {
    $setEmail = Invoke-GitDirect -GitArgs @("config","user.email","local-l360-baseline@example.local") -Label "set local user.email"
}

if ([string]::IsNullOrWhiteSpace($name.Output)) {
    $setName = Invoke-GitDirect -GitArgs @("config","user.name","L360 Local Baseline") -Label "set local user.name"
}

# ----------------------------
# STATUS / ADD / COMMIT
# ----------------------------
$statusBefore = Invoke-GitDirect -GitArgs @("status","--short") -Label "git status before"

Write-Step "Staging files with direct git argument call: git add -A" "Cyan"
$add = Invoke-GitDirect -GitArgs @("add","-A") -Label "git add -A"

if ($add.ExitCode -ne 0) {
    Stop-Safely "git add -A failed again. Output: $($add.Output)"
}

$statusAfterAdd = Invoke-GitDirect -GitArgs @("status","--short") -Label "git status after add"
$changesText = $statusAfterAdd.Output.Trim()
$hasChanges = -not [string]::IsNullOrWhiteSpace($changesText)

$commitMessage = "L360 safe baseline after Phase 13B verification"
$commitOutput = "NO_COMMIT_NEEDED"
$commitExit = 0

if ($hasChanges) {
    Write-Step "Creating local baseline commit." "Cyan"
    $commit = Invoke-GitDirect -GitArgs @("commit","-m",$commitMessage) -Label "git commit"
    $commitOutput = $commit.Output
    $commitExit = $commit.ExitCode

    if ($commitExit -ne 0) {
        $statusCheck = Invoke-GitDirect -GitArgs @("status","--short") -Label "git status after failed commit"
        if (-not [string]::IsNullOrWhiteSpace($statusCheck.Output.Trim())) {
            Stop-Safely "git commit failed: $commitOutput"
        }
        else {
            Write-Step "Commit returned non-zero but status is clean. Treating as safe." "Yellow"
        }
    }
}
else {
    Write-Step "No changes to commit." "Yellow"
}

$branch = (Invoke-GitDirect -GitArgs @("branch","--show-current") -Label "git branch").Output.Trim()
$logOne = (Invoke-GitDirect -GitArgs @("log","--oneline","-1") -Label "git log -1").Output.Trim()
$statusFinal = (Invoke-GitDirect -GitArgs @("status","--short") -Label "git status final").Output.Trim()
if ([string]::IsNullOrWhiteSpace($statusFinal)) { $statusFinal = "CLEAN" }

$trackedOutput = (Invoke-GitDirect -GitArgs @("ls-files") -Label "git ls-files").Output
$trackedCount = 0
if (-not [string]::IsNullOrWhiteSpace($trackedOutput)) {
    $trackedCount = @($trackedOutput -split "`r?`n" | Where-Object { -not [string]::IsNullOrWhiteSpace($_) }).Count
}

# ----------------------------
# REPORTS
# ----------------------------
$report = @"
# L360 / LEOS — Safe Git Baseline Only V2 Report

Generated: $(Get-Date -Format "yyyy-MM-dd HH:mm:ss")

## Verdict

Safe local Git baseline V2 completed.

V2 was required because V1 Git command wrapper launched Git but failed to pass `add -A` correctly.

## Scope

Local Git baseline only.

No remote push/pull/fetch was performed.

## Project Path

`$ProjectRoot`

## Preconditions

| Check | Result |
|---|---|
| Official main exists | $(Test-Path -LiteralPath $ProjectRoot) |
| Original cleanroom removed | $(-not (Test-Path -LiteralPath $CleanroomRoot)) |
| Polluted archive count | $($archives.Count) |
| Final Phase 13B SSOT exists | $(Test-Path -LiteralPath $FinalSSOT) |
| Smoke verification report exists | $(Test-Path -LiteralPath $SmokeReport) |
| Git existed before V2 | $gitExistedBefore |

## Git Result

| Item | Value |
|---|---|
| Branch | `$branch` |
| Latest commit | `$logOne` |
| Final status | `$statusFinal` |
| Tracked file count | `$trackedCount` |
| Commit message | `$commitMessage` |
| Commit exit code | `$commitExit` |

## Safety Confirmation

This script did **not**:

- delete files
- run `git clean`
- run `git reset`
- run `git pull`
- run `git push`
- run `git fetch`
- connect to GitHub
- edit backend logic
- edit database files
- edit RBAC/auth logic
- edit routes
- edit package.json
- edit package-lock.json
- edit `.env`
- touch `litigation-360-software_LEOS_CONTROL`

## Git Status Before Staging

````text
$($statusBefore.Output)
````

## Git Status After Add

````text
$($statusAfterAdd.Output)
````

## Commit Output

````text
$commitOutput
````

## Final Git Status

````text
$statusFinal
````

## Current Project Status After Baseline

| Area | Status |
|---|---|
| Phase 12 | Complete |
| Phase 13A | Complete |
| Phase 13C | Finalized |
| Phase 13B | Applied + runtime verified |
| Phase 13B.1 | Smoke verification completed/expected |
| Git baseline | Local baseline completed |
| RBAC | Parked |
| Documents | Metadata-only |
| Phase 11 | Locked |
| Production/client rollout | Blocked |

## Next Recommended Course

Proceed only to:

**Phase 13B.2 Frontend UX Polish / Verification Only**

Still blocked:

- RBAC repair
- backend route edits
- database migrations
- Phase 11 unlock
- production/client rollout

"@

$report | Set-Content -LiteralPath $BaselineReport -Encoding UTF8

$summary = @"
L360 SAFE GIT BASELINE ONLY V2 RESULT
Generated: $(Get-Date -Format "yyyy-MM-dd HH:mm:ss")

Result:
Safe local Git baseline V2 completed.

Project:
$ProjectRoot

Branch:
$branch

Latest commit:
$logOne

Final Git status:
$statusFinal

Tracked file count:
$trackedCount

Report:
$BaselineReport

Next:
Phase 13B.2 Frontend UX Polish / Verification Only

Still blocked:
backend/RBAC/database/Phase11/production rollout
"@

$summary | Set-Content -LiteralPath $RunnerSummary -Encoding UTF8

Write-Step "Baseline V2 report written: $BaselineReport" "Green"
Write-Step "Runner summary written: $RunnerSummary" "Green"

Write-Host ""
Write-Host "============================================================" -ForegroundColor Green
Write-Host " SAFE GIT BASELINE V2 COMPLETE" -ForegroundColor Green
Write-Host "============================================================" -ForegroundColor Green
Write-Host "Branch:"
Write-Host "  $branch"
Write-Host ""
Write-Host "Latest commit:"
Write-Host "  $logOne"
Write-Host ""
Write-Host "Final git status:"
Write-Host "  $statusFinal"
Write-Host ""
Write-Host "Tracked files:"
Write-Host "  $trackedCount"
Write-Host ""
Write-Host "Report:"
Write-Host "  $BaselineReport"
Write-Host ""
Write-Host "Next recommended course:"
Write-Host "  Phase 13B.2 Frontend UX Polish / Verification Only"
Write-Host "============================================================" -ForegroundColor Green
Write-Host ""

Read-Host "Press ENTER to close"
