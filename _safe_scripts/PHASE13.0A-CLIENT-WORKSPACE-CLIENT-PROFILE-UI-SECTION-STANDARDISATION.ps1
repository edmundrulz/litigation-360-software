param(
    [string]$ProjectRoot = "C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software",
    [string]$ControlRoot = "C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software_LEOS_CONTROL",
    [switch]$Apply,
    [switch]$StartLiveMonitor,
    [switch]$SkipBuildTest
)

$ErrorActionPreference = "Stop"

$PhaseName = "PHASE13.0A-CLIENT-WORKSPACE-CLIENT-PROFILE-UI-SECTION-STANDARDISATION"
$Timestamp = Get-Date -Format "yyyyMMdd-HHmmss"

$PhaseRoot = Join-Path $ControlRoot "07_DISCOVERY\$PhaseName"
$Folders = @(
    "00_README",
    "01_PARAMETERS",
    "02_PROTOCOLS",
    "03_AUDIT",
    "04_PATCHES",
    "05_BACKUPS\$Timestamp",
    "06_VERIFICATION",
    "07_LIVE_MONITORING",
    "08_ROLLBACK",
    "09_HANDOVER",
    "10_TEST_RESULTS",
    "11_NEXT_PHASE_13B"
)

foreach ($folder in $Folders) {
    New-Item -ItemType Directory -Path (Join-Path $PhaseRoot $folder) -Force | Out-Null
}

$LogPath = Join-Path $PhaseRoot "07_LIVE_MONITORING\$PhaseName-run-$Timestamp.log"
$LiveStatusPath = Join-Path $PhaseRoot "07_LIVE_MONITORING\$PhaseName-LIVE-STATUS.md"
$BackupRoot = Join-Path $PhaseRoot "05_BACKUPS\$Timestamp"
$RollbackPath = Join-Path $PhaseRoot "08_ROLLBACK\ROLLBACK-$PhaseName-$Timestamp.ps1"

function Write-Utf8NoBom {
    param(
        [Parameter(Mandatory=$true)][string]$Path,
        [Parameter(Mandatory=$true)][string]$Text
    )

    $parent = Split-Path -Parent $Path
    if ($parent -and !(Test-Path -LiteralPath $parent)) {
        New-Item -ItemType Directory -Path $parent -Force | Out-Null
    }

    $utf8NoBom = New-Object System.Text.UTF8Encoding($false)
    [System.IO.File]::WriteAllText($Path, $Text, $utf8NoBom)
}

function Get-RelativePathSafe {
    param(
        [Parameter(Mandatory=$true)][string]$BasePath,
        [Parameter(Mandatory=$true)][string]$TargetPath
    )

    $baseFull = [System.IO.Path]::GetFullPath($BasePath).TrimEnd('\') + '\'
    $targetFull = [System.IO.Path]::GetFullPath($TargetPath)

    $baseUri = New-Object System.Uri($baseFull)
    $targetUri = New-Object System.Uri($targetFull)

    return [Uri]::UnescapeDataString($baseUri.MakeRelativeUri($targetUri).ToString()).Replace('/', '\')
}

function Add-LiveStatus {
    param([string]$Message)

    $line = "- " + (Get-Date -Format "yyyy-MM-dd HH:mm:ss") + " | " + $Message
    Add-Content -LiteralPath $LiveStatusPath -Value $line -Encoding UTF8
    Write-Host $line
}

function Test-UrlSafe {
    param([string]$Url)

    $sw = [System.Diagnostics.Stopwatch]::StartNew()

    try {
        $response = Invoke-WebRequest -UseBasicParsing -Uri $Url -TimeoutSec 5
        $sw.Stop()

        return [pscustomobject]@{
            Time       = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
            Url        = $Url
            Status     = "OK"
            StatusCode = $response.StatusCode
            Ms         = $sw.ElapsedMilliseconds
            Error      = ""
        }
    }
    catch {
        $sw.Stop()

        return [pscustomobject]@{
            Time       = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
            Url        = $Url
            Status     = "WARN"
            StatusCode = ""
            Ms         = $sw.ElapsedMilliseconds
            Error      = $_.Exception.Message
        }
    }
}

Start-Transcript -Path $LogPath -Force | Out-Null

try {
    if (!(Test-Path -LiteralPath $ProjectRoot)) {
        throw "Project root does not exist: $ProjectRoot"
    }

    New-Item -ItemType File -Path $LiveStatusPath -Force | Out-Null

    Set-Content -LiteralPath $LiveStatusPath -Encoding UTF8 -Value @(
        "# $PhaseName",
        "",
        "## Live Status",
        "",
        "- Started: $(Get-Date -Format "yyyy-MM-dd HH:mm:ss")",
        "- Project Root: $ProjectRoot",
        "- Control Root: $ControlRoot",
        "- Mode: $(if ($Apply) { "APPLY SAFE PATCH" } else { "AUDIT ONLY" })",
        ""
    )

    Add-LiveStatus "Phase folder created."
    Add-LiveStatus "Safety mode confirmed. Backend, database, API routes, authentication, RBAC and server files are protected from this phase."

    $ChangeMatrix = @(
        [pscustomobject]@{
            Old = "1. Name, Title and Identity Lock"
            New = "Client Profile Details"
            Reason = "Remove backend/system wording from user-facing UI."
            Risk = "Low"
        },
        [pscustomobject]@{
            Old = "Name, Title and Identity Lock"
            New = "Client Profile Details"
            Reason = "Remove backend/system wording from user-facing UI."
            Risk = "Low"
        },
        [pscustomobject]@{
            Old = "2. Identification, Date of Birth, State of Birth, Age and Generation"
            New = "Client Identification Details"
            Reason = "Shorten technical heading into professional client-facing category."
            Risk = "Low"
        },
        [pscustomobject]@{
            Old = "Identification, Date of Birth, State of Birth, Age and Generation"
            New = "Client Identification Details"
            Reason = "Shorten technical heading into professional client-facing category."
            Risk = "Low"
        },
        [pscustomobject]@{
            Old = "3. Employment and Family Status"
            New = "Employment Details"
            Reason = "Separate employment from family and marital information."
            Risk = "Low for heading only. Full visual split belongs to Phase 13.0B."
        },
        [pscustomobject]@{
            Old = "Employment and Family Status"
            New = "Employment Details"
            Reason = "Separate employment from family and marital information."
            Risk = "Low for heading only. Full visual split belongs to Phase 13.0B."
        },
        [pscustomobject]@{
            Old = "6. Emergency Contact, Verification and Documentation"
            New = "Emergency Contact Details"
            Reason = "Separate emergency contact from documentation verification."
            Risk = "Low for heading only. Full visual split belongs to Phase 13.0B."
        },
        [pscustomobject]@{
            Old = "Emergency Contact, Verification and Documentation"
            New = "Emergency Contact Details"
            Reason = "Separate emergency contact from documentation verification."
            Risk = "Low for heading only. Full visual split belongs to Phase 13.0B."
        },
        [pscustomobject]@{
            Old = "Special Remarks / Staff-Lawyer Notes"
            New = "Internal Remarks and Staff Notes"
            Reason = "Cleaner legal operations terminology."
            Risk = "Low"
        },
        [pscustomobject]@{
            Old = "Missing / N/A / Unknown Information Notes"
            New = "Missing, Unknown or Pending Information"
            Reason = "Cleaner professional wording."
            Risk = "Low"
        }
    )

    $ChangeMatrixPath = Join-Path $PhaseRoot "01_PARAMETERS\$PhaseName-CHANGE-MATRIX.csv"
    $ChangeMatrix | Export-Csv -LiteralPath $ChangeMatrixPath -NoTypeInformation -Encoding UTF8

    $Parameters = [pscustomobject]@{
        phase = $PhaseName
        project_root = $ProjectRoot
        control_root = $ControlRoot
        mode = $(if ($Apply) { "APPLY" } else { "AUDIT_ONLY" })
        protected_change_types = @(
            "No database schema changes",
            "No backend API changes",
            "No authentication changes",
            "No RBAC changes",
            "No server.js changes",
            "No package.json changes",
            "No dependency changes",
            "No destructive delete operations"
        )
        allowed_file_extensions = @(".js", ".jsx", ".ts", ".tsx", ".html", ".htm", ".vue", ".svelte")
        excluded_folders = @("node_modules", ".git", "dist", "build", "coverage", ".next", "out", "vendor", "tmp", "temp")
        intended_final_sections = @(
            "Client Profile Details",
            "Client Identification Details",
            "Employment Details",
            "Family and Marital Details",
            "Contact and Communication Preferences",
            "Address and Service of Correspondence",
            "Emergency Contact Details",
            "Documentation Verification Status",
            "Internal Remarks and Staff Notes",
            "Missing, Unknown or Pending Information"
        )
    }

    $ParametersJsonPath = Join-Path $PhaseRoot "01_PARAMETERS\$PhaseName-PARAMETERS.json"
    $Parameters | ConvertTo-Json -Depth 10 | Set-Content -LiteralPath $ParametersJsonPath -Encoding UTF8

    $ReadmePath = Join-Path $PhaseRoot "00_README\$PhaseName-README.md"
    Write-Utf8NoBom -Path $ReadmePath -Text @"
# $PhaseName

## Purpose

This phase safely standardises the user-facing section headings in the Litigation 360 Client Registration / Client Profile screen.

The goal is to remove technical, backend, developer-style, and system-control wording from the visible client form.

## Primary Safety Rule

This phase must not break the existing operational system.

Therefore, this phase is limited to conservative heading text standardisation, documentation creation, audit reporting, backup creation, and monitoring.

## Strictly Protected Areas

This phase must not modify:

- backend routes
- database schema
- migrations
- authentication
- RBAC
- audit engine
- scheduler
- monitoring engine
- server.js
- package.json
- package-lock.json
- environment files
- production data
- client records
- legal documents

## Intended UI Heading Direction

1. Client Profile Details
2. Client Identification Details
3. Employment Details
4. Family and Marital Details
5. Contact and Communication Preferences
6. Address and Service of Correspondence
7. Emergency Contact Details
8. Documentation Verification Status
9. Internal Remarks and Staff Notes
10. Missing, Unknown or Pending Information

## Important Note

Phase 13.0A performs safe heading replacement only.

The deeper visual split of:

- Employment Details
- Family and Marital Details
- Emergency Contact Details
- Documentation Verification Status

should be done in Phase 13.0B after the exact source file and field anchors are confirmed by the audit report.
"@

    $ProtocolPath = Join-Path $PhaseRoot "02_PROTOCOLS\$PhaseName-PROTOCOLS.md"
    Write-Utf8NoBom -Path $ProtocolPath -Text @"
# $PhaseName Protocols

## Protocol 1: No Blind Editing

Do not manually create files in random folders.

All phase files must be created under:

$PhaseRoot

All safe scripts must be created under:

$ProjectRoot\_safe_scripts

## Protocol 2: Backup Before Change

Every source file modified by this phase must be copied to:

$BackupRoot

before modification.

## Protocol 3: Exact Text Replacement Only

This phase only replaces exact visible heading text.

It does not restructure JSX, React state, validation, API calls, props, database fields, or backend services.

## Protocol 4: Full Split Requires Phase 13.0B

The following are not fully implemented by heading replacement alone:

- separating Employment Details from Family and Marital Details
- separating Emergency Contact Details from Documentation Verification Status

Phase 13.0A identifies the exact source file and field anchors required for Phase 13.0B.

## Protocol 5: Rollback Ready

A rollback script is generated automatically at:

$RollbackPath

## Protocol 6: Verification Required

After patching, verify:

- page loads
- form still accepts typing
- dropdowns still open
- WhatsApp fields still display
- client table still appears
- no white screen
- no console crash
- no backend route modification
- no database change
"@

    $ChecklistPath = Join-Path $PhaseRoot "06_VERIFICATION\$PhaseName-VERIFICATION-CHECKLIST.md"
    Write-Utf8NoBom -Path $ChecklistPath -Text @"
# Verification Checklist

## Visual Heading Checks

Confirm the client profile screen no longer displays:

- Name, Title and Identity Lock
- Identification, Date of Birth, State of Birth, Age and Generation
- Employment and Family Status
- Emergency Contact, Verification and Documentation
- Special Remarks / Staff-Lawyer Notes
- Missing / N/A / Unknown Information Notes

Confirm the screen displays:

- Client Profile Details
- Client Identification Details
- Employment Details
- Contact and Communication Preferences
- Address and Service of Correspondence
- Emergency Contact Details
- Internal Remarks and Staff Notes
- Missing, Unknown or Pending Information

## Function Checks

Confirm:

- Previous Page button works
- Home button works
- Save & Next button still appears
- Add Client button still appears
- Clear Form button still appears
- Client Search still appears
- Client table still appears
- No existing field disappears accidentally

## Backend Warning Check

The existing 'BACKEND CHECK REQUIRED' warning must be treated separately.

This phase records endpoint health but does not modify backend code.

## Browser Check

Open:

http://localhost:5173

Then navigate to the Client Workspace / Clients screen.

## Failure Condition

Rollback immediately if:

- blank white screen
- form page fails to load
- build fails only after this patch
- headings disappear entirely
- file corruption is detected
"@

    $TestPlanPath = Join-Path $PhaseRoot "10_TEST_RESULTS\$PhaseName-TEST-PLAN.md"
    Write-Utf8NoBom -Path $TestPlanPath -Text @"
# Test Plan

## Test 1: Static File Audit

The script scans source files for old heading text.

Expected result:

- target files found
- replacement count recorded
- no backend files modified

## Test 2: Safe Patch

The script backs up files first, then replaces exact old heading text.

Expected result:

- only UI source files changed
- no deletion
- no backend mutation

## Test 3: Build Test

If package.json has a build script and npm is available, run:

npm run build

Expected result:

- build completes successfully

If build fails, inspect the build log before assuming this phase caused it.

## Test 4: Runtime Visual Test

Open frontend and verify the client form headings.

## Test 5: Endpoint Probe

The script probes common local URLs:

- http://localhost:5173
- http://localhost:5000/api/clients
- http://localhost:5100/api/clients
- http://localhost:3000/api/clients
- http://localhost:8080/api/clients

A failed probe is recorded as WARN, not as an automatic phase failure.
"@

    $NextPhasePromptPath = Join-Path $PhaseRoot "09_HANDOVER\$PhaseName-NEXT-THREAD-HANDOVER-PROMPT.md"
    Write-Utf8NoBom -Path $NextPhasePromptPath -Text @"
# Next Thread Handover Prompt

Use this prompt for the next safe coding phase.

---

I am working on Litigation 360.

Project root:

$ProjectRoot

Control root:

$ControlRoot

Current phase completed:

$PhaseName

Objective already completed:

- safe documentation folder creation
- heading replacement audit
- safe heading replacement
- backup creation
- rollback script creation
- live monitoring script creation
- source file target detection

Next required phase:

PHASE13.0B-CLIENT-PROFILE-SECTION-LAYOUT-SPLIT

Required UI outcome:

1. Client Profile Details
2. Client Identification Details
3. Employment Details
4. Family and Marital Details
5. Contact and Communication Preferences
6. Address and Service of Correspondence
7. Emergency Contact Details
8. Documentation Verification Status
9. Internal Remarks and Staff Notes
10. Missing, Unknown or Pending Information

Critical implementation rule:

Do not change backend, database, API, auth, RBAC, server.js, package.json, or dependencies.

Only update the identified client profile UI source file.

Required split:

Employment Details should contain only employment-related fields.

Family and Marital Details should contain only marital/family-related fields.

Emergency Contact Details should contain only:

- Emergency Contact Name
- Relationship
- Emergency Contact Number
- Emergency Contact Email

Documentation Verification Status should contain only:

- Document Type
- Document Status
- Verification / Review Status
- Attach Scanned Copy / Digital Copy
- Document Related Reference Notes

Use the existing section styling/wrapper. Do not invent new design patterns.

Before editing, read:

$PhaseRoot\03_AUDIT
$PhaseRoot\04_PATCHES
$PhaseRoot\06_VERIFICATION
$PhaseRoot\11_NEXT_PHASE_13B

Return a surgical copy-paste PowerShell replacement only after confirming the exact target file.
"@

    $NextPhaseBlueprintPath = Join-Path $PhaseRoot "11_NEXT_PHASE_13B\$PhaseName-PHASE13B-BLUEPRINT.md"
    Write-Utf8NoBom -Path $NextPhaseBlueprintPath -Text @"
# Phase 13.0B Blueprint

## Phase Name

PHASE13.0B-CLIENT-PROFILE-SECTION-LAYOUT-SPLIT

## Objective

Perform the deeper visual layout split that Phase 13.0A intentionally avoids.

## Required Split 1

Current combined area:

Employment and Family Status

Final sections:

### Employment Details

Fields:

- Employment Status
- Occupation
- Employer Name, if present
- Work Address, if present
- Income / salary field, only if already present and legally relevant

### Family and Marital Details

Fields:

- Marital / Family Status
- Spouse details, if present
- Dependants, if present
- Next of kin fields, if present and not emergency contact

## Required Split 2

Current combined area:

Emergency Contact, Verification and Documentation

Final sections:

### Emergency Contact Details

Fields:

- Emergency Contact Name
- Relationship
- Emergency Contact Number
- Emergency Contact Email

### Documentation Verification Status

Fields:

- Document Type
- Document Status
- Verification / Review Status
- Attach Scanned Copy / Digital Copy
- Document Related Reference Notes

## Do Not Change

- field names
- React state keys
- validation logic
- backend API payload names
- database column names
- client save logic
- client search logic
- table rendering logic

## Acceptance Criteria

The page must still save the same data payload as before.

Only the visible grouping and section headings should change.
"@

    Add-LiveStatus "Documentation pack created."

    $AllowedExtensions = @(".js", ".jsx", ".ts", ".tsx", ".html", ".htm", ".vue", ".svelte")
    $BlockedFolderRegex = "\\(node_modules|\.git|dist|build|coverage|\.next|out|vendor|tmp|temp)\\"

    Add-LiveStatus "Scanning source files."

    $SourceFiles = Get-ChildItem -LiteralPath $ProjectRoot -Recurse -File -ErrorAction SilentlyContinue | Where-Object {
        ($AllowedExtensions -contains $_.Extension.ToLowerInvariant()) -and
        ($_.FullName -notmatch $BlockedFolderRegex)
    }

    $PreManifest = foreach ($file in $SourceFiles) {
        [pscustomobject]@{
            RelativePath = Get-RelativePathSafe -BasePath $ProjectRoot -TargetPath $file.FullName
            FullPath = $file.FullName
            Extension = $file.Extension
            Length = $file.Length
            LastWriteTime = $file.LastWriteTime
            SHA256 = (Get-FileHash -Algorithm SHA256 -LiteralPath $file.FullName).Hash
        }
    }

    $PreManifestPath = Join-Path $PhaseRoot "03_AUDIT\$PhaseName-PRE-MANIFEST.csv"
    $PreManifest | Export-Csv -LiteralPath $PreManifestPath -NoTypeInformation -Encoding UTF8

    $TargetFileRows = @()
    $ReplacementRows = @()
    $AnchorRows = @()
    $ChangedFiles = @()
    $BackedUpFiles = @{}

    $AnchorTerms = @(
        "Employment Status",
        "Marital / Family Status",
        "Emergency Contact Name",
        "Relationship",
        "Emergency Contact Number",
        "Emergency Contact Email",
        "Document Type",
        "Document Status",
        "Verification / Review Status",
        "Attach Scanned Copy / Digital Copy",
        "Document Related Reference Notes"
    )

    foreach ($file in $SourceFiles) {
        $content = Get-Content -LiteralPath $file.FullName -Raw -ErrorAction SilentlyContinue
        if ($null -eq $content) {
            continue
        }

        $relative = Get-RelativePathSafe -BasePath $ProjectRoot -TargetPath $file.FullName
        $fileMatchCount = 0
        $updated = $content

        foreach ($change in $ChangeMatrix) {
            $count = ([regex]::Matches($updated, [regex]::Escape($change.Old))).Count

            if ($count -gt 0) {
                $fileMatchCount += $count

                $ReplacementRows += [pscustomobject]@{
                    File = $relative
                    OldText = $change.Old
                    NewText = $change.New
                    Occurrences = $count
                    Risk = $change.Risk
                    Reason = $change.Reason
                }

                $updated = $updated.Replace($change.Old, $change.New)
            }
        }

        if ($fileMatchCount -gt 0) {
            $TargetFileRows += [pscustomobject]@{
                File = $relative
                FullPath = $file.FullName
                Matches = $fileMatchCount
                ApplyMode = $(if ($Apply) { "APPLIED" } else { "AUDIT_ONLY" })
            }

            if ($Apply -and ($updated -ne $content)) {
                if (!$BackedUpFiles.ContainsKey($file.FullName)) {
                    $backupDest = Join-Path $BackupRoot $relative
                    $backupParent = Split-Path -Parent $backupDest
                    New-Item -ItemType Directory -Path $backupParent -Force | Out-Null
                    Copy-Item -LiteralPath $file.FullName -Destination $backupDest -Force
                    $BackedUpFiles[$file.FullName] = $backupDest
                }

                Write-Utf8NoBom -Path $file.FullName -Text $updated

                $ChangedFiles += [pscustomobject]@{
                    File = $relative
                    FullPath = $file.FullName
                    BackupPath = $BackedUpFiles[$file.FullName]
                    Replacements = $fileMatchCount
                }
            }
        }

        $lines = Get-Content -LiteralPath $file.FullName -ErrorAction SilentlyContinue

        for ($i = 0; $i -lt $lines.Count; $i++) {
            foreach ($anchor in $AnchorTerms) {
                if ($lines[$i] -like "*$anchor*") {
                    $AnchorRows += [pscustomobject]@{
                        File = $relative
                        Line = $i + 1
                        Anchor = $anchor
                        Text = $lines[$i].Trim()
                    }
                }
            }
        }
    }

    $TargetFilesPath = Join-Path $PhaseRoot "03_AUDIT\$PhaseName-TARGET-FILES.csv"
    $ReplacementReportPath = Join-Path $PhaseRoot "04_PATCHES\$PhaseName-REPLACEMENT-REPORT.csv"
    $AnchorReportPath = Join-Path $PhaseRoot "03_AUDIT\$PhaseName-FIELD-ANCHOR-REPORT.csv"
    $ChangedFilesPath = Join-Path $PhaseRoot "04_PATCHES\$PhaseName-CHANGED-FILES.csv"

    $TargetFileRows | Export-Csv -LiteralPath $TargetFilesPath -NoTypeInformation -Encoding UTF8
    $ReplacementRows | Export-Csv -LiteralPath $ReplacementReportPath -NoTypeInformation -Encoding UTF8
    $AnchorRows | Export-Csv -LiteralPath $AnchorReportPath -NoTypeInformation -Encoding UTF8
    $ChangedFiles | Export-Csv -LiteralPath $ChangedFilesPath -NoTypeInformation -Encoding UTF8

    Add-LiveStatus "Source scan completed. Target files found: $($TargetFileRows.Count)."
    Add-LiveStatus "Replacement rows recorded: $($ReplacementRows.Count)."
    Add-LiveStatus "Changed files: $($ChangedFiles.Count)."

    $RollbackLines = @()
    $RollbackLines += '$ErrorActionPreference = "Stop"'
    $RollbackLines += 'Write-Host ""'
    $RollbackLines += 'Write-Host "Starting Phase 13.0A rollback..." -ForegroundColor Yellow'
    $RollbackLines += 'Write-Host ""'

    if ($ChangedFiles.Count -eq 0) {
        $RollbackLines += 'Write-Host "No changed files were recorded for this timestamp. Nothing to rollback." -ForegroundColor Green'
    }
    else {
        foreach ($row in $ChangedFiles) {
            $destParent = Split-Path -Parent $row.FullPath
            $RollbackLines += "New-Item -ItemType Directory -Path `"$destParent`" -Force | Out-Null"
            $RollbackLines += "Copy-Item -LiteralPath `"$($row.BackupPath)`" -Destination `"$($row.FullPath)`" -Force"
            $RollbackLines += "Write-Host `"Restored: $($row.File)`""
        }
    }

    $RollbackLines += 'Write-Host ""'
    $RollbackLines += 'Write-Host "Rollback completed." -ForegroundColor Green'

    Write-Utf8NoBom -Path $RollbackPath -Text ($RollbackLines -join [Environment]::NewLine)

    Add-LiveStatus "Rollback script created: $RollbackPath"

    $ProbeUrls = @(
        "http://localhost:5173",
        "http://localhost:5000/api/clients",
        "http://localhost:5100/api/clients",
        "http://localhost:3000/api/clients",
        "http://localhost:8080/api/clients"
    )

    $ProbeResults = foreach ($url in $ProbeUrls) {
        Test-UrlSafe -Url $url
    }

    $ProbePath = Join-Path $PhaseRoot "10_TEST_RESULTS\$PhaseName-ENDPOINT-PROBES.csv"
    $ProbeResults | Export-Csv -LiteralPath $ProbePath -NoTypeInformation -Encoding UTF8

    foreach ($probe in $ProbeResults) {
        Add-LiveStatus "Probe $($probe.Status): $($probe.Url) $($probe.StatusCode) $($probe.Ms)ms"
    }

    $BuildExitCode = "SKIPPED"
    $BuildLogPath = Join-Path $PhaseRoot "10_TEST_RESULTS\$PhaseName-npm-build-$Timestamp.log"

    $PackageJsonPath = Join-Path $ProjectRoot "package.json"

    if (!$SkipBuildTest -and (Test-Path -LiteralPath $PackageJsonPath) -and (Get-Command npm -ErrorAction SilentlyContinue)) {
        try {
            $package = Get-Content -LiteralPath $PackageJsonPath -Raw | ConvertFrom-Json
            $scriptNames = @($package.scripts.PSObject.Properties.Name)

            if ($scriptNames -contains "build") {
                Add-LiveStatus "Running npm build test."
                Push-Location $ProjectRoot

                cmd.exe /c "npm run build" 2>&1 | Tee-Object -FilePath $BuildLogPath

                $BuildExitCode = $LASTEXITCODE
                Pop-Location

                Add-LiveStatus "npm build completed with exit code: $BuildExitCode"
            }
            else {
                Add-LiveStatus "package.json found but no build script exists. Build test skipped."
            }
        }
        catch {
            $BuildExitCode = "ERROR"
            Add-LiveStatus "Build test error: $($_.Exception.Message)"
            if ((Get-Location).Path -ne $ProjectRoot) {
            }
        }
    }
    else {
        Add-LiveStatus "Build test skipped."
    }

    $PostManifest = foreach ($file in $SourceFiles) {
        if (Test-Path -LiteralPath $file.FullName) {
            [pscustomobject]@{
                RelativePath = Get-RelativePathSafe -BasePath $ProjectRoot -TargetPath $file.FullName
                FullPath = $file.FullName
                Extension = $file.Extension
                Length = $file.Length
                LastWriteTime = (Get-Item -LiteralPath $file.FullName).LastWriteTime
                SHA256 = (Get-FileHash -Algorithm SHA256 -LiteralPath $file.FullName).Hash
            }
        }
    }

    $PostManifestPath = Join-Path $PhaseRoot "03_AUDIT\$PhaseName-POST-MANIFEST.csv"
    $PostManifest | Export-Csv -LiteralPath $PostManifestPath -NoTypeInformation -Encoding UTF8

    $MonitorScriptPath = Join-Path $PhaseRoot "07_LIVE_MONITORING\Start-$PhaseName-LiveMonitor.ps1"

    $MonitorText = @"
param(
    [int]`$IntervalSeconds = 15
)

`$ErrorActionPreference = "SilentlyContinue"

`$PhaseRoot = "$PhaseRoot"
`$ProjectRoot = "$ProjectRoot"
`$CsvPath = Join-Path `$PhaseRoot "07_LIVE_MONITORING\$PhaseName-live-monitor-$Timestamp.csv"
`$MdPath = Join-Path `$PhaseRoot "07_LIVE_MONITORING\$PhaseName-LIVE-MONITOR-CURRENT.md"

function Test-UrlLocal {
    param([string]`$Url)

    `$sw = [System.Diagnostics.Stopwatch]::StartNew()

    try {
        `$response = Invoke-WebRequest -UseBasicParsing -Uri `$Url -TimeoutSec 5
        `$sw.Stop()

        return [pscustomobject]@{
            Time = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
            Url = `$Url
            Status = "OK"
            StatusCode = `$response.StatusCode
            Ms = `$sw.ElapsedMilliseconds
            Error = ""
        }
    }
    catch {
        `$sw.Stop()

        return [pscustomobject]@{
            Time = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
            Url = `$Url
            Status = "WARN"
            StatusCode = ""
            Ms = `$sw.ElapsedMilliseconds
            Error = `$_.Exception.Message
        }
    }
}

`$Urls = @(
    "http://localhost:5173",
    "http://localhost:5000/api/clients",
    "http://localhost:5100/api/clients",
    "http://localhost:3000/api/clients",
    "http://localhost:8080/api/clients"
)

Write-Host ""
Write-Host "PHASE 13.0A live monitor started." -ForegroundColor Green
Write-Host "CSV: `$CsvPath"
Write-Host "Live MD: `$MdPath"
Write-Host "Stop with CTRL+C."
Write-Host ""

while (`$true) {
    `$results = foreach (`$url in `$Urls) {
        Test-UrlLocal -Url `$url
    }

    foreach (`$result in `$results) {
        `$result | Export-Csv -LiteralPath `$CsvPath -NoTypeInformation -Append -Encoding UTF8
    }

    `$okCount = (`$results | Where-Object { `$_.Status -eq "OK" }).Count
    `$warnCount = (`$results | Where-Object { `$_.Status -ne "OK" }).Count

    `$md = @()
    `$md += "# PHASE 13.0A Live Monitor"
    `$md += ""
    `$md += "- Last Updated: `$((Get-Date).ToString("yyyy-MM-dd HH:mm:ss"))"
    `$md += "- OK: `$okCount"
    `$md += "- WARN: `$warnCount"
    `$md += "- Project Root: `$ProjectRoot"
    `$md += ""
    `$md += "## Endpoint Status"
    `$md += ""
    foreach (`$r in `$results) {
        `$md += "- `$(`$r.Status) | `$(`$r.Url) | `$(`$r.StatusCode) | `$(`$r.Ms)ms | `$(`$r.Error)"
    }

    Set-Content -LiteralPath `$MdPath -Value `$md -Encoding UTF8

    Start-Sleep -Seconds `$IntervalSeconds
}
"@

    Write-Utf8NoBom -Path $MonitorScriptPath -Text $MonitorText

    Add-LiveStatus "Live monitor script created: $MonitorScriptPath"

    $RunReport = [pscustomobject]@{
        phase = $PhaseName
        timestamp = $Timestamp
        project_root = $ProjectRoot
        phase_root = $PhaseRoot
        mode = $(if ($Apply) { "APPLIED" } else { "AUDIT_ONLY" })
        source_files_scanned = $SourceFiles.Count
        target_files_found = $TargetFileRows.Count
        replacement_rows = $ReplacementRows.Count
        changed_files = $ChangedFiles.Count
        rollback_script = $RollbackPath
        live_status = $LiveStatusPath
        monitor_script = $MonitorScriptPath
        build_exit_code = $BuildExitCode
        target_files_csv = $TargetFilesPath
        replacement_report_csv = $ReplacementReportPath
        anchor_report_csv = $AnchorReportPath
        endpoint_probe_csv = $ProbePath
        next_phase_prompt = $NextPhasePromptPath
        next_phase_blueprint = $NextPhaseBlueprintPath
    }

    $RunReportPath = Join-Path $PhaseRoot "07_LIVE_MONITORING\$PhaseName-RUN-REPORT.json"
    $RunReport | ConvertTo-Json -Depth 10 | Set-Content -LiteralPath $RunReportPath -Encoding UTF8

    Add-LiveStatus "Run report created: $RunReportPath"

    Add-Content -LiteralPath $LiveStatusPath -Encoding UTF8 -Value @(
        "",
        "## Key Output Files",
        "",
        "- README: $ReadmePath",
        "- Parameters: $ParametersJsonPath",
        "- Change Matrix: $ChangeMatrixPath",
        "- Target Files: $TargetFilesPath",
        "- Replacement Report: $ReplacementReportPath",
        "- Field Anchor Report: $AnchorReportPath",
        "- Changed Files: $ChangedFilesPath",
        "- Rollback Script: $RollbackPath",
        "- Build Log: $BuildLogPath",
        "- Endpoint Probe: $ProbePath",
        "- Next Phase Prompt: $NextPhasePromptPath",
        "- Phase 13.0B Blueprint: $NextPhaseBlueprintPath",
        ""
    )

    if ($StartLiveMonitor) {
        Add-LiveStatus "Starting live monitor in separate PowerShell window."
        Start-Process -FilePath "powershell.exe" -ArgumentList @(
            "-NoExit",
            "-ExecutionPolicy", "Bypass",
            "-File", "`"$MonitorScriptPath`"",
            "-IntervalSeconds", "15"
        )
    }

    Write-Host ""
    Write-Host "============================================================" -ForegroundColor Cyan
    Write-Host "PHASE 13.0A COMPLETED" -ForegroundColor Green
    Write-Host "============================================================" -ForegroundColor Cyan
    Write-Host "Mode: $(if ($Apply) { "APPLIED SAFE PATCH" } else { "AUDIT ONLY" })"
    Write-Host "Phase Root: $PhaseRoot"
    Write-Host "Live Status: $LiveStatusPath"
    Write-Host "Target Files: $TargetFilesPath"
    Write-Host "Replacement Report: $ReplacementReportPath"
    Write-Host "Field Anchor Report: $AnchorReportPath"
    Write-Host "Rollback Script: $RollbackPath"
    Write-Host "Next Phase Prompt: $NextPhasePromptPath"
    Write-Host "============================================================"
    Write-Host ""
}
catch {
    Add-LiveStatus "ERROR: $($_.Exception.Message)"
    Write-Host ""
    Write-Host "PHASE 13.0A ERROR:" -ForegroundColor Red
    Write-Host $_.Exception.Message -ForegroundColor Yellow
    Write-Host ""
}
finally {
    Stop-Transcript | Out-Null
}
