param(
    [switch]$RunOnly
)

$ErrorActionPreference = "Stop"

$ProjectRoot = "C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software"
$ControlRoot = "C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software_LEOS_CONTROL"
$PhaseRoot = Join-Path $ControlRoot "07_DISCOVERY\PHASE12.0G-ACTIVE-SQLITE-DATABASE-IDENTIFICATION"
$CreatorPath = Join-Path $ProjectRoot "PHASE12_0G_CREATE_ACTIVE_DB_IDENTIFICATION_PACK_V2_BASE64SAFE.ps1"

$Folders = @(
    "00_DOCUMENTATION",
    "01_PROTOCOLS",
    "02_PARAMETERS",
    "03_BLUEPRINTS",
    "04_CHECKLISTS",
    "05_PROMPTS",
    "06_SCRIPTS",
    "07_REPORTS",
    "08_EVIDENCE",
    "09_READONLY_SNAPSHOTS",
    "10_LIVE_MONITORING",
    "99_LOGS"
)

function New-SafeFolder {
    param([string]$Path)

    if (-not (Test-Path -LiteralPath $Path)) {
        New-Item -ItemType Directory -Path $Path -Force | Out-Null
    }
}

function Write-Utf8File {
    param(
        [string]$Path,
        [string[]]$Lines
    )

    $Parent = Split-Path -Parent $Path
    New-SafeFolder -Path $Parent
    Set-Content -LiteralPath $Path -Value $Lines -Encoding UTF8
}

function Get-SafeProjectFiles {
    param(
        [string]$Root,
        [string[]]$Patterns
    )

    $SkipNames = @(
        "node_modules",
        ".git",
        "dist",
        "build",
        "coverage",
        ".next",
        ".cache",
        "tmp",
        "temp"
    )

    if (-not (Test-Path -LiteralPath $Root)) {
        return
    }

    $Stack = New-Object "System.Collections.Generic.Stack[string]"
    $Stack.Push($Root)

    while ($Stack.Count -gt 0) {
        $Current = $Stack.Pop()

        try {
            foreach ($Dir in [System.IO.Directory]::EnumerateDirectories($Current)) {
                $Name = [System.IO.Path]::GetFileName($Dir)

                if ($SkipNames -notcontains $Name) {
                    $Stack.Push($Dir)
                }
            }

            foreach ($Pattern in $Patterns) {
                foreach ($File in [System.IO.Directory]::EnumerateFiles($Current, $Pattern)) {
                    Get-Item -LiteralPath $File -ErrorAction SilentlyContinue
                }
            }
        }
        catch {
            # Read-only discovery must continue past access-denied folders.
        }
    }
}

function Test-SqliteHeader {
    param([string]$Path)

    $Stream = $null

    try {
        $Stream = [System.IO.File]::Open(
            $Path,
            [System.IO.FileMode]::Open,
            [System.IO.FileAccess]::Read,
            [System.IO.FileShare]::ReadWrite
        )

        $Buffer = New-Object byte[] 16
        $Read = $Stream.Read($Buffer, 0, 16)

        if ($Read -lt 15) {
            return $false
        }

        $Header = [System.Text.Encoding]::ASCII.GetString($Buffer, 0, $Read)
        return $Header.StartsWith("SQLite format 3")
    }
    catch {
        return $false
    }
    finally {
        if ($null -ne $Stream) {
            $Stream.Close()
            $Stream.Dispose()
        }
    }
}

foreach ($Folder in $Folders) {
    New-SafeFolder -Path (Join-Path $PhaseRoot $Folder)
}

if (-not $RunOnly) {
    $RunnerPath = Join-Path $PhaseRoot "06_SCRIPTS\Run-PHASE12.0G-All-ReadOnly.ps1"
    $MonitorPath = Join-Path $PhaseRoot "06_SCRIPTS\Start-PHASE12.0G-Live-Monitor.ps1"
    $ReadmePath = Join-Path $PhaseRoot "00_DOCUMENTATION\README-PHASE12.0G.md"

    Write-Utf8File -Path $RunnerPath -Lines @(
        '$ErrorActionPreference = "Stop"',
        'powershell -NoExit -ExecutionPolicy Bypass -NoProfile -File "C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\PHASE12_0G_CREATE_ACTIVE_DB_IDENTIFICATION_PACK_V2_BASE64SAFE.ps1" -RunOnly'
    )

    Write-Utf8File -Path $MonitorPath -Lines @(
        'param([int]$IntervalSeconds = 10)',
        '$PhaseRoot = "C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software_LEOS_CONTROL\07_DISCOVERY\PHASE12.0G-ACTIVE-SQLITE-DATABASE-IDENTIFICATION"',
        'while ($true) {',
        '    Clear-Host',
        '    Write-Host "PHASE 12.0G LIVE MONITOR" -ForegroundColor Cyan',
        '    Write-Host ""',
        '    Get-ChildItem -LiteralPath (Join-Path $PhaseRoot "07_REPORTS") -File -ErrorAction SilentlyContinue | Sort-Object LastWriteTime -Descending | Select-Object -First 10 Name, LastWriteTime | Format-Table -AutoSize',
        '    Write-Host ""',
        '    Get-ChildItem -LiteralPath (Join-Path $PhaseRoot "08_EVIDENCE") -File -ErrorAction SilentlyContinue | Sort-Object LastWriteTime -Descending | Select-Object -First 10 Name, LastWriteTime | Format-Table -AutoSize',
        '    Start-Sleep -Seconds $IntervalSeconds',
        '}'
    )

    Write-Utf8File -Path $ReadmePath -Lines @(
        "# PHASE 12.0G - ACTIVE SQLITE DATABASE IDENTIFICATION",
        "",
        "Status: Pack created.",
        "",
        "Permission level: READ-ONLY DISCOVERY ONLY.",
        "",
        "This phase does not edit frontend, backend, API, database, routes, packages, migrations, or production logic.",
        "",
        "Run:",
        "",
        'powershell -NoExit -ExecutionPolicy Bypass -NoProfile -File "C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software_LEOS_CONTROL\07_DISCOVERY\PHASE12.0G-ACTIVE-SQLITE-DATABASE-IDENTIFICATION\06_SCRIPTS\Run-PHASE12.0G-All-ReadOnly.ps1"',
        "",
        "Expected:",
        "",
        "PHASE 12.0G ALL READ-ONLY COMPLETED SUCCESSFULLY"
    )

    Write-Host ""
    Write-Host "PHASE 12.0G ACTIVE DATABASE IDENTIFICATION PACK V2 CREATED SUCCESSFULLY" -ForegroundColor Green
    Write-Host ""
    Write-Host "Created runner:" -ForegroundColor Cyan
    Write-Host $RunnerPath
    Write-Host ""
    Write-Host "Next command:" -ForegroundColor Yellow
    Write-Host 'powershell -NoExit -ExecutionPolicy Bypass -NoProfile -File "C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software_LEOS_CONTROL\07_DISCOVERY\PHASE12.0G-ACTIVE-SQLITE-DATABASE-IDENTIFICATION\06_SCRIPTS\Run-PHASE12.0G-All-ReadOnly.ps1"'
    return
}

$Timestamp = Get-Date -Format "yyyyMMdd-HHmmss"

$EvidenceDir = Join-Path $PhaseRoot "08_EVIDENCE"
$ReportsDir = Join-Path $PhaseRoot "07_REPORTS"
$LogsDir = Join-Path $PhaseRoot "99_LOGS"

$CandidateCsv = Join-Path $EvidenceDir "PHASE12.0G-SQLITE-CANDIDATE-RANKING-$Timestamp.csv"
$BackendEvidenceCsv = Join-Path $EvidenceDir "PHASE12.0G-BACKEND-DB-REFERENCE-EVIDENCE-$Timestamp.csv"
$SummaryJson = Join-Path $EvidenceDir "PHASE12.0G-ACTIVE-DB-SUMMARY-$Timestamp.json"
$FinalReport = Join-Path $ReportsDir "PHASE12.0G-FINAL-ACTIVE-DB-CERTIFICATION-REPORT-$Timestamp.md"
$LogPath = Join-Path $LogsDir "PHASE12.0G-RUN-$Timestamp.log"

function Log-Line {
    param([string]$Message)

    $Line = "$(Get-Date -Format "yyyy-MM-dd HH:mm:ss") - $Message"
    Add-Content -LiteralPath $LogPath -Value $Line -Encoding UTF8
    Write-Host $Message
}

Log-Line "PHASE 12.0G READ-ONLY RUN STARTED"
Log-Line "Project root: $ProjectRoot"
Log-Line "Control root: $ControlRoot"
Log-Line "Phase root: $PhaseRoot"

$DbPatterns = @("*.db", "*.sqlite", "*.sqlite3", "*.db3")
$RawCandidates = @(Get-SafeProjectFiles -Root $ProjectRoot -Patterns $DbPatterns | Sort-Object FullName -Unique)

$CandidateRows = @()

foreach ($File in $RawCandidates) {
    $IsSqlite = Test-SqliteHeader -Path $File.FullName
    $Score = 0
    $Reasons = New-Object System.Collections.Generic.List[string]

    if ($IsSqlite) {
        $Score += 100
        $Reasons.Add("valid_sqlite_header")
    }
    else {
        $Score -= 50
        $Reasons.Add("sqlite_header_not_confirmed")
    }

    if ($File.FullName -match "\\backend\\") {
        $Score += 40
        $Reasons.Add("inside_backend")
    }

    if ($File.FullName -match "\\data\\|\\db\\|database|sqlite|litigation|case|matter") {
        $Score += 25
        $Reasons.Add("database_like_path_or_name")
    }

    if ($File.LastWriteTime -gt (Get-Date).AddDays(-30)) {
        $Score += 15
        $Reasons.Add("modified_within_30_days")
    }

    if ($File.Length -gt 1024) {
        $Score += 10
        $Reasons.Add("non_tiny_file")
    }

    if ($File.Length -eq 0) {
        $Score -= 100
        $Reasons.Add("zero_byte_file")
    }

    $CandidateRows += [PSCustomObject]@{
        Score = $Score
        IsSqliteHeaderConfirmed = $IsSqlite
        FileName = $File.Name
        FullName = $File.FullName
        LengthBytes = $File.Length
        LastWriteTime = $File.LastWriteTime
        Reasons = ($Reasons -join ";")
    }
}

$CandidateRows |
    Sort-Object @{Expression="Score";Descending=$true}, @{Expression="LastWriteTime";Descending=$true} |
    Export-Csv -LiteralPath $CandidateCsv -NoTypeInformation -Encoding UTF8

Log-Line "SQLite candidate ranking created: $CandidateCsv"

$BackendRoot = Join-Path $ProjectRoot "backend"
$BackendEvidence = @()

if (Test-Path -LiteralPath $BackendRoot) {
    $SourcePatterns = @("*.js", "*.cjs", "*.mjs", "*.ts", "*.json", "*.env")
    $SourceFiles = @(Get-SafeProjectFiles -Root $BackendRoot -Patterns $SourcePatterns)

    foreach ($SourceFile in $SourceFiles) {
        try {
            $Matches = Select-String -LiteralPath $SourceFile.FullName -Pattern "sqlite|\.db|database|knex|better-sqlite3|sequelize|typeorm|prisma" -AllMatches -ErrorAction SilentlyContinue

            foreach ($Match in $Matches) {
                $BackendEvidence += [PSCustomObject]@{
                    File = $SourceFile.FullName
                    LineNumber = $Match.LineNumber
                    Text = ($Match.Line.Trim())
                }
            }
        }
        catch {
            # Continue read-only scan.
        }
    }
}

$BackendEvidence |
    Export-Csv -LiteralPath $BackendEvidenceCsv -NoTypeInformation -Encoding UTF8

Log-Line "Backend DB reference evidence created: $BackendEvidenceCsv"

$SortedCandidates = @($CandidateRows | Sort-Object @{Expression="Score";Descending=$true}, @{Expression="LastWriteTime";Descending=$true})
$TopCandidate = $null

if ($SortedCandidates.Count -gt 0) {
    $TopCandidate = $SortedCandidates[0]
}

$CertificationStatus = "ACTIVE_DB_NOT_CERTIFIED"

if ($null -ne $TopCandidate -and $TopCandidate.IsSqliteHeaderConfirmed -eq $true -and $TopCandidate.Score -ge 100) {
    $CertificationStatus = "LIKELY_ACTIVE_DB_CANDIDATE_FOUND_SCHEMA_NOT_YET_CERTIFIED"
}

if ($null -eq $TopCandidate) {
    $CertificationStatus = "NO_SQLITE_CANDIDATES_FOUND"
}

$Summary = [PSCustomObject]@{
    Phase = "PHASE 12.0G - ACTIVE SQLITE DATABASE IDENTIFICATION"
    Timestamp = $Timestamp
    PermissionLevel = "READ_ONLY_DISCOVERY_ONLY"
    ProjectRoot = $ProjectRoot
    ControlRoot = $ControlRoot
    PhaseRoot = $PhaseRoot
    CandidateCount = $SortedCandidates.Count
    BackendEvidenceCount = $BackendEvidence.Count
    CertificationStatus = $CertificationStatus
    TopCandidate = $TopCandidate
    AppCodeChanged = $false
    DatabaseChanged = $false
    MigrationRun = $false
    MatterTypePatchApproved = $false
    Phase11Status = "LOCKED"
}

$Summary | ConvertTo-Json -Depth 6 | Set-Content -LiteralPath $SummaryJson -Encoding UTF8

$ReportLines = @(
    "# PHASE 12.0G FINAL ACTIVE DB CERTIFICATION REPORT",
    "",
    "Timestamp: $Timestamp",
    "",
    "## Permission Level",
    "",
    "READ-ONLY DISCOVERY ONLY",
    "",
    "## Safety Confirmation",
    "",
    "- App code changed: NO",
    "- Database changed: NO",
    "- Migration run: NO",
    "- Matter Type patch approved: NO",
    "- Phase 11 status: LOCKED",
    "",
    "## Result",
    "",
    "Certification status: $CertificationStatus",
    "",
    "## Candidate Count",
    "",
    "SQLite candidate count: $($SortedCandidates.Count)",
    "",
    "## Backend DB Reference Evidence Count",
    "",
    "Backend DB reference matches: $($BackendEvidence.Count)",
    "",
    "## Top Candidate"
)

if ($null -ne $TopCandidate) {
    $ReportLines += @(
        "",
        "Score: $($TopCandidate.Score)",
        "",
        "SQLite header confirmed: $($TopCandidate.IsSqliteHeaderConfirmed)",
        "",
        "File:",
        "",
        $TopCandidate.FullName,
        "",
        "Size bytes: $($TopCandidate.LengthBytes)",
        "",
        "Last modified: $($TopCandidate.LastWriteTime)",
        "",
        "Reasons: $($TopCandidate.Reasons)"
    )
}
else {
    $ReportLines += @(
        "",
        "No SQLite candidate was found."
    )
}

$ReportLines += @(
    "",
    "## Evidence Files",
    "",
    "Candidate ranking CSV:",
    "",
    $CandidateCsv,
    "",
    "Backend DB reference evidence CSV:",
    "",
    $BackendEvidenceCsv,
    "",
    "Summary JSON:",
    "",
    $SummaryJson,
    "",
    "## Important Interpretation",
    "",
    "This run ranks likely SQLite database candidates and checks file headers in read-only mode.",
    "",
    "If status is LIKELY_ACTIVE_DB_CANDIDATE_FOUND_SCHEMA_NOT_YET_CERTIFIED, do not migrate yet.",
    "",
    "The next step is schema certification or a controlled Phase 12.0H migration plan only after active DB confidence is sufficient.",
    "",
    "## Final Control Statement",
    "",
    "Do not add Matter Type yet.",
    "",
    "Do not edit frontend, backend, API, or database yet.",
    "",
    "Do not run migration.",
    "",
    "Do not proceed to Phase 11."
)

Set-Content -LiteralPath $FinalReport -Value $ReportLines -Encoding UTF8

Log-Line "Final report created: $FinalReport"
Log-Line "Summary JSON created: $SummaryJson"
Log-Line "PHASE 12.0G READ-ONLY RUN COMPLETED"

Write-Host ""
Write-Host "PHASE 12.0G ALL READ-ONLY COMPLETED SUCCESSFULLY" -ForegroundColor Green
Write-Host ""
Write-Host "Final report:" -ForegroundColor Cyan
Write-Host $FinalReport
Write-Host ""
Write-Host "Summary JSON:" -ForegroundColor Cyan
Write-Host $SummaryJson
