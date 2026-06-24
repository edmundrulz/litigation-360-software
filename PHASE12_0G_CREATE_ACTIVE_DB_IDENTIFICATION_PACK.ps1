# ============================================================
# PHASE 12.0G - CREATE ACTIVE SQLITE DATABASE IDENTIFICATION PACK
# Litigation 360 LEOS
#
# Purpose:
#   Create a read-only control pack to identify the active operational
#   SQLite database among candidates, inspect schema safely where possible,
#   and decide the next safe phase.
#
# Safety:
#   - Does NOT modify frontend source code
#   - Does NOT modify backend source code
#   - Does NOT modify database files
#   - Creates documentation, evidence, reports, scripts, and monitoring only
# ============================================================

$ErrorActionPreference = "Stop"

$ProjectRoot = "C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software"
$ControlRoot = "C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software_LEOS_CONTROL"
$PhaseRoot = Join-Path $ControlRoot "07_DISCOVERY\PHASE12.0G-ACTIVE-SQLITE-DATABASE-IDENTIFICATION"

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

Write-Host ""
Write-Host "============================================================" -ForegroundColor Cyan
Write-Host "PHASE 12.0G - CREATE ACTIVE SQLITE DATABASE IDENTIFICATION PACK" -ForegroundColor Cyan
Write-Host "============================================================" -ForegroundColor Cyan
Write-Host ""

if (-not (Test-Path -LiteralPath $ProjectRoot)) {
    Write-Host "ERROR: Project root not found." -ForegroundColor Red
    Write-Host $ProjectRoot
    exit 1
}

foreach ($folder in $Folders) {
    New-Item -ItemType Directory -Force -Path (Join-Path $PhaseRoot $folder) | Out-Null
}

$Timestamp = Get-Date -Format "yyyyMMdd-HHmmss"

function Write-TextFile {
    param(
        [string]$Path,
        [string[]]$Lines
    )
    $folder = Split-Path $Path -Parent
    if ($folder) {
        New-Item -ItemType Directory -Force -Path $folder | Out-Null
    }
    Set-Content -LiteralPath $Path -Value ($Lines -join [Environment]::NewLine) -Encoding UTF8
    Write-Host ("Created: {0}" -f $Path) -ForegroundColor Green
}

# ------------------------------------------------------------
# DOCUMENTATION
# ------------------------------------------------------------

Write-TextFile -Path (Join-Path $PhaseRoot "00_DOCUMENTATION\PHASE12.0G-EXECUTIVE-DECISION.md") -Lines @(
    "# PHASE 12.0G EXECUTIVE DECISION",
    "",
    "## Phase Name",
    "",
    "PHASE 12.0G - ACTIVE SQLITE DATABASE IDENTIFICATION AND READ-ONLY SCHEMA ACCESS",
    "",
    "## Reason This Phase Exists",
    "",
    "Phase 12.0E completed as a discovery pass but did not approve a Matter Type patch.",
    "Phase 12.0F completed backend/database planning.",
    "The current blocker is that the active operational SQLite database has not yet been certified.",
    "",
    "Phase 12.0E found many SQLite candidates and reported that sqlite3 command-line access was not available.",
    "Therefore, the next safe step is not to edit the UI, backend, or database.",
    "The next safe step is to identify which SQLite database is actually used by the running backend and inspect its schema in read-only mode where possible.",
    "",
    "## Decision",
    "",
    "Proceed with read-only active database identification.",
    "",
    "## Explicit Non-Approval",
    "",
    "This phase does not approve:",
    "",
    "- Adding Matter Type to Cases.jsx",
    "- Editing frontend api.js",
    "- Editing backend/src/routes/cases.js",
    "- Running a database migration",
    "- Renaming cases to matters",
    "- Phase 11 development",
    "",
    "## Success Criteria",
    "",
    "- SQLite candidates are listed.",
    "- Candidate ranking is created.",
    "- Backend source references to database files are inspected.",
    "- Active database candidate is identified or marked unresolved.",
    "- Schema is read in read-only mode if Node SQLite libraries are available.",
    "- A final certification report is produced.",
    "- No application source or database file is modified."
)

Write-TextFile -Path (Join-Path $PhaseRoot "01_PROTOCOLS\PHASE12.0G-ACTIVE-DATABASE-PROTOCOL.md") -Lines @(
    "# PHASE 12.0G ACTIVE DATABASE IDENTIFICATION PROTOCOL",
    "",
    "## Governing Principle",
    "",
    "Do not modify the application until the active database is known.",
    "",
    "## Read-Only Rules",
    "",
    "- All scans must be read-only.",
    "- Database files may be opened only in read-only mode.",
    "- No SQL write statement is allowed.",
    "- No ALTER TABLE, INSERT, UPDATE, DELETE, DROP, CREATE, VACUUM, or migration may be executed.",
    "- App source files may be hashed and searched but not changed.",
    "",
    "## Candidate Ranking Rules",
    "",
    "Candidates should be ranked using:",
    "",
    "- Whether the file has a valid SQLite header.",
    "- Whether backend source references the database filename/path.",
    "- Whether the database lives under backend, data, db, or database folders.",
    "- Whether the database contains operational-looking tables.",
    "- Whether it appears to be a backup, snapshot, copy, or archived file.",
    "",
    "## Certification Outcomes",
    "",
    "Possible outcomes:",
    "",
    "1. ACTIVE_DATABASE_IDENTIFIED_SCHEMA_READ",
    "2. ACTIVE_DATABASE_IDENTIFIED_SCHEMA_NOT_READ",
    "3. MULTIPLE_POSSIBLE_ACTIVE_DATABASES",
    "4. ACTIVE_DATABASE_NOT_IDENTIFIED",
    "",
    "## Next Phase Rule",
    "",
    "Only after this phase identifies the active database should the project proceed to a controlled migration plan."
)

Write-TextFile -Path (Join-Path $PhaseRoot "02_PARAMETERS\PHASE12.0G-DATABASE-IDENTIFICATION-PARAMETERS.md") -Lines @(
    "# PHASE 12.0G DATABASE IDENTIFICATION PARAMETERS",
    "",
    "## Project Root",
    "",
    $ProjectRoot,
    "",
    "## Control Root",
    "",
    $ControlRoot,
    "",
    "## Phase Root",
    "",
    $PhaseRoot,
    "",
    "## SQLite Extensions",
    "",
    "- .db",
    "- .sqlite",
    "- .sqlite3",
    "",
    "## Heavy Folders Skipped",
    "",
    "- node_modules",
    "- .git",
    "- dist",
    "- build",
    "- coverage",
    "- .vite",
    "- .next",
    "- .turbo",
    "- .cache",
    "- cache",
    "- tmp",
    "- temp",
    "",
    "## Positive Ranking Terms",
    "",
    "- backend",
    "- data",
    "- db",
    "- database",
    "- litigation",
    "- cases",
    "- clients",
    "- users",
    "",
    "## Negative Ranking Terms",
    "",
    "- backup",
    "- snapshot",
    "- old",
    "- copy",
    "- before",
    "- after",
    "- rollback",
    "- archive",
    "- temp",
    "- test"
)

Write-TextFile -Path (Join-Path $PhaseRoot "03_BLUEPRINTS\PHASE12.0G-ACTIVE-DATABASE-BLUEPRINT.md") -Lines @(
    "# PHASE 12.0G ACTIVE DATABASE BLUEPRINT",
    "",
    "## Objective",
    "",
    "Identify the database that the backend most likely uses in real operation.",
    "",
    "## Discovery Flow",
    "",
    "1. List SQLite candidates.",
    "2. Validate file headers.",
    "3. Search backend source for database references.",
    "4. Rank each candidate.",
    "5. Attempt read-only schema extraction using Node SQLite libraries if available.",
    "6. Add schema-based ranking if possible.",
    "7. Certify outcome.",
    "",
    "## Evidence Outputs",
    "",
    "- SQLite candidate ranking CSV",
    "- Backend source database reference CSV",
    "- Schema read JSON",
    "- Schema read text summary",
    "- Active database summary JSON",
    "- Final certification report",
    "",
    "## No-Patch Boundary",
    "",
    "This phase stops before migration or patching."
)

Write-TextFile -Path (Join-Path $PhaseRoot "04_CHECKLISTS\PHASE12.0G-CHECKS-AND-BALANCES.md") -Lines @(
    "# PHASE 12.0G CHECKS AND BALANCES",
    "",
    "## Before Running",
    "",
    "- [ ] Phase 12.0E final certification exists.",
    "- [ ] Phase 12.0F final planning certification exists.",
    "- [ ] Current task is database identification only.",
    "- [ ] No frontend patch is being attempted.",
    "",
    "## During Running",
    "",
    "- [ ] Candidate CSV created.",
    "- [ ] Backend reference CSV created.",
    "- [ ] Schema evidence created or schema access limitation documented.",
    "- [ ] JSON summary created.",
    "",
    "## After Running",
    "",
    "- [ ] Final certification report exists.",
    "- [ ] Active database status is clear.",
    "- [ ] Next phase is stated.",
    "- [ ] No app/database modification occurred."
)

Write-TextFile -Path (Join-Path $PhaseRoot "05_PROMPTS\PHASE12.0G-NEXT-THREAD-PROMPT.md") -Lines @(
    "# PHASE 12.0G NEXT THREAD PROMPT",
    "",
    "Use this prompt in a new thread if needed:",
    "",
    "We are working on Litigation 360 LEOS.",
    "Phase 12.0E completed as Discovery Pass / Patch Not Approved.",
    "Phase 12.0F completed as Backend/Database Planning.",
    "We are now at Phase 12.0G: Active SQLite Database Identification.",
    "Do not patch frontend, backend, or database yet.",
    "Use the Phase 12.0G reports and evidence to determine the active operational SQLite database.",
    "Only after active DB certification should we plan a controlled Matter Type database migration."
)

# ------------------------------------------------------------
# SCRIPT: Run Phase 12.0G Active DB Read-Only
# ------------------------------------------------------------

$RunScriptPath = Join-Path $PhaseRoot "06_SCRIPTS\Run-PHASE12.0G-ActiveDb-ReadOnly.ps1"

$RunScriptContent = @'
# ============================================================
# PHASE 12.0G - ACTIVE SQLITE DATABASE IDENTIFICATION
# Version: V1 Read-Only
#
# Safety:
#   - No frontend modification
#   - No backend modification
#   - No database modification
#   - Opens SQLite only in read-only mode if possible
# ============================================================

$ErrorActionPreference = "Stop"

$ProjectRoot = "C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software"
$PhaseRoot = "C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software_LEOS_CONTROL\07_DISCOVERY\PHASE12.0G-ACTIVE-SQLITE-DATABASE-IDENTIFICATION"

$ReportsRoot = Join-Path $PhaseRoot "07_REPORTS"
$EvidenceRoot = Join-Path $PhaseRoot "08_EVIDENCE"
$SnapshotsRoot = Join-Path $PhaseRoot "09_READONLY_SNAPSHOTS"
$LogsRoot = Join-Path $PhaseRoot "99_LOGS"

$Timestamp = Get-Date -Format "yyyyMMdd-HHmmss"

$CandidateCsv = Join-Path $EvidenceRoot "PHASE12.0G-SQLITE-CANDIDATE-RANKING-$Timestamp.csv"
$BackendReferenceCsv = Join-Path $EvidenceRoot "PHASE12.0G-BACKEND-DATABASE-REFERENCES-$Timestamp.csv"
$CandidateJson = Join-Path $EvidenceRoot "PHASE12.0G-SQLITE-CANDIDATES-$Timestamp.json"
$NodeSchemaScript = Join-Path $EvidenceRoot "PHASE12.0G-READONLY-SCHEMA-INSPECTOR-$Timestamp.js"
$SchemaJson = Join-Path $EvidenceRoot "PHASE12.0G-SCHEMA-READONLY-RESULT-$Timestamp.json"
$SchemaText = Join-Path $EvidenceRoot "PHASE12.0G-SCHEMA-READONLY-SUMMARY-$Timestamp.txt"
$SummaryJson = Join-Path $EvidenceRoot "PHASE12.0G-ACTIVE-DB-SUMMARY-$Timestamp.json"
$ReportPath = Join-Path $ReportsRoot "PHASE12.0G-ACTIVE-DATABASE-IDENTIFICATION-REPORT-$Timestamp.md"
$LogPath = Join-Path $LogsRoot "PHASE12.0G-ACTIVE-DB-READONLY-$Timestamp.log"

foreach ($dir in @($ReportsRoot, $EvidenceRoot, $SnapshotsRoot, $LogsRoot)) {
    New-Item -ItemType Directory -Force -Path $dir | Out-Null
}

function Add-Log {
    param([string]$Message)

    $line = "[{0}] {1}" -f (Get-Date -Format "yyyy-MM-dd HH:mm:ss"), $Message
    Add-Content -LiteralPath $LogPath -Value $line -Encoding UTF8
    Write-Host $Message
}

function Get-RelativePathSafe {
    param(
        [string]$BasePath,
        [string]$FullPath
    )

    try {
        $base = [System.IO.Path]::GetFullPath($BasePath).TrimEnd('\') + '\'
        $full = [System.IO.Path]::GetFullPath($FullPath)

        if ($full.StartsWith($base, [System.StringComparison]::OrdinalIgnoreCase)) {
            return $full.Substring($base.Length)
        }

        return $FullPath
    } catch {
        return $FullPath
    }
}

function Test-SqliteHeader {
    param([string]$Path)

    try {
        if (-not (Test-Path -LiteralPath $Path)) {
            return $false
        }

        $bytes = [System.IO.File]::ReadAllBytes($Path)
        if ($bytes.Length -lt 16) {
            return $false
        }

        $header = [System.Text.Encoding]::ASCII.GetString($bytes, 0, 16)
        return ($header -eq "SQLite format 3`0")
    } catch {
        return $false
    }
}

function Get-SafeFiles {
    param(
        [string]$RootPath,
        [string[]]$Extensions
    )

    $skipNames = @(
        "node_modules",
        ".git",
        "dist",
        "build",
        "coverage",
        ".vite",
        ".next",
        ".turbo",
        ".cache",
        "cache",
        "tmp",
        "temp"
    )

    $results = New-Object System.Collections.Generic.List[object]

    if (-not (Test-Path -LiteralPath $RootPath)) {
        return $results
    }

    $stack = New-Object System.Collections.Generic.Stack[System.IO.DirectoryInfo]
    $stack.Push((Get-Item -LiteralPath $RootPath))

    while ($stack.Count -gt 0) {
        $dir = $stack.Pop()

        try {
            foreach ($file in $dir.EnumerateFiles()) {
                if ($Extensions -contains $file.Extension.ToLowerInvariant()) {
                    $results.Add($file)
                }
            }

            foreach ($sub in $dir.EnumerateDirectories()) {
                if ($skipNames -contains $sub.Name) {
                    continue
                }

                $stack.Push($sub)
            }
        } catch {
            continue
        }
    }

    return $results
}

function Get-FileTextSafe {
    param([string]$Path)

    try {
        if (-not (Test-Path -LiteralPath $Path)) {
            return ""
        }
        return Get-Content -LiteralPath $Path -Raw -ErrorAction Stop
    } catch {
        return ""
    }
}

function Test-ContainsAny {
    param(
        [string]$Text,
        [string[]]$Terms
    )

    foreach ($term in $Terms) {
        if ($Text -match [regex]::Escape($term)) {
            return $true
        }
    }

    return $false
}

Add-Log "Starting Phase 12.0G active SQLite database identification."
Add-Log ("ProjectRoot: {0}" -f $ProjectRoot)
Add-Log ("PhaseRoot: {0}" -f $PhaseRoot)

if (-not (Test-Path -LiteralPath $ProjectRoot)) {
    throw ("Project root not found: {0}" -f $ProjectRoot)
}

Add-Log "Collecting SQLite candidates."

$dbFiles = Get-SafeFiles -RootPath $ProjectRoot -Extensions @(".db", ".sqlite", ".sqlite3")

Add-Log ("SQLite candidates found: {0}" -f $dbFiles.Count)

Add-Log "Collecting backend/source files for database reference scan."

$sourceRoots = @(
    (Join-Path $ProjectRoot "backend"),
    (Join-Path $ProjectRoot "frontend\src")
)

$sourceFiles = New-Object System.Collections.Generic.List[object]

foreach ($root in $sourceRoots) {
    if (Test-Path -LiteralPath $root) {
        $files = Get-SafeFiles -RootPath $root -Extensions @(".js", ".jsx", ".ts", ".tsx", ".json", ".env", ".mjs", ".cjs")
        foreach ($f in $files) {
            $sourceFiles.Add($f)
        }
    }
}

$ReferenceEvidence = New-Object System.Collections.Generic.List[object]
$CandidateEvidence = New-Object System.Collections.Generic.List[object]

$allSourceTextByPath = @{}

foreach ($src in $sourceFiles) {
    $allSourceTextByPath[$src.FullName] = Get-FileTextSafe -Path $src.FullName
}

$generalDbTerms = @(
    "sqlite",
    "sqlite3",
    "better-sqlite3",
    ".db",
    ".sqlite",
    ".sqlite3",
    "database",
    "knex",
    "sequelize",
    "dbPath",
    "DB_PATH",
    "DATABASE",
    "DATABASE_URL"
)

foreach ($src in $sourceFiles) {
    $text = [string]$allSourceTextByPath[$src.FullName]
    foreach ($term in $generalDbTerms) {
        if ($text -match [regex]::Escape($term)) {
            $ReferenceEvidence.Add([pscustomobject]@{
                SourceFile = Get-RelativePathSafe -BasePath $ProjectRoot -FullPath $src.FullName
                ReferenceType = "GENERAL_DB_TERM"
                Reference = $term
            })
        }
    }
}

foreach ($db in $dbFiles) {
    $relative = Get-RelativePathSafe -BasePath $ProjectRoot -FullPath $db.FullName
    $validHeader = Test-SqliteHeader -Path $db.FullName

    $score = 0
    $reasons = New-Object System.Collections.Generic.List[string]

    if ($validHeader) {
        $score += 40
        $reasons.Add("valid_sqlite_header")
    } else {
        $score -= 60
        $reasons.Add("no_valid_sqlite_header")
    }

    if ($db.Length -gt 0) {
        $score += 10
        $reasons.Add("non_empty_file")
    } else {
        $score -= 40
        $reasons.Add("empty_file")
    }

    $lowerPath = $db.FullName.ToLowerInvariant()
    $lowerName = $db.Name.ToLowerInvariant()

    if ($lowerPath -match "\\backend\\") {
        $score += 40
        $reasons.Add("under_backend")
    }

    if ($lowerPath -match "\\data\\" -or $lowerPath -match "\\db\\" -or $lowerPath -match "\\database\\") {
        $score += 30
        $reasons.Add("under_data_db_database_folder")
    }

    if ($lowerName -match "litigation" -or $lowerName -match "case" -or $lowerName -match "client" -or $lowerName -match "app" -or $lowerName -match "database") {
        $score += 20
        $reasons.Add("operational_name_signal")
    }

    if ($lowerPath -match "backup" -or $lowerPath -match "snapshot" -or $lowerPath -match "old" -or $lowerPath -match "copy" -or $lowerPath -match "before" -or $lowerPath -match "after" -or $lowerPath -match "rollback" -or $lowerPath -match "archive" -or $lowerPath -match "temp" -or $lowerPath -match "test") {
        $score -= 80
        $reasons.Add("backup_snapshot_or_temp_signal")
    }

    $directReferenceCount = 0

    foreach ($src in $sourceFiles) {
        $text = [string]$allSourceTextByPath[$src.FullName]
        $nameHit = $false
        $relativeHit = $false
        $fullHit = $false

        if ($text -match [regex]::Escape($db.Name)) {
            $nameHit = $true
        }

        if ($text -match [regex]::Escape($relative)) {
            $relativeHit = $true
        }

        if ($text -match [regex]::Escape($db.FullName)) {
            $fullHit = $true
        }

        if ($nameHit -or $relativeHit -or $fullHit) {
            $directReferenceCount += 1
            $ReferenceEvidence.Add([pscustomobject]@{
                SourceFile = Get-RelativePathSafe -BasePath $ProjectRoot -FullPath $src.FullName
                ReferenceType = "DIRECT_DB_FILE_REFERENCE"
                Reference = $relative
            })
        }
    }

    if ($directReferenceCount -gt 0) {
        $score += (100 + ($directReferenceCount * 10))
        $reasons.Add(("direct_source_reference_count_{0}" -f $directReferenceCount))
    }

    $CandidateEvidence.Add([pscustomobject]@{
        FileName = $db.Name
        RelativePath = $relative
        FullPath = $db.FullName
        SizeBytes = $db.Length
        LastWriteTime = $db.LastWriteTime.ToString("yyyy-MM-dd HH:mm:ss")
        ValidSQLiteHeader = $validHeader
        DirectReferenceCount = $directReferenceCount
        PreliminaryScore = $score
        Reasons = ($reasons -join ";")
        SHA256 = (Get-FileHash -Algorithm SHA256 -LiteralPath $db.FullName).Hash
    })
}

$ReferenceEvidence | Export-Csv -NoTypeInformation -Encoding UTF8 -LiteralPath $BackendReferenceCsv
$CandidateEvidence | Sort-Object PreliminaryScore -Descending | Export-Csv -NoTypeInformation -Encoding UTF8 -LiteralPath $CandidateCsv
$CandidateEvidence | ConvertTo-Json -Depth 6 | Set-Content -LiteralPath $CandidateJson -Encoding UTF8

Add-Log ("Candidate ranking CSV created: {0}" -f $CandidateCsv)
Add-Log ("Backend reference CSV created: {0}" -f $BackendReferenceCsv)

$NodeAvailable = $false
try {
    $nodeCmd = Get-Command node -ErrorAction SilentlyContinue
    if ($nodeCmd) {
        $NodeAvailable = $true
    }
} catch {
    $NodeAvailable = $false
}

$NodeScript = @'
const fs = require("fs");
const path = require("path");

const projectRoot = process.argv[2];
const candidateJsonPath = process.argv[3];
const outputJsonPath = process.argv[4];
const outputTextPath = process.argv[5];

function writeResult(obj) {
  fs.writeFileSync(outputJsonPath, JSON.stringify(obj, null, 2), "utf8");
  const lines = [];
  lines.push("# PHASE 12.0G READ-ONLY SQLITE SCHEMA SUMMARY");
  lines.push("");
  lines.push(`Generated: ${new Date().toISOString()}`);
  lines.push("");
  lines.push(`SchemaStatus: ${obj.schemaStatus}`);
  lines.push(`Engine: ${obj.engine || ""}`);
  lines.push("");
  if (obj.databases) {
    for (const db of obj.databases) {
      lines.push("============================================================");
      lines.push(`DATABASE: ${db.path}`);
      lines.push(`Status: ${db.status}`);
      lines.push(`Tables: ${(db.tables || []).join(", ")}`);
      lines.push("");
      if (db.tableInfo) {
        for (const [table, columns] of Object.entries(db.tableInfo)) {
          lines.push(`TABLE: ${table}`);
          for (const col of columns) {
            lines.push(`- ${col.name} | ${col.type} | notnull=${col.notnull} | pk=${col.pk}`);
          }
          lines.push("");
        }
      }
      if (db.error) {
        lines.push(`Error: ${db.error}`);
        lines.push("");
      }
    }
  }
  fs.writeFileSync(outputTextPath, lines.join("\n"), "utf8");
}

function tryResolveRequire(moduleName) {
  const searchPaths = [
    path.join(projectRoot, "backend"),
    path.join(projectRoot, "frontend"),
    projectRoot
  ];

  try {
    return require(require.resolve(moduleName, { paths: searchPaths }));
  } catch (err) {
    return null;
  }
}

const candidates = JSON.parse(fs.readFileSync(candidateJsonPath, "utf8"));

const betterSqlite3 = tryResolveRequire("better-sqlite3");
const sqlite3 = tryResolveRequire("sqlite3");

const topCandidates = candidates
  .filter(c => c.ValidSQLiteHeader === true || c.ValidSQLiteHeader === "True" || c.ValidSQLiteHeader === "true")
  .sort((a, b) => Number(b.PreliminaryScore || 0) - Number(a.PreliminaryScore || 0))
  .slice(0, 10);

if (topCandidates.length === 0) {
  writeResult({
    schemaStatus: "NO_VALID_SQLITE_HEADER_CANDIDATES",
    engine: "",
    databases: []
  });
  process.exit(0);
}

if (betterSqlite3) {
  const databases = [];
  for (const c of topCandidates) {
    const entry = {
      path: c.FullPath,
      preliminaryScore: c.PreliminaryScore,
      status: "NOT_READ",
      tables: [],
      tableInfo: {}
    };

    try {
      const db = new betterSqlite3(c.FullPath, { readonly: true, fileMustExist: true });
      const rows = db.prepare("SELECT name, type, sql FROM sqlite_master WHERE type IN ('table','view','index') ORDER BY type, name").all();
      const tables = rows.filter(r => r.type === "table").map(r => r.name);
      entry.tables = tables;
      entry.status = "READ_OK";

      for (const table of tables) {
        try {
          const safeTable = String(table).replace(/"/g, '""');
          entry.tableInfo[table] = db.prepare(`PRAGMA table_info("${safeTable}")`).all();
        } catch (err) {
          entry.tableInfo[table] = [{ name: "TABLE_INFO_ERROR", type: err.message, notnull: 0, pk: 0 }];
        }
      }

      db.close();
    } catch (err) {
      entry.status = "READ_ERROR";
      entry.error = err.message;
    }

    databases.push(entry);
  }

  writeResult({
    schemaStatus: "SCHEMA_READ_ATTEMPTED",
    engine: "better-sqlite3",
    databases
  });
  process.exit(0);
}

if (sqlite3) {
  const sqlite = sqlite3.verbose();
  const databases = [];

  function all(db, sql) {
    return new Promise((resolve, reject) => {
      db.all(sql, [], (err, rows) => {
        if (err) reject(err);
        else resolve(rows);
      });
    });
  }

  function close(db) {
    return new Promise(resolve => db.close(() => resolve()));
  }

  (async () => {
    for (const c of topCandidates) {
      const entry = {
        path: c.FullPath,
        preliminaryScore: c.PreliminaryScore,
        status: "NOT_READ",
        tables: [],
        tableInfo: {}
      };

      try {
        const db = new sqlite.Database(c.FullPath, sqlite3.OPEN_READONLY);
        const rows = await all(db, "SELECT name, type, sql FROM sqlite_master WHERE type IN ('table','view','index') ORDER BY type, name");
        const tables = rows.filter(r => r.type === "table").map(r => r.name);
        entry.tables = tables;
        entry.status = "READ_OK";

        for (const table of tables) {
          try {
            const safeTable = String(table).replace(/"/g, '""');
            entry.tableInfo[table] = await all(db, `PRAGMA table_info("${safeTable}")`);
          } catch (err) {
            entry.tableInfo[table] = [{ name: "TABLE_INFO_ERROR", type: err.message, notnull: 0, pk: 0 }];
          }
        }

        await close(db);
      } catch (err) {
        entry.status = "READ_ERROR";
        entry.error = err.message;
      }

      databases.push(entry);
    }

    writeResult({
      schemaStatus: "SCHEMA_READ_ATTEMPTED",
      engine: "sqlite3",
      databases
    });
  })().catch(err => {
    writeResult({
      schemaStatus: "NODE_SQLITE_SCHEMA_EXCEPTION",
      engine: "sqlite3",
      error: err.message,
      databases
    });
    process.exit(0);
  });

  return;
}

writeResult({
  schemaStatus: "NODE_SQLITE_LIBRARY_NOT_AVAILABLE",
  engine: "",
  message: "Node is available, but neither better-sqlite3 nor sqlite3 could be resolved from the project backend/frontend/root.",
  databases: topCandidates.map(c => ({
    path: c.FullPath,
    preliminaryScore: c.PreliminaryScore,
    status: "NOT_READ_LIBRARY_UNAVAILABLE",
    tables: [],
    tableInfo: {}
  }))
});
'@

Set-Content -LiteralPath $NodeSchemaScript -Value $NodeScript -Encoding UTF8

$SchemaStatus = "NOT_ATTEMPTED"
$SchemaEngine = ""
$SchemaReadOkCount = 0
$SchemaHasCasesTable = $false
$SchemaHasClientsTable = $false
$SchemaHasMatterTypeColumn = $false
$SchemaTopDbPath = ""
$SchemaTopDbTables = ""

if ($NodeAvailable) {
    Add-Log "Node detected. Attempting read-only SQLite schema inspection through project dependencies."
    & node $NodeSchemaScript $ProjectRoot $CandidateJson $SchemaJson $SchemaText
    $nodeExit = $LASTEXITCODE

    if ($nodeExit -ne 0) {
        $SchemaStatus = "NODE_SCHEMA_SCRIPT_EXITED_NONZERO"
        Set-Content -LiteralPath $SchemaJson -Value "{ `"schemaStatus`": `"NODE_SCHEMA_SCRIPT_EXITED_NONZERO`" }" -Encoding UTF8
        Set-Content -LiteralPath $SchemaText -Value "Node schema script exited with non-zero code." -Encoding UTF8
    } else {
        try {
            $schemaObj = Get-Content -LiteralPath $SchemaJson -Raw | ConvertFrom-Json
            $SchemaStatus = [string]$schemaObj.schemaStatus
            $SchemaEngine = [string]$schemaObj.engine

            foreach ($db in $schemaObj.databases) {
                if ([string]$db.status -eq "READ_OK") {
                    $SchemaReadOkCount += 1

                    $tables = @()
                    foreach ($t in $db.tables) {
                        $tables += [string]$t
                    }

                    if (-not $SchemaTopDbPath) {
                        $SchemaTopDbPath = [string]$db.path
                        $SchemaTopDbTables = ($tables -join ", ")
                    }

                    foreach ($tableName in $tables) {
                        $lowerTable = $tableName.ToLowerInvariant()
                        if ($lowerTable -eq "cases" -or $lowerTable -eq "case" -or $lowerTable -eq "matters" -or $lowerTable -eq "matter") {
                            $SchemaHasCasesTable = $true
                        }
                        if ($lowerTable -eq "clients" -or $lowerTable -eq "client") {
                            $SchemaHasClientsTable = $true
                        }
                    }

                    if ($db.tableInfo) {
                        $jsonText = ($db.tableInfo | ConvertTo-Json -Depth 10)
                        if ($jsonText -match "matter_type" -or $jsonText -match "matterType" -or $jsonText -match "case_type" -or $jsonText -match "caseType") {
                            $SchemaHasMatterTypeColumn = $true
                        }
                    }
                }
            }
        } catch {
            $SchemaStatus = "SCHEMA_RESULT_PARSE_ERROR"
            $SchemaEngine = ""
        }
    }
} else {
    $SchemaStatus = "NODE_NOT_AVAILABLE"
    Set-Content -LiteralPath $SchemaJson -Value "{ `"schemaStatus`": `"NODE_NOT_AVAILABLE`" }" -Encoding UTF8
    Set-Content -LiteralPath $SchemaText -Value "Node command is not available. Schema was not read." -Encoding UTF8
}

Add-Log ("Schema status: {0}" -f $SchemaStatus)
Add-Log ("Schema engine: {0}" -f $SchemaEngine)
Add-Log ("Schema read OK count: {0}" -f $SchemaReadOkCount)

$Ranked = $CandidateEvidence | Sort-Object PreliminaryScore -Descending
$TopCandidate = $Ranked | Select-Object -First 1
$SecondCandidate = $Ranked | Select-Object -Skip 1 -First 1

$TopScore = 0
$SecondScore = 0
$ScoreMargin = 0
$TopCandidatePath = ""
$TopCandidateRelativePath = ""

if ($TopCandidate) {
    $TopScore = [int]$TopCandidate.PreliminaryScore
    $TopCandidatePath = [string]$TopCandidate.FullPath
    $TopCandidateRelativePath = [string]$TopCandidate.RelativePath
}

if ($SecondCandidate) {
    $SecondScore = [int]$SecondCandidate.PreliminaryScore
}

$ScoreMargin = $TopScore - $SecondScore

$ActiveDbStatus = "ACTIVE_DATABASE_NOT_IDENTIFIED"
$Confidence = "LOW"
$NextRecommendation = "DO_NOT_PATCH_PLAN_MANUAL_REVIEW"

if ($SchemaReadOkCount -gt 0 -and $SchemaHasCasesTable -and $SchemaHasClientsTable) {
    $ActiveDbStatus = "ACTIVE_DATABASE_IDENTIFIED_SCHEMA_READ"
    $Confidence = "HIGH"
    $NextRecommendation = "PROCEED_TO_PHASE12.0H_CONTROLLED_MATTER_TYPE_MIGRATION_PLAN"
} elseif ($TopScore -ge 150 -and $ScoreMargin -ge 30) {
    $ActiveDbStatus = "ACTIVE_DATABASE_IDENTIFIED_SCHEMA_NOT_READ"
    $Confidence = "MEDIUM"
    $NextRecommendation = "PROCEED_TO_PHASE12.0H_ONLY_AFTER_MANUAL_SCHEMA_CONFIRMATION"
} elseif ($TopScore -ge 100) {
    $ActiveDbStatus = "MULTIPLE_POSSIBLE_ACTIVE_DATABASES"
    $Confidence = "LOW_TO_MEDIUM"
    $NextRecommendation = "REVIEW_TOP_CANDIDATES_BEFORE_MIGRATION_PLANNING"
} else {
    $ActiveDbStatus = "ACTIVE_DATABASE_NOT_IDENTIFIED"
    $Confidence = "LOW"
    $NextRecommendation = "DO_NOT_PATCH_IDENTIFY_DATABASE_MANUALLY"
}

$Summary = [pscustomobject]@{
    GeneratedAt = (Get-Date -Format "yyyy-MM-dd HH:mm:ss")
    Phase = "PHASE 12.0G"
    Mode = "READ_ONLY_ACTIVE_DB_IDENTIFICATION"
    ProjectRoot = $ProjectRoot
    PhaseRoot = $PhaseRoot
    CandidateCsv = $CandidateCsv
    BackendReferenceCsv = $BackendReferenceCsv
    SchemaJson = $SchemaJson
    SchemaText = $SchemaText
    CandidateCount = $dbFiles.Count
    SourceFileCount = $sourceFiles.Count
    NodeAvailable = $NodeAvailable
    SchemaStatus = $SchemaStatus
    SchemaEngine = $SchemaEngine
    SchemaReadOkCount = $SchemaReadOkCount
    SchemaHasCasesTable = $SchemaHasCasesTable
    SchemaHasClientsTable = $SchemaHasClientsTable
    SchemaHasMatterTypeColumn = $SchemaHasMatterTypeColumn
    TopCandidatePath = $TopCandidatePath
    TopCandidateRelativePath = $TopCandidateRelativePath
    TopScore = $TopScore
    SecondScore = $SecondScore
    ScoreMargin = $ScoreMargin
    ActiveDbStatus = $ActiveDbStatus
    Confidence = $Confidence
    NextRecommendation = $NextRecommendation
}

$Summary | ConvertTo-Json -Depth 8 | Set-Content -LiteralPath $SummaryJson -Encoding UTF8

$lines = New-Object System.Collections.Generic.List[string]
$lines.Add("# PHASE 12.0G ACTIVE SQLITE DATABASE IDENTIFICATION REPORT")
$lines.Add("")
$lines.Add(("Generated: {0}" -f (Get-Date -Format "yyyy-MM-dd HH:mm:ss")))
$lines.Add("")
$lines.Add("## Status")
$lines.Add("")
$lines.Add("Phase 12.0G read-only database identification completed.")
$lines.Add("")
$lines.Add("## Safety Confirmation")
$lines.Add("")
$lines.Add("- Frontend source modification: NO")
$lines.Add("- Backend source modification: NO")
$lines.Add("- Database modification: NO")
$lines.Add("- Database schema write/migration: NO")
$lines.Add("")
$lines.Add("## Evidence")
$lines.Add("")
$lines.Add(("- Candidate ranking CSV: {0}" -f $CandidateCsv))
$lines.Add(("- Backend reference CSV: {0}" -f $BackendReferenceCsv))
$lines.Add(("- Schema JSON: {0}" -f $SchemaJson))
$lines.Add(("- Schema text: {0}" -f $SchemaText))
$lines.Add(("- Summary JSON: {0}" -f $SummaryJson))
$lines.Add("")
$lines.Add("## Candidate Summary")
$lines.Add("")
$lines.Add(("- SQLite candidates found: {0}" -f $dbFiles.Count))
$lines.Add(("- Source files scanned: {0}" -f $sourceFiles.Count))
$lines.Add(("- Top candidate: {0}" -f $TopCandidatePath))
$lines.Add(("- Top score: {0}" -f $TopScore))
$lines.Add(("- Second score: {0}" -f $SecondScore))
$lines.Add(("- Score margin: {0}" -f $ScoreMargin))
$lines.Add("")
$lines.Add("## Schema Summary")
$lines.Add("")
$lines.Add(("- Node available: {0}" -f $NodeAvailable))
$lines.Add(("- Schema status: {0}" -f $SchemaStatus))
$lines.Add(("- Schema engine: {0}" -f $SchemaEngine))
$lines.Add(("- Schema read OK count: {0}" -f $SchemaReadOkCount))
$lines.Add(("- Schema has cases/matters table signal: {0}" -f $SchemaHasCasesTable))
$lines.Add(("- Schema has clients table signal: {0}" -f $SchemaHasClientsTable))
$lines.Add(("- Schema has Matter Type column signal: {0}" -f $SchemaHasMatterTypeColumn))
$lines.Add("")
$lines.Add("## Certification Signals")
$lines.Add("")
$lines.Add(("- Active DB status: {0}" -f $ActiveDbStatus))
$lines.Add(("- Confidence: {0}" -f $Confidence))
$lines.Add(("- Next recommendation: {0}" -f $NextRecommendation))
$lines.Add("")
$lines.Add("## Important Rule")
$lines.Add("")
$lines.Add("This report does not approve a database migration or frontend Matter Type field.")
$lines.Add("It only supports the next decision on whether a controlled migration plan may be prepared.")
$lines.Add("")

Set-Content -LiteralPath $ReportPath -Value ($lines -join [Environment]::NewLine) -Encoding UTF8

Add-Log ("Report created: {0}" -f $ReportPath)
Add-Log ("Summary JSON created: {0}" -f $SummaryJson)
Add-Log "Phase 12.0G completed."

Write-Host ""
Write-Host "============================================================" -ForegroundColor Green
Write-Host "PHASE 12.0G ACTIVE DB IDENTIFICATION COMPLETED" -ForegroundColor Green
Write-Host "============================================================" -ForegroundColor Green
Write-Host ""
Write-Host "Report:" -ForegroundColor Cyan
Write-Host $ReportPath
Write-Host ""
Write-Host "Summary JSON:" -ForegroundColor Cyan
Write-Host $SummaryJson
Write-Host ""

exit 0
'@

Set-Content -LiteralPath $RunScriptPath -Value $RunScriptContent -Encoding UTF8
Write-Host ("Created: {0}" -f $RunScriptPath) -ForegroundColor Green

# ------------------------------------------------------------
# SCRIPT: Final certification report
# ------------------------------------------------------------

$FinalScriptPath = Join-Path $PhaseRoot "06_SCRIPTS\Create-PHASE12.0G-Final-Db-Certification-Report.ps1"

$FinalScriptContent = @'
# ============================================================
# PHASE 12.0G - FINAL DB CERTIFICATION REPORT
# ============================================================

$ErrorActionPreference = "Stop"

$PhaseRoot = "C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software_LEOS_CONTROL\07_DISCOVERY\PHASE12.0G-ACTIVE-SQLITE-DATABASE-IDENTIFICATION"
$ReportsRoot = Join-Path $PhaseRoot "07_REPORTS"
$EvidenceRoot = Join-Path $PhaseRoot "08_EVIDENCE"

$Timestamp = Get-Date -Format "yyyyMMdd-HHmmss"
$FinalReport = Join-Path $ReportsRoot "PHASE12.0G-FINAL-ACTIVE-DB-CERTIFICATION-REPORT-$Timestamp.md"

New-Item -ItemType Directory -Force -Path $ReportsRoot | Out-Null

$LatestSummary = Get-ChildItem -LiteralPath $EvidenceRoot -Filter "PHASE12.0G-ACTIVE-DB-SUMMARY-*.json" -File -ErrorAction SilentlyContinue |
    Sort-Object LastWriteTime -Descending |
    Select-Object -First 1

$summaryObj = $null

if ($LatestSummary) {
    try {
        $summaryObj = Get-Content -LiteralPath $LatestSummary.FullName -Raw | ConvertFrom-Json
    } catch {
        $summaryObj = $null
    }
}

$lines = New-Object System.Collections.Generic.List[string]
$lines.Add("# PHASE 12.0G FINAL ACTIVE DATABASE CERTIFICATION REPORT")
$lines.Add("")
$lines.Add(("Generated: {0}" -f (Get-Date -Format "yyyy-MM-dd HH:mm:ss")))
$lines.Add("")
$lines.Add("## Certification Scope")
$lines.Add("")
$lines.Add("This certifies read-only active SQLite database identification only.")
$lines.Add("It does not approve migration, backend patch, frontend patch, or Phase 11 work.")
$lines.Add("")
$lines.Add("## Latest Summary")
$lines.Add("")
if ($LatestSummary) {
    $lines.Add(("- Latest summary JSON: {0}" -f $LatestSummary.FullName))
} else {
    $lines.Add("- Latest summary JSON: NOT FOUND")
}
$lines.Add("")

if ($summaryObj -eq $null) {
    $lines.Add("## Decision")
    $lines.Add("")
    $lines.Add("STATUS: FAIL")
    $lines.Add("")
    $lines.Add("Reason: No valid Phase 12.0G summary was found.")
} else {
    $lines.Add("## Summary")
    $lines.Add("")
    $lines.Add(("- SQLite candidates found: {0}" -f $summaryObj.CandidateCount))
    $lines.Add(("- Node available: {0}" -f $summaryObj.NodeAvailable))
    $lines.Add(("- Schema status: {0}" -f $summaryObj.SchemaStatus))
    $lines.Add(("- Schema engine: {0}" -f $summaryObj.SchemaEngine))
    $lines.Add(("- Schema read OK count: {0}" -f $summaryObj.SchemaReadOkCount))
    $lines.Add(("- Top candidate: {0}" -f $summaryObj.TopCandidatePath))
    $lines.Add(("- Top score: {0}" -f $summaryObj.TopScore))
    $lines.Add(("- Score margin: {0}" -f $summaryObj.ScoreMargin))
    $lines.Add(("- Active DB status: {0}" -f $summaryObj.ActiveDbStatus))
    $lines.Add(("- Confidence: {0}" -f $summaryObj.Confidence))
    $lines.Add(("- Matter Type column exists: {0}" -f $summaryObj.SchemaHasMatterTypeColumn))
    $lines.Add(("- Next recommendation: {0}" -f $summaryObj.NextRecommendation))
    $lines.Add("")

    $lines.Add("## Decision")
    $lines.Add("")

    if ($summaryObj.ActiveDbStatus -eq "ACTIVE_DATABASE_IDENTIFIED_SCHEMA_READ") {
        $lines.Add("STATUS: ACTIVE DATABASE CERTIFIED / MIGRATION PLAN MAY BE PREPARED")
        $lines.Add("")
        $lines.Add("Reason: Active database was identified with schema read evidence.")
        $lines.Add("Next action: Prepare Phase 12.0H controlled Matter Type migration plan. Do not execute migration yet.")
    } elseif ($summaryObj.ActiveDbStatus -eq "ACTIVE_DATABASE_IDENTIFIED_SCHEMA_NOT_READ") {
        $lines.Add("STATUS: POSSIBLE ACTIVE DATABASE / MANUAL SCHEMA CONFIRMATION REQUIRED")
        $lines.Add("")
        $lines.Add("Reason: Candidate ranking points to a likely active database, but schema was not read.")
        $lines.Add("Next action: confirm schema access before migration planning.")
    } elseif ($summaryObj.ActiveDbStatus -eq "MULTIPLE_POSSIBLE_ACTIVE_DATABASES") {
        $lines.Add("STATUS: MULTIPLE CANDIDATES / PATCH NOT APPROVED")
        $lines.Add("")
        $lines.Add("Reason: More than one candidate may be operational.")
        $lines.Add("Next action: manually review top candidate evidence.")
    } else {
        $lines.Add("STATUS: ACTIVE DATABASE NOT IDENTIFIED / PATCH NOT APPROVED")
        $lines.Add("")
        $lines.Add("Reason: The active operational database is not certified.")
        $lines.Add("Next action: do not patch. Resolve database identity first.")
    }
}

$lines.Add("")
$lines.Add("## Safety Confirmation")
$lines.Add("")
$lines.Add("- Frontend source modification: NO")
$lines.Add("- Backend source modification: NO")
$lines.Add("- Database modification: NO")
$lines.Add("- Migration executed: NO")
$lines.Add("- Phase 11 status: LOCKED")
$lines.Add("")
$lines.Add("END OF PHASE 12.0G FINAL CERTIFICATION REPORT")
$lines.Add("")

Set-Content -LiteralPath $FinalReport -Value ($lines -join [Environment]::NewLine) -Encoding UTF8

Write-Host ""
Write-Host "Final Phase 12.0G active database certification report created:" -ForegroundColor Green
Write-Host $FinalReport
Write-Host ""

exit 0
'@

Set-Content -LiteralPath $FinalScriptPath -Value $FinalScriptContent -Encoding UTF8
Write-Host ("Created: {0}" -f $FinalScriptPath) -ForegroundColor Green

# ------------------------------------------------------------
# SCRIPT: Run all
# ------------------------------------------------------------

$AllScriptPath = Join-Path $PhaseRoot "06_SCRIPTS\Run-PHASE12.0G-All-ReadOnly.ps1"

$AllScriptContent = @'
# ============================================================
# PHASE 12.0G - RUN ALL READ-ONLY
# ============================================================

$ErrorActionPreference = "Stop"

$PhaseRoot = "C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software_LEOS_CONTROL\07_DISCOVERY\PHASE12.0G-ACTIVE-SQLITE-DATABASE-IDENTIFICATION"
$ScriptsRoot = Join-Path $PhaseRoot "06_SCRIPTS"

$RunScript = Join-Path $ScriptsRoot "Run-PHASE12.0G-ActiveDb-ReadOnly.ps1"
$FinalScript = Join-Path $ScriptsRoot "Create-PHASE12.0G-Final-Db-Certification-Report.ps1"

function Test-PowerShellParse {
    param([string]$Path)

    $parseErrors = $null
    $tokens = $null
    $null = [System.Management.Automation.Language.Parser]::ParseFile($Path, [ref]$tokens, [ref]$parseErrors)

    if ($parseErrors -and $parseErrors.Count -gt 0) {
        Write-Host ""
        Write-Host ("PARSER ERROR in {0}" -f $Path) -ForegroundColor Red
        foreach ($err in $parseErrors) {
            Write-Host ("- {0}" -f $err.Message) -ForegroundColor Red
        }
        return $false
    }

    return $true
}

Write-Host ""
Write-Host "============================================================" -ForegroundColor Cyan
Write-Host "PHASE 12.0G - RUN ALL READ-ONLY" -ForegroundColor Cyan
Write-Host "============================================================" -ForegroundColor Cyan
Write-Host ""

if (-not (Test-Path -LiteralPath $RunScript)) {
    Write-Host "Main Phase 12.0G script missing." -ForegroundColor Red
    exit 1
}

if (-not (Test-Path -LiteralPath $FinalScript)) {
    Write-Host "Final certification script missing." -ForegroundColor Red
    exit 1
}

if (-not (Test-PowerShellParse -Path $RunScript)) {
    Write-Host "Main Phase 12.0G script failed parser validation. Stopping." -ForegroundColor Red
    exit 1
}

if (-not (Test-PowerShellParse -Path $FinalScript)) {
    Write-Host "Final certification script failed parser validation. Stopping." -ForegroundColor Red
    exit 1
}

Write-Host "Running Phase 12.0G active database read-only identification..." -ForegroundColor Yellow
& powershell -ExecutionPolicy Bypass -NoProfile -File $RunScript
$runExit = $LASTEXITCODE

if ($runExit -ne 0) {
    Write-Host ""
    Write-Host ("Phase 12.0G main run failed with exit code {0}. Final certification will NOT be created." -f $runExit) -ForegroundColor Red
    exit $runExit
}

Write-Host ""
Write-Host "Creating Phase 12.0G final active database certification report..." -ForegroundColor Yellow
& powershell -ExecutionPolicy Bypass -NoProfile -File $FinalScript
$certExit = $LASTEXITCODE

if ($certExit -ne 0) {
    Write-Host ""
    Write-Host ("Phase 12.0G final certification failed with exit code {0}." -f $certExit) -ForegroundColor Red
    exit $certExit
}

Write-Host ""
Write-Host "============================================================" -ForegroundColor Green
Write-Host "PHASE 12.0G ALL READ-ONLY COMPLETED SUCCESSFULLY" -ForegroundColor Green
Write-Host "============================================================" -ForegroundColor Green
Write-Host ""

exit 0
'@

Set-Content -LiteralPath $AllScriptPath -Value $AllScriptContent -Encoding UTF8
Write-Host ("Created: {0}" -f $AllScriptPath) -ForegroundColor Green

# ------------------------------------------------------------
# SCRIPT: Live monitor
# ------------------------------------------------------------

$MonitorScriptPath = Join-Path $PhaseRoot "06_SCRIPTS\Start-PHASE12.0G-Live-Monitor.ps1"

$MonitorScriptContent = @'
# ============================================================
# PHASE 12.0G - LIVE MONITOR
# ============================================================

param(
    [int]$IntervalSeconds = 10
)

$ErrorActionPreference = "Stop"

$ProjectRoot = "C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software"
$PhaseRoot = "C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software_LEOS_CONTROL\07_DISCOVERY\PHASE12.0G-ACTIVE-SQLITE-DATABASE-IDENTIFICATION"
$MonitorRoot = Join-Path $PhaseRoot "10_LIVE_MONITORING"
$Timestamp = Get-Date -Format "yyyyMMdd-HHmmss"

New-Item -ItemType Directory -Force -Path $MonitorRoot | Out-Null

$CsvPath = Join-Path $MonitorRoot "PHASE12.0G-live-monitor-$Timestamp.csv"
$MdPath = Join-Path $MonitorRoot "PHASE12.0G-LIVE-STATUS.md"

"Timestamp,ProjectRootExists,PhaseRootExists,DbCandidateCount,LatestReport,LatestSummary,NodeAvailable" | Set-Content -LiteralPath $CsvPath -Encoding UTF8

function Get-SafeDbCount {
    param([string]$RootPath)

    $skipNames = @("node_modules", ".git", "dist", "build", "coverage", ".vite", ".next", ".turbo", ".cache", "cache", "tmp", "temp")
    $count = 0

    if (-not (Test-Path -LiteralPath $RootPath)) {
        return 0
    }

    $stack = New-Object System.Collections.Generic.Stack[System.IO.DirectoryInfo]
    $stack.Push((Get-Item -LiteralPath $RootPath))

    while ($stack.Count -gt 0) {
        $dir = $stack.Pop()
        try {
            foreach ($file in $dir.EnumerateFiles()) {
                $ext = $file.Extension.ToLowerInvariant()
                if ($ext -eq ".db" -or $ext -eq ".sqlite" -or $ext -eq ".sqlite3") {
                    $count += 1
                }
            }

            foreach ($sub in $dir.EnumerateDirectories()) {
                if ($skipNames -contains $sub.Name) {
                    continue
                }
                $stack.Push($sub)
            }
        } catch {
            continue
        }
    }

    return $count
}

Write-Host "PHASE 12.0G live monitor started. Stop with CTRL+C." -ForegroundColor Green
Write-Host ("CSV: {0}" -f $CsvPath)
Write-Host ("Live MD: {0}" -f $MdPath)

while ($true) {
    $now = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $projectExists = Test-Path -LiteralPath $ProjectRoot
    $phaseExists = Test-Path -LiteralPath $PhaseRoot
    $dbCount = Get-SafeDbCount -RootPath $ProjectRoot

    $latestReport = ""
    $latestSummary = ""

    $reportFile = Get-ChildItem -LiteralPath (Join-Path $PhaseRoot "07_REPORTS") -Filter "PHASE12.0G-*.md" -File -ErrorAction SilentlyContinue |
        Sort-Object LastWriteTime -Descending |
        Select-Object -First 1

    if ($reportFile) {
        $latestReport = $reportFile.FullName
    }

    $summaryFile = Get-ChildItem -LiteralPath (Join-Path $PhaseRoot "08_EVIDENCE") -Filter "PHASE12.0G-ACTIVE-DB-SUMMARY-*.json" -File -ErrorAction SilentlyContinue |
        Sort-Object LastWriteTime -Descending |
        Select-Object -First 1

    if ($summaryFile) {
        $latestSummary = $summaryFile.FullName
    }

    $nodeAvailable = $false
    if (Get-Command node -ErrorAction SilentlyContinue) {
        $nodeAvailable = $true
    }

    $csvLine = '"{0}","{1}","{2}","{3}","{4}","{5}","{6}"' -f $now, $projectExists, $phaseExists, $dbCount, $latestReport, $latestSummary, $nodeAvailable
    Add-Content -LiteralPath $CsvPath -Value $csvLine -Encoding UTF8

    $md = New-Object System.Collections.Generic.List[string]
    $md.Add("# PHASE 12.0G LIVE STATUS")
    $md.Add("")
    $md.Add(("Updated: {0}" -f $now))
    $md.Add("")
    $md.Add(("Project root exists: {0}" -f $projectExists))
    $md.Add(("Phase root exists: {0}" -f $phaseExists))
    $md.Add(("SQLite candidate count: {0}" -f $dbCount))
    $md.Add(("Node available: {0}" -f $nodeAvailable))
    $md.Add("")
    $md.Add(("Latest report: {0}" -f $latestReport))
    $md.Add(("Latest summary: {0}" -f $latestSummary))
    $md.Add("")
    $md.Add("Safety: read-only monitoring only.")

    Set-Content -LiteralPath $MdPath -Value ($md -join [Environment]::NewLine) -Encoding UTF8

    Start-Sleep -Seconds $IntervalSeconds
}
'@

Set-Content -LiteralPath $MonitorScriptPath -Value $MonitorScriptContent -Encoding UTF8
Write-Host ("Created: {0}" -f $MonitorScriptPath) -ForegroundColor Green

# ------------------------------------------------------------
# Parser validation
# ------------------------------------------------------------

$ScriptsToValidate = @($RunScriptPath, $FinalScriptPath, $AllScriptPath, $MonitorScriptPath)
$ParseFailures = New-Object System.Collections.Generic.List[object]

foreach ($scriptPath in $ScriptsToValidate) {
    $parseErrors = $null
    $tokens = $null
    $null = [System.Management.Automation.Language.Parser]::ParseFile($scriptPath, [ref]$tokens, [ref]$parseErrors)

    if ($parseErrors -and $parseErrors.Count -gt 0) {
        foreach ($err in $parseErrors) {
            $ParseFailures.Add([pscustomobject]@{
                Script = $scriptPath
                Error = $err.Message
            })
        }
    }
}

$SummaryReport = Join-Path $PhaseRoot ("07_REPORTS\PHASE12.0G-PACK-CREATION-SUMMARY-{0}.md" -f $Timestamp)

$summaryLines = New-Object System.Collections.Generic.List[string]
$summaryLines.Add("# PHASE 12.0G PACK CREATION SUMMARY")
$summaryLines.Add("")
$summaryLines.Add(("Generated: {0}" -f (Get-Date -Format "yyyy-MM-dd HH:mm:ss")))
$summaryLines.Add("")
$summaryLines.Add(("Project Root: {0}" -f $ProjectRoot))
$summaryLines.Add(("Phase Root: {0}" -f $PhaseRoot))
$summaryLines.Add("")
$summaryLines.Add("## Scripts")
$summaryLines.Add("")
foreach ($scriptPath in $ScriptsToValidate) {
    $summaryLines.Add(("- {0}" -f $scriptPath))
}
$summaryLines.Add("")
$summaryLines.Add("## Parser Validation")
$summaryLines.Add("")
if ($ParseFailures.Count -eq 0) {
    $summaryLines.Add("Status: PASS")
} else {
    $summaryLines.Add("Status: FAIL")
    foreach ($failure in $ParseFailures) {
        $summaryLines.Add(("- {0}: {1}" -f $failure.Script, $failure.Error))
    }
}
$summaryLines.Add("")
$summaryLines.Add("## Safety")
$summaryLines.Add("")
$summaryLines.Add("- Frontend source modified: NO")
$summaryLines.Add("- Backend source modified: NO")
$summaryLines.Add("- Database modified: NO")
$summaryLines.Add("- Control pack created: YES")
$summaryLines.Add("")

Set-Content -LiteralPath $SummaryReport -Value ($summaryLines -join [Environment]::NewLine) -Encoding UTF8

if ($ParseFailures.Count -gt 0) {
    Write-Host ""
    Write-Host "============================================================" -ForegroundColor Red
    Write-Host "PHASE 12.0G PACK CREATED BUT PARSER VALIDATION FAILED" -ForegroundColor Red
    Write-Host "============================================================" -ForegroundColor Red
    Write-Host ""
    Write-Host "Summary report:" -ForegroundColor Yellow
    Write-Host $SummaryReport
    Write-Host ""
    exit 1
}

Write-Host ""
Write-Host "============================================================" -ForegroundColor Green
Write-Host "PHASE 12.0G ACTIVE DATABASE IDENTIFICATION PACK CREATED SUCCESSFULLY" -ForegroundColor Green
Write-Host "============================================================" -ForegroundColor Green
Write-Host ""
Write-Host "Phase Root:" -ForegroundColor Cyan
Write-Host $PhaseRoot
Write-Host ""
Write-Host "Next command:" -ForegroundColor Yellow
Write-Host ("powershell -NoExit -ExecutionPolicy Bypass -NoProfile -File `"{0}`"" -f $AllScriptPath)
Write-Host ""
Write-Host "Optional live monitor command:" -ForegroundColor Yellow
Write-Host ("powershell -NoExit -ExecutionPolicy Bypass -NoProfile -File `"{0}`" -IntervalSeconds 10" -f $MonitorScriptPath)
Write-Host ""
Write-Host "Summary report:" -ForegroundColor Cyan
Write-Host $SummaryReport
Write-Host ""

exit 0
