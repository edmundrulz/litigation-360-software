# ============================================================
# LITIGATION 360 LEOS
# PHASE 12.0F V2 EXACT ROUTE / API / DB VERIFICATION
#
# FIXES:
#   1. Fixes earlier "Argument types do not match" issue.
#   2. Fixes Join-Path array/comma issue near SourceRoots.
#
# SAFE MODE:
#   - DOES NOT delete
#   - DOES NOT rename
#   - DOES NOT move files
#   - DOES NOT modify source code
#   - DOES NOT modify database
#   - DOES NOT unlock production
#   - DOES NOT start Phase 11
# ============================================================

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$DeclaredProjectRoot = "C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software"

function Write-Step {
    param([string]$Message)
    Write-Host "[PHASE 12.0F V2] $Message" -ForegroundColor Cyan
}

function Write-Pass {
    param([string]$Message)
    Write-Host "[PASS] $Message" -ForegroundColor Green
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

function Read-File-Safe {
    param([string]$Path)

    if (Test-Path -LiteralPath $Path -PathType Leaf) {
        try {
            return [System.IO.File]::ReadAllText($Path)
        }
        catch {
            return ""
        }
    }

    return ""
}

function Get-Relative {
    param([string]$FullPath)

    if ($FullPath.StartsWith($ProjectRoot)) {
        return $FullPath.Substring($ProjectRoot.Length).TrimStart("\")
    }

    return $FullPath
}

function Is-Safe-Source-File {
    param([System.IO.FileInfo]$File)

    $p = $File.FullName.ToLower()
    $n = $File.Name.ToLower()

    if ($p -match "\\node_modules\\") { return $false }
    if ($p -match "\\_leos_control\\") { return $false }
    if ($p -match "\\\.git\\") { return $false }
    if ($p -match "\\snapshots\\") { return $false }
    if ($p -match "\\backups?\\") { return $false }
    if ($p -match "\\archive\\") { return $false }
    if ($p -match "\\dist\\") { return $false }
    if ($p -match "\\build\\") { return $false }
    if ($p -match "\\coverage\\") { return $false }
    if ($p -match "\\reports\\") { return $false }

    if ($n -match "backup") { return $false }
    if ($n -match "doctor-backup") { return $false }
    if ($n -match "\.bak") { return $false }

    return $true
}

function Get-Source-Files {
    param(
        [string]$BasePath,
        [string[]]$Extensions
    )

    $rows = @()

    if (!(Test-Path -LiteralPath $BasePath -PathType Container)) {
        return $rows
    }

    $files = Get-ChildItem -LiteralPath $BasePath -Recurse -File -Force -ErrorAction SilentlyContinue

    foreach ($file in $files) {
        if (($Extensions -contains $file.Extension.ToLower()) -and (Is-Safe-Source-File $file)) {
            $rows += $file
        }
    }

    return $rows
}

function Find-In-Files {
    param(
        [string]$BasePath,
        [string[]]$Extensions,
        [string[]]$Patterns
    )

    $rows = @()
    $files = Get-Source-Files -BasePath $BasePath -Extensions $Extensions

    foreach ($file in $files) {
        $content = Read-File-Safe $file.FullName

        if ([string]::IsNullOrWhiteSpace($content)) {
            continue
        }

        foreach ($pattern in $Patterns) {
            try {
                $matches = [regex]::Matches($content, $pattern)
            }
            catch {
                continue
            }

            foreach ($match in $matches) {
                $lineNumber = 1

                try {
                    if ($match.Index -gt 0) {
                        $lineNumber = ($content.Substring(0, $match.Index).Split("`n")).Count
                    }
                }
                catch {
                    $lineNumber = 0
                }

                $snippet = [string]$match.Value
                if ($snippet.Length -gt 220) {
                    $snippet = $snippet.Substring(0, 220)
                }

                $rows += [PSCustomObject]@{
                    File = Get-Relative $file.FullName
                    Pattern = $pattern
                    Line = $lineNumber
                    Match = $snippet
                }
            }
        }
    }

    return $rows
}

function Test-File-Row {
    param([string]$RelativePath)

    $FullPath = Join-Path $ProjectRoot $RelativePath

    return [PSCustomObject]@{
        RelativePath = $RelativePath
        FullPath = $FullPath
        Exists = Test-Path -LiteralPath $FullPath -PathType Leaf
    }
}

function Any-File-Exists-ByName {
    param(
        [object[]]$FileRows,
        [string[]]$Names
    )

    if ($Names.Count -eq 0) {
        return "NOT REQUIRED / NOT CHECKED"
    }

    foreach ($name in $Names) {
        $found = $FileRows | Where-Object {
            $_.Exists -eq $true -and $_.RelativePath.ToLower().EndsWith($name.ToLower())
        }

        if (@($found).Count -gt 0) {
            return "YES"
        }
    }

    # Fixed SourceRoots construction: each Join-Path is separate.
    $SourceRoots = @()
    $SourceRoots += (Join-Path $ProjectRoot "frontend\src")
    $SourceRoots += (Join-Path $ProjectRoot "backend\src")
    $SourceRoots += (Join-Path $ProjectRoot "backend\routes")
    $SourceRoots += (Join-Path $ProjectRoot "backend\middleware")
    $SourceRoots += (Join-Path $ProjectRoot "backend\models")

    foreach ($root in $SourceRoots) {
        if (!(Test-Path -LiteralPath $root -PathType Container)) {
            continue
        }

        foreach ($name in $Names) {
            $scanFound = Get-ChildItem -LiteralPath $root -Recurse -File -ErrorAction SilentlyContinue |
                Where-Object {
                    (Is-Safe-Source-File $_) -and
                    $_.Name.ToLower() -eq $name.ToLower()
                } |
                Select-Object -First 1

            if ($null -ne $scanFound) {
                return "YES"
            }
        }
    }

    return "NO"
}

function Any-Text-Match {
    param(
        [object[]]$Rows,
        [string[]]$Keywords
    )

    if ($Keywords.Count -eq 0) {
        return "NOT REQUIRED / NOT CHECKED"
    }

    foreach ($row in $Rows) {
        $combined = (($row.File + " " + $row.Match) -as [string]).ToLower()

        foreach ($keyword in $Keywords) {
            if ($combined.Contains($keyword.ToLower())) {
                return "YES"
            }
        }
    }

    return "NO"
}

# ------------------------------------------------------------
# 1. RESOLVE ROOTS
# ------------------------------------------------------------
Write-Step "Resolving project root..."

if (Test-Path -LiteralPath $DeclaredProjectRoot -PathType Container) {
    $ProjectRoot = $DeclaredProjectRoot
}
else {
    $ProjectRoot = (Get-Location).Path
}

Set-Location -LiteralPath $ProjectRoot

$ControlRoot = Join-Path $ProjectRoot "_LEOS_CONTROL"
$VerificationRoot = Join-Path $ControlRoot "feature-exploration\verification"
$ReportRoot = Join-Path $ControlRoot "reports"

New-Item -ItemType Directory -Path $VerificationRoot -Force | Out-Null
New-Item -ItemType Directory -Path $ReportRoot -Force | Out-Null

Write-Pass "Project root:"
Write-Host $ProjectRoot -ForegroundColor Green

# ------------------------------------------------------------
# 2. EXACT EXPECTED FILE CHECK
# ------------------------------------------------------------
Write-Step "Checking exact expected P0/P1 files..."

$ExpectedFiles = @(
    "frontend\src\App.jsx",
    "frontend\src\App.tsx",
    "frontend\src\main.jsx",
    "frontend\src\main.tsx",
    "frontend\src\api.js",
    "frontend\src\pages\Clients.jsx",
    "frontend\src\services\clientService.js",
    "frontend\src\pages\Cases.jsx",
    "frontend\src\pages\MatterIntakeWizard.jsx",
    "frontend\src\pages\Deadlines.jsx",
    "frontend\src\pages\Documents.jsx",
    "frontend\src\pages\Dashboard.jsx",
    "frontend\src\config\featureAccess.js",
    "backend\server.js",
    "backend\app.js",
    "server.js",
    "app.js",
    "backend\src\middleware\auth.js",
    "backend\src\middleware\roleMiddleware.js",
    "backend\src\routes\auditLogs.js",
    "backend\src\utils\auditLogger.js",
    "backend\middleware\adminAudit.js",
    "backend\src\routes\clients.js",
    "backend\src\models\Client.js",
    "backend\src\routes\clientIdentity.js",
    "backend\src\routes\matters.js",
    "backend\src\models\Matter.js",
    "backend\src\matterService.js",
    "backend\src\routes\deadlines.js",
    "backend\src\routes\courtDeadline.js",
    "backend\src\routes\documents.js",
    "backend\src\routes\documentLifecycleRoutes.js",
    "backend\src\models\Document.js",
    "backend\src\routes\courtNavigationRoutes.js",
    "backend\src\automation\courtOperationsEngine.js",
    "backend\src\automation\courtNavigationEngine.js",
    "litigation360.db",
    "backend\litigation360.db",
    "backend\src\migrations\005_create_matters.js",
    "backend\src\migrations\023_create_roles_permissions.sql"
)

$FileCheckRows = @()
foreach ($relative in $ExpectedFiles) {
    $FileCheckRows += (Test-File-Row $relative)
}

$FileCheckPath = Join-Path $VerificationRoot "PHASE-12.0F-V2-EXACT-FILE-CHECK.csv"
$FileCheckRows | Export-Csv -Path $FileCheckPath -NoTypeInformation -Encoding UTF8

# ------------------------------------------------------------
# 3. EXTRACT FRONTEND ROUTE-LIKE REFERENCES
# ------------------------------------------------------------
Write-Step "Extracting frontend route-like references..."

$FrontendBase = Join-Path $ProjectRoot "frontend\src"

$FrontendPatterns = @(
    '<Route\s+[^>]*path\s*=\s*["''][^"'']+["''][^>]*>',
    'path\s*:\s*["''][^"'']+["'']',
    'navigate\(\s*["''][^"'']+["'']',
    'to\s*=\s*["''][^"'']+["'']'
)

$FrontendRouteRows = @(Find-In-Files -BasePath $FrontendBase -Extensions @(".js",".jsx",".ts",".tsx") -Patterns $FrontendPatterns)
$FrontendRoutePath = Join-Path $VerificationRoot "PHASE-12.0F-V2-FRONTEND-ROUTE-CANDIDATES.csv"
$FrontendRouteRows | Export-Csv -Path $FrontendRoutePath -NoTypeInformation -Encoding UTF8

# ------------------------------------------------------------
# 4. EXTRACT FRONTEND API CALLS
# ------------------------------------------------------------
Write-Step "Extracting frontend API/service calls..."

$ApiCallPatterns = @(
    'api\.(get|post|put|patch|delete)\(\s*["''][^"'']+["'']',
    'axios\.(get|post|put|patch|delete)\(\s*["''][^"'']+["'']',
    'fetch\(\s*["''][^"'']+["'']'
)

$ApiCallRows = @(Find-In-Files -BasePath $FrontendBase -Extensions @(".js",".jsx",".ts",".tsx") -Patterns $ApiCallPatterns)
$ApiCallPath = Join-Path $VerificationRoot "PHASE-12.0F-V2-FRONTEND-API-CALL-CANDIDATES.csv"
$ApiCallRows | Export-Csv -Path $ApiCallPath -NoTypeInformation -Encoding UTF8

# ------------------------------------------------------------
# 5. EXTRACT BACKEND ROUTE DEFINITIONS
# ------------------------------------------------------------
Write-Step "Extracting backend route definitions..."

$BackendBase = Join-Path $ProjectRoot "backend"

$BackendRoutePatterns = @(
    'router\.(get|post|put|patch|delete)\(\s*["''][^"'']+["'']',
    'app\.(get|post|put|patch|delete)\(\s*["''][^"'']+["'']',
    'express\.Router\(\)',
    'module\.exports\s*=\s*router',
    'export\s+default\s+router'
)

$BackendRouteRows = @(Find-In-Files -BasePath $BackendBase -Extensions @(".js",".ts") -Patterns $BackendRoutePatterns)
$BackendRoutePath = Join-Path $VerificationRoot "PHASE-12.0F-V2-BACKEND-ROUTE-DEFINITIONS.csv"
$BackendRouteRows | Export-Csv -Path $BackendRoutePath -NoTypeInformation -Encoding UTF8

# ------------------------------------------------------------
# 6. EXTRACT BACKEND ROUTE MOUNTS
# ------------------------------------------------------------
Write-Step "Extracting backend route mounts/app.use registrations..."

$MountPatterns = @(
    'app\.use\(\s*["''][^"'']+["'']\s*,',
    'router\.use\(\s*["''][^"'']+["'']\s*,',
    'require\(\s*["''][^"'']*routes[^"'']*["'']\s*\)',
    'import\s+.*from\s+["''][^"'']*routes[^"'']*["'']'
)

$RouteMountRows = @(Find-In-Files -BasePath $BackendBase -Extensions @(".js",".ts") -Patterns $MountPatterns)
$RouteMountPath = Join-Path $VerificationRoot "PHASE-12.0F-V2-BACKEND-ROUTE-MOUNTS.csv"
$RouteMountRows | Export-Csv -Path $RouteMountPath -NoTypeInformation -Encoding UTF8

# ------------------------------------------------------------
# 7. EXTRACT DATABASE / MODEL SIGNALS
# ------------------------------------------------------------
Write-Step "Extracting model/migration/database signals..."

$DatabasePatterns = @(
    'CREATE\s+TABLE\s+[^;]+',
    'knex\.schema\.createTable\(\s*["''][^"'']+["'']',
    'sequelize\.define\(\s*["''][^"'']+["'']',
    'class\s+\w+\s+extends\s+Model',
    'module\.exports\s*=',
    'export\s+default'
)

$DbRows = @()

$DatabaseBase1 = Join-Path $ProjectRoot "backend\src\models"
$DatabaseBase2 = Join-Path $ProjectRoot "backend\src\migrations"

$DbRows += @(Find-In-Files -BasePath $DatabaseBase1 -Extensions @(".js",".ts",".sql") -Patterns $DatabasePatterns)
$DbRows += @(Find-In-Files -BasePath $DatabaseBase2 -Extensions @(".js",".ts",".sql") -Patterns $DatabasePatterns)

$DbPath = Join-Path $VerificationRoot "PHASE-12.0F-V2-DATABASE-MODEL-MIGRATION-SIGNALS.csv"
$DbRows | Export-Csv -Path $DbPath -NoTypeInformation -Encoding UTF8

# ------------------------------------------------------------
# 8. FEATURE DECISION MATRIX
# ------------------------------------------------------------
Write-Step "Creating feature verification decision matrix..."

$Features = @(
    [PSCustomObject]@{
        Priority="P0"; Feature="Authentication";
        FrontendNeed=@("api.js");
        BackendNeed=@("auth.js");
        DbNeed=@();
        ApiKeywords=@("/auth","/login","/logout","/me","token");
        BackendKeywords=@("auth","login","jwt","token","session")
    },
    [PSCustomObject]@{
        Priority="P0"; Feature="RBAC";
        FrontendNeed=@("featureAccess.js");
        BackendNeed=@("roleMiddleware.js");
        DbNeed=@("roles","permissions");
        ApiKeywords=@("role","permission","access");
        BackendKeywords=@("role","permission","rbac","access")
    },
    [PSCustomObject]@{
        Priority="P0"; Feature="Audit Logging";
        FrontendNeed=@();
        BackendNeed=@("auditLogs.js","auditLogger.js","adminAudit.js");
        DbNeed=@("audit");
        ApiKeywords=@("audit");
        BackendKeywords=@("audit","auditlogs","activity")
    },
    [PSCustomObject]@{
        Priority="P1"; Feature="Workspace";
        FrontendNeed=@("App.jsx","App.tsx","Dashboard.jsx");
        BackendNeed=@("dashboard.js");
        DbNeed=@();
        ApiKeywords=@("/dashboard","/health","/status");
        BackendKeywords=@("dashboard","health","status")
    },
    [PSCustomObject]@{
        Priority="P1"; Feature="Clients";
        FrontendNeed=@("Clients.jsx","clientService.js");
        BackendNeed=@("clients.js","Client.js");
        DbNeed=@("Client.js","clients");
        ApiKeywords=@("/clients","client");
        BackendKeywords=@("clients","client")
    },
    [PSCustomObject]@{
        Priority="P1"; Feature="Matters";
        FrontendNeed=@("Cases.jsx","MatterIntakeWizard.jsx");
        BackendNeed=@("matters.js","Matter.js","matterService.js");
        DbNeed=@("Matter.js","matters");
        ApiKeywords=@("/matters","/cases","matter","case");
        BackendKeywords=@("matters","matter","cases","case")
    },
    [PSCustomObject]@{
        Priority="P1"; Feature="Deadlines";
        FrontendNeed=@("Deadlines.jsx");
        BackendNeed=@("deadlines.js","courtDeadline.js");
        DbNeed=@("deadline","deadlines");
        ApiKeywords=@("/deadlines","deadline");
        BackendKeywords=@("deadlines","deadline","courtDeadline")
    },
    [PSCustomObject]@{
        Priority="P1"; Feature="Documents";
        FrontendNeed=@("Documents.jsx");
        BackendNeed=@("documents.js","documentLifecycleRoutes.js","Document.js");
        DbNeed=@("Document.js","documents");
        ApiKeywords=@("/documents","document");
        BackendKeywords=@("documents","document")
    },
    [PSCustomObject]@{
        Priority="P1"; Feature="Court Dates";
        FrontendNeed=@("CourtDates.jsx","Court.jsx","Calendar.jsx");
        BackendNeed=@("courtNavigationRoutes.js","courtDeadline.js","courtOperationsEngine.js");
        DbNeed=@("court","hearing");
        ApiKeywords=@("/court","/hearings","court","hearing");
        BackendKeywords=@("court","hearing")
    }
)

$DecisionRows = @()

foreach ($feature in $Features) {
    $FrontendFileEvidence = Any-File-Exists-ByName -FileRows $FileCheckRows -Names $feature.FrontendNeed
    $BackendFileEvidence = Any-File-Exists-ByName -FileRows $FileCheckRows -Names $feature.BackendNeed
    $DbEvidence = Any-Text-Match -Rows $DbRows -Keywords $feature.DbNeed
    $FrontendApiEvidence = Any-Text-Match -Rows $ApiCallRows -Keywords $feature.ApiKeywords
    $BackendRouteEvidence = Any-Text-Match -Rows $BackendRouteRows -Keywords $feature.BackendKeywords
    $BackendMountEvidence = Any-Text-Match -Rows $RouteMountRows -Keywords $feature.BackendKeywords

    $LabStatus = "NOT READY"

    if (
        $FrontendFileEvidence -eq "YES" -and
        $BackendFileEvidence -eq "YES" -and
        ($BackendRouteEvidence -eq "YES" -or $BackendMountEvidence -eq "YES")
    ) {
        $LabStatus = "LAB VERIFY CANDIDATE"
    }

    if (
        $feature.Feature -eq "Audit Logging" -and
        $BackendFileEvidence -eq "YES" -and
        ($BackendRouteEvidence -eq "YES" -or $BackendMountEvidence -eq "YES")
    ) {
        $LabStatus = "BACKEND FOUNDATION VERIFY CANDIDATE"
    }

    if ($feature.Feature -eq "Court Dates" -and $FrontendFileEvidence -ne "YES") {
        $LabStatus = "BACKEND ONLY - NEED FRONTEND PAGE/ROUTE"
    }

    $DecisionRows += [PSCustomObject]@{
        Priority = $feature.Priority
        Feature = $feature.Feature
        FrontendFileEvidence = $FrontendFileEvidence
        FrontendApiCallEvidence = $FrontendApiEvidence
        BackendFileEvidence = $BackendFileEvidence
        BackendRouteDefinitionEvidence = $BackendRouteEvidence
        BackendRouteMountEvidence = $BackendMountEvidence
        DatabaseModelOrMigrationEvidence = $DbEvidence
        LabStatus = $LabStatus
        ProductionUnlockAllowed = "NO"
        RequiredBeforeProductionUnlock = "Manual browser test; API smoke test; auth/RBAC check; audit check; data write/read test; rollback plan; approval"
    }
}

$DecisionPath = Join-Path $VerificationRoot "PHASE-12.0F-V2-FEATURE-VERIFICATION-DECISION-MATRIX.csv"
$DecisionRows | Export-Csv -Path $DecisionPath -NoTypeInformation -Encoding UTF8

# ------------------------------------------------------------
# 9. CREATE REPORT
# ------------------------------------------------------------
$Report = New-Object System.Collections.Generic.List[string]

$Report.Add("# PHASE 12.0F V2 EXACT ROUTE / API / DB VERIFICATION REPORT") | Out-Null
$Report.Add("") | Out-Null
$Report.Add("Generated: $(Get-Date -Format "yyyy-MM-dd HH:mm:ss")") | Out-Null
$Report.Add("") | Out-Null
$Report.Add("Project Root:") | Out-Null
$Report.Add($ProjectRoot) | Out-Null
$Report.Add("") | Out-Null
$Report.Add("## Safety Confirmation") | Out-Null
$Report.Add("") | Out-Null
$Report.Add("No files were deleted.") | Out-Null
$Report.Add("No files were renamed.") | Out-Null
$Report.Add("No files were moved.") | Out-Null
$Report.Add("No source code was modified.") | Out-Null
$Report.Add("No database was modified.") | Out-Null
$Report.Add("No production features were unlocked.") | Out-Null
$Report.Add("No Phase 11 work was started.") | Out-Null
$Report.Add("") | Out-Null
$Report.Add("## Verification Summary") | Out-Null
$Report.Add("") | Out-Null
$Report.Add("Frontend route references found: $(@($FrontendRouteRows).Count)") | Out-Null
$Report.Add("Frontend API/service calls found: $(@($ApiCallRows).Count)") | Out-Null
$Report.Add("Backend route definitions found: $(@($BackendRouteRows).Count)") | Out-Null
$Report.Add("Backend route mounts found: $(@($RouteMountRows).Count)") | Out-Null
$Report.Add("Database/model/migration signals found: $(@($DbRows).Count)") | Out-Null
$Report.Add("") | Out-Null
$Report.Add("## Feature Decision Matrix") | Out-Null
$Report.Add("") | Out-Null

foreach ($row in $DecisionRows) {
    $Report.Add("### $($row.Priority) - $($row.Feature)") | Out-Null
    $Report.Add("Frontend file evidence: $($row.FrontendFileEvidence)") | Out-Null
    $Report.Add("Frontend API call evidence: $($row.FrontendApiCallEvidence)") | Out-Null
    $Report.Add("Backend file evidence: $($row.BackendFileEvidence)") | Out-Null
    $Report.Add("Backend route definition evidence: $($row.BackendRouteDefinitionEvidence)") | Out-Null
    $Report.Add("Backend route mount evidence: $($row.BackendRouteMountEvidence)") | Out-Null
    $Report.Add("Database/model/migration evidence: $($row.DatabaseModelOrMigrationEvidence)") | Out-Null
    $Report.Add("Lab status: $($row.LabStatus)") | Out-Null
    $Report.Add("Production unlock allowed: $($row.ProductionUnlockAllowed)") | Out-Null
    $Report.Add("") | Out-Null
}

$Report.Add("## Files Created") | Out-Null
$Report.Add("") | Out-Null
$Report.Add("- _LEOS_CONTROL\feature-exploration\verification\PHASE-12.0F-V2-EXACT-FILE-CHECK.csv") | Out-Null
$Report.Add("- _LEOS_CONTROL\feature-exploration\verification\PHASE-12.0F-V2-FRONTEND-ROUTE-CANDIDATES.csv") | Out-Null
$Report.Add("- _LEOS_CONTROL\feature-exploration\verification\PHASE-12.0F-V2-FRONTEND-API-CALL-CANDIDATES.csv") | Out-Null
$Report.Add("- _LEOS_CONTROL\feature-exploration\verification\PHASE-12.0F-V2-BACKEND-ROUTE-DEFINITIONS.csv") | Out-Null
$Report.Add("- _LEOS_CONTROL\feature-exploration\verification\PHASE-12.0F-V2-BACKEND-ROUTE-MOUNTS.csv") | Out-Null
$Report.Add("- _LEOS_CONTROL\feature-exploration\verification\PHASE-12.0F-V2-DATABASE-MODEL-MIGRATION-SIGNALS.csv") | Out-Null
$Report.Add("- _LEOS_CONTROL\feature-exploration\verification\PHASE-12.0F-V2-FEATURE-VERIFICATION-DECISION-MATRIX.csv") | Out-Null
$Report.Add("") | Out-Null
$Report.Add("## Next Safe Step") | Out-Null
$Report.Add("") | Out-Null
$Report.Add("If Clients, Matters, Deadlines and Documents show LAB VERIFY CANDIDATE, proceed to Phase 12.0G manual browser/API smoke test commands.") | Out-Null
$Report.Add("") | Out-Null
$Report.Add("If a feature shows NOT READY, do not connect or unlock it yet.") | Out-Null

$ReportPath = Join-Path $ReportRoot "PHASE-12.0F-V2-EXACT-ROUTE-API-DB-VERIFICATION-REPORT.md"
Save-Text -Path $ReportPath -Content ($Report -join "`r`n")

Write-Host ""
Write-Pass "PHASE 12.0F V2 EXACT ROUTE / API / DB VERIFICATION COMPLETE"
Write-Host ""
Write-Host "Open report:" -ForegroundColor Cyan
Write-Host "notepad `"_LEOS_CONTROL\reports\PHASE-12.0F-V2-EXACT-ROUTE-API-DB-VERIFICATION-REPORT.md`""
Write-Host ""
Write-Host "Open decision matrix:" -ForegroundColor Cyan
Write-Host "notepad `"_LEOS_CONTROL\feature-exploration\verification\PHASE-12.0F-V2-FEATURE-VERIFICATION-DECISION-MATRIX.csv`""
Write-Host ""
Write-Pass "Paste the report back into ChatGPT."
