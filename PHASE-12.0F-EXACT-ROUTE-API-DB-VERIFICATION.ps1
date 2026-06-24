# ============================================================
# LITIGATION 360 LEOS
# PHASE 12.0F EXACT ROUTE / API / DB VERIFICATION
#
# PURPOSE:
#   Verify the P0 foundation and P1 core workflow using exact source files:
#   - frontend pages
#   - frontend API/service calls
#   - backend route files
#   - backend route registration / app mounting
#   - backend models / migrations
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
    Write-Host "[PHASE 12.0F] $Message" -ForegroundColor Cyan
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

function Test-File {
    param([string]$RelativePath)

    $FullPath = Join-Path $ProjectRoot $RelativePath

    [PSCustomObject]@{
        RelativePath = $RelativePath
        FullPath = $FullPath
        Exists = Test-Path -LiteralPath $FullPath -PathType Leaf
    }
}

function Find-In-Files {
    param(
        [string]$BasePath,
        [string[]]$Extensions,
        [string[]]$Patterns,
        [string[]]$ExcludeNamePatterns = @("backup", "BACKUP", "doctor-backup", ".bak")
    )

    $Results = New-Object System.Collections.Generic.List[object]

    if (!(Test-Path -LiteralPath $BasePath -PathType Container)) {
        return @()
    }

    $Files = Get-ChildItem -LiteralPath $BasePath -Recurse -File -Force -ErrorAction SilentlyContinue |
        Where-Object {
            $ext = $_.Extension.ToLower()
            ($Extensions -contains $ext) -and
            ($_.FullName -notmatch "\\node_modules\\") -and
            ($_.FullName -notmatch "\\_LEOS_CONTROL\\") -and
            ($_.FullName -notmatch "\\snapshots\\") -and
            ($_.FullName -notmatch "\\backups?\\") -and
            ($_.FullName -notmatch "\\archive\\") -and
            ($_.Name -notmatch "backup") -and
            ($_.Name -notmatch "BACKUP") -and
            ($_.Name -notmatch "doctor-backup")
        }

    foreach ($File in $Files) {
        $Content = Read-File-Safe $File.FullName
        if ([string]::IsNullOrWhiteSpace($Content)) {
            continue
        }

        foreach ($Pattern in $Patterns) {
            $Matches = [regex]::Matches($Content, $Pattern)
            foreach ($Match in $Matches) {
                $LineNumber = 1
                try {
                    $LineNumber = ($Content.Substring(0, $Match.Index).Split("`n")).Count
                }
                catch {
                    $LineNumber = 0
                }

                $Snippet = $Match.Value
                if ($Snippet.Length -gt 220) {
                    $Snippet = $Snippet.Substring(0,220)
                }

                $Results.Add([PSCustomObject]@{
                    File = Get-Relative $File.FullName
                    Pattern = $Pattern
                    Line = $LineNumber
                    Match = $Snippet
                }) | Out-Null
            }
        }
    }

    return @($Results)
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
    # Frontend core
    "frontend\src\App.jsx",
    "frontend\src\App.tsx",
    "frontend\src\main.jsx",
    "frontend\src\main.tsx",
    "frontend\src\api.js",

    # P1 pages and services
    "frontend\src\pages\Clients.jsx",
    "frontend\src\services\clientService.js",
    "frontend\src\pages\Cases.jsx",
    "frontend\src\pages\MatterIntakeWizard.jsx",
    "frontend\src\pages\Deadlines.jsx",
    "frontend\src\pages\Documents.jsx",
    "frontend\src\pages\Dashboard.jsx",

    # P0 frontend config
    "frontend\src\config\featureAccess.js",

    # Backend startup / app
    "backend\server.js",
    "backend\app.js",
    "server.js",
    "app.js",

    # P0 backend
    "backend\src\middleware\auth.js",
    "backend\src\middleware\roleMiddleware.js",
    "backend\src\routes\auditLogs.js",
    "backend\src\utils\auditLogger.js",

    # P1 backend routes/models
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

    # DB / migrations
    "litigation360.db",
    "backend\litigation360.db",
    "backend\src\migrations\005_create_matters.js",
    "backend\src\migrations\023_create_roles_permissions.sql"
)

$FileCheckRows = foreach ($Relative in $ExpectedFiles) {
    Test-File $Relative
}

$FileCheckPath = Join-Path $VerificationRoot "PHASE-12.0F-EXACT-FILE-CHECK.csv"
$FileCheckRows | Export-Csv -Path $FileCheckPath -NoTypeInformation -Encoding UTF8

# ------------------------------------------------------------
# 3. EXTRACT FRONTEND ROUTE-LIKE REFERENCES
# ------------------------------------------------------------
Write-Step "Extracting frontend route-like references..."

$FrontendBase = Join-Path $ProjectRoot "frontend\src"
$FrontendPatterns = @(
    "<Route\s+[^>]*path\s*=\s*[""'][^""']+[""'][^>]*>",
    "path\s*:\s*[""'][^""']+[""']",
    "navigate\(\s*[""'][^""']+[""']",
    "to\s*=\s*[""'][^""']+[""']"
)

$FrontendRouteRows = Find-In-Files -BasePath $FrontendBase -Extensions @(".js",".jsx",".ts",".tsx") -Patterns $FrontendPatterns
$FrontendRoutePath = Join-Path $VerificationRoot "PHASE-12.0F-FRONTEND-ROUTE-CANDIDATES.csv"
$FrontendRouteRows | Export-Csv -Path $FrontendRoutePath -NoTypeInformation -Encoding UTF8

# ------------------------------------------------------------
# 4. EXTRACT FRONTEND API CALLS
# ------------------------------------------------------------
Write-Step "Extracting frontend API/service calls..."

$ApiCallPatterns = @(
    "api\.(get|post|put|patch|delete)\(\s*[""'][^""']+[""']",
    "axios\.(get|post|put|patch|delete)\(\s*[""'][^""']+[""']",
    "fetch\(\s*[""'][^""']+[""']"
)

$ApiCallRows = Find-In-Files -BasePath $FrontendBase -Extensions @(".js",".jsx",".ts",".tsx") -Patterns $ApiCallPatterns
$ApiCallPath = Join-Path $VerificationRoot "PHASE-12.0F-FRONTEND-API-CALL-CANDIDATES.csv"
$ApiCallRows | Export-Csv -Path $ApiCallPath -NoTypeInformation -Encoding UTF8

# ------------------------------------------------------------
# 5. EXTRACT BACKEND ROUTE DEFINITIONS
# ------------------------------------------------------------
Write-Step "Extracting backend route definitions..."

$BackendBase = Join-Path $ProjectRoot "backend"
$BackendRoutePatterns = @(
    "router\.(get|post|put|patch|delete)\(\s*[""'][^""']+[""']",
    "app\.(get|post|put|patch|delete)\(\s*[""'][^""']+[""']",
    "express\.Router\(\)",
    "module\.exports\s*=\s*router",
    "export\s+default\s+router"
)

$BackendRouteRows = Find-In-Files -BasePath $BackendBase -Extensions @(".js",".ts") -Patterns $BackendRoutePatterns
$BackendRoutePath = Join-Path $VerificationRoot "PHASE-12.0F-BACKEND-ROUTE-DEFINITIONS.csv"
$BackendRouteRows | Export-Csv -Path $BackendRoutePath -NoTypeInformation -Encoding UTF8

# ------------------------------------------------------------
# 6. EXTRACT BACKEND ROUTE MOUNTS
# ------------------------------------------------------------
Write-Step "Extracting backend route mounts/app.use registrations..."

$MountPatterns = @(
    "app\.use\(\s*[""'][^""']+[""']\s*,",
    "router\.use\(\s*[""'][^""']+[""']\s*,",
    "require\(\s*[""'][^""']*routes[^""']*[""']\s*\)",
    "import\s+.*from\s+[""'][^""']*routes[^""']*[""']"
)

$RouteMountRows = Find-In-Files -BasePath $BackendBase -Extensions @(".js",".ts") -Patterns $MountPatterns
$RouteMountPath = Join-Path $VerificationRoot "PHASE-12.0F-BACKEND-ROUTE-MOUNTS.csv"
$RouteMountRows | Export-Csv -Path $RouteMountPath -NoTypeInformation -Encoding UTF8

# ------------------------------------------------------------
# 7. EXTRACT DATABASE / MODEL SIGNALS
# ------------------------------------------------------------
Write-Step "Extracting model/migration/database signals..."

$DatabasePatterns = @(
    "CREATE\s+TABLE\s+[^;]+",
    "knex\.schema\.createTable\(\s*[""'][^""']+[""']",
    "sequelize\.define\(\s*[""'][^""']+[""']",
    "class\s+\w+\s+extends\s+Model",
    "module\.exports\s*=",
    "export\s+default"
)

$DatabaseBase1 = Join-Path $ProjectRoot "backend\src\models"
$DatabaseBase2 = Join-Path $ProjectRoot "backend\src\migrations"

$DbRows1 = Find-In-Files -BasePath $DatabaseBase1 -Extensions @(".js",".ts",".sql") -Patterns $DatabasePatterns
$DbRows2 = Find-In-Files -BasePath $DatabaseBase2 -Extensions @(".js",".ts",".sql") -Patterns $DatabasePatterns
$DbRows = @($DbRows1 + $DbRows2)

$DbPath = Join-Path $VerificationRoot "PHASE-12.0F-DATABASE-MODEL-MIGRATION-SIGNALS.csv"
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

function Any-File-Exists-ByName {
    param([string[]]$Names)

    if ($Names.Count -eq 0) {
        return "NOT REQUIRED / NOT CHECKED"
    }

    foreach ($Name in $Names) {
        $Found = $FileCheckRows | Where-Object {
            $_.Exists -eq $true -and $_.RelativePath.ToLower().EndsWith($Name.ToLower())
        }

        if (@($Found).Count -gt 0) {
            return "YES"
        }

        # Fallback scan active source areas
        $ScanFound = Get-ChildItem -LiteralPath $ProjectRoot -Recurse -File -ErrorAction SilentlyContinue |
            Where-Object {
                $_.FullName -notmatch "\\node_modules\\" -and
                $_.FullName -notmatch "\\_LEOS_CONTROL\\" -and
                $_.FullName -notmatch "\\snapshots\\" -and
                $_.FullName -notmatch "\\backups?\\" -and
                $_.Name -eq $Name
            } |
            Select-Object -First 1

        if ($null -ne $ScanFound) {
            return "YES"
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

    foreach ($Row in $Rows) {
        $Combined = (($Row.File + " " + $Row.Match) -as [string]).ToLower()
        foreach ($Keyword in $Keywords) {
            if ($Combined.Contains($Keyword.ToLower())) {
                return "YES"
            }
        }
    }

    return "NO"
}

$DecisionRows = foreach ($Feature in $Features) {
    $FrontendFileEvidence = Any-File-Exists-ByName -Names $Feature.FrontendNeed
    $BackendFileEvidence = Any-File-Exists-ByName -Names $Feature.BackendNeed
    $DbEvidence = Any-Text-Match -Rows $DbRows -Keywords $Feature.DbNeed
    $FrontendApiEvidence = Any-Text-Match -Rows $ApiCallRows -Keywords $Feature.ApiKeywords
    $BackendRouteEvidence = Any-Text-Match -Rows $BackendRouteRows -Keywords $Feature.BackendKeywords
    $BackendMountEvidence = Any-Text-Match -Rows $RouteMountRows -Keywords $Feature.BackendKeywords

    $LabStatus = "NOT READY"
    if (
        $FrontendFileEvidence -eq "YES" -and
        $BackendFileEvidence -eq "YES" -and
        ($BackendRouteEvidence -eq "YES" -or $BackendMountEvidence -eq "YES")
    ) {
        $LabStatus = "LAB VERIFY CANDIDATE"
    }

    if ($Feature.Feature -eq "Audit Logging" -and $BackendFileEvidence -eq "YES" -and ($BackendRouteEvidence -eq "YES" -or $BackendMountEvidence -eq "YES")) {
        $LabStatus = "BACKEND FOUNDATION VERIFY CANDIDATE"
    }

    if ($Feature.Feature -eq "Court Dates" -and $FrontendFileEvidence -ne "YES") {
        $LabStatus = "BACKEND ONLY - NEED FRONTEND PAGE/ROUTE"
    }

    [PSCustomObject]@{
        Priority = $Feature.Priority
        Feature = $Feature.Feature
        FrontendFileEvidence = $FrontendFileEvidence
        FrontendApiCallEvidence = $FrontendApiEvidence
        BackendFileEvidence = $BackendFileEvidence
        BackendRouteDefinitionEvidence = $BackendRouteEvidence
        BackendRouteMountEvidence = $BackendMountEvidence
        DatabaseModelOrMigrationEvidence = $DbEvidence
        LabStatus = $LabStatus
        ProductionUnlockAllowed = "NO"
        RequiredBeforeProductionUnlock = "Manual route test; auth/RBAC check; audit check; data write/read test; rollback plan; approval"
    }
}

$DecisionPath = Join-Path $VerificationRoot "PHASE-12.0F-FEATURE-VERIFICATION-DECISION-MATRIX.csv"
$DecisionRows | Export-Csv -Path $DecisionPath -NoTypeInformation -Encoding UTF8

# ------------------------------------------------------------
# 9. CREATE REPORT
# ------------------------------------------------------------
$Report = New-Object System.Collections.Generic.List[string]

$Report.Add("# PHASE 12.0F EXACT ROUTE / API / DB VERIFICATION REPORT") | Out-Null
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

foreach ($Row in $DecisionRows) {
    $Report.Add("### $($Row.Priority) - $($Row.Feature)") | Out-Null
    $Report.Add("Frontend file evidence: $($Row.FrontendFileEvidence)") | Out-Null
    $Report.Add("Frontend API call evidence: $($Row.FrontendApiCallEvidence)") | Out-Null
    $Report.Add("Backend file evidence: $($Row.BackendFileEvidence)") | Out-Null
    $Report.Add("Backend route definition evidence: $($Row.BackendRouteDefinitionEvidence)") | Out-Null
    $Report.Add("Backend route mount evidence: $($Row.BackendRouteMountEvidence)") | Out-Null
    $Report.Add("Database/model/migration evidence: $($Row.DatabaseModelOrMigrationEvidence)") | Out-Null
    $Report.Add("Lab status: $($Row.LabStatus)") | Out-Null
    $Report.Add("Production unlock allowed: $($Row.ProductionUnlockAllowed)") | Out-Null
    $Report.Add("") | Out-Null
}

$Report.Add("## Files Created") | Out-Null
$Report.Add("") | Out-Null
$Report.Add("- _LEOS_CONTROL\feature-exploration\verification\PHASE-12.0F-EXACT-FILE-CHECK.csv") | Out-Null
$Report.Add("- _LEOS_CONTROL\feature-exploration\verification\PHASE-12.0F-FRONTEND-ROUTE-CANDIDATES.csv") | Out-Null
$Report.Add("- _LEOS_CONTROL\feature-exploration\verification\PHASE-12.0F-FRONTEND-API-CALL-CANDIDATES.csv") | Out-Null
$Report.Add("- _LEOS_CONTROL\feature-exploration\verification\PHASE-12.0F-BACKEND-ROUTE-DEFINITIONS.csv") | Out-Null
$Report.Add("- _LEOS_CONTROL\feature-exploration\verification\PHASE-12.0F-BACKEND-ROUTE-MOUNTS.csv") | Out-Null
$Report.Add("- _LEOS_CONTROL\feature-exploration\verification\PHASE-12.0F-DATABASE-MODEL-MIGRATION-SIGNALS.csv") | Out-Null
$Report.Add("- _LEOS_CONTROL\feature-exploration\verification\PHASE-12.0F-FEATURE-VERIFICATION-DECISION-MATRIX.csv") | Out-Null
$Report.Add("") | Out-Null
$Report.Add("## Next Safe Step") | Out-Null
$Report.Add("") | Out-Null
$Report.Add("If Clients, Matters, Deadlines and Documents show LAB VERIFY CANDIDATE, proceed to Phase 12.0G: manual browser/API smoke test commands.") | Out-Null
$Report.Add("") | Out-Null
$Report.Add("If a feature shows NOT READY, do not connect or unlock it yet.") | Out-Null

$ReportPath = Join-Path $ReportRoot "PHASE-12.0F-EXACT-ROUTE-API-DB-VERIFICATION-REPORT.md"
Save-Text -Path $ReportPath -Content ($Report -join "`r`n")

Write-Host ""
Write-Pass "PHASE 12.0F EXACT ROUTE / API / DB VERIFICATION COMPLETE"
Write-Host ""
Write-Host "Open report:" -ForegroundColor Cyan
Write-Host "notepad `"_LEOS_CONTROL\reports\PHASE-12.0F-EXACT-ROUTE-API-DB-VERIFICATION-REPORT.md`""
Write-Host ""
Write-Host "Open decision matrix:" -ForegroundColor Cyan
Write-Host "notepad `"_LEOS_CONTROL\feature-exploration\verification\PHASE-12.0F-FEATURE-VERIFICATION-DECISION-MATRIX.csv`""
Write-Host ""
Write-Pass "Paste the report back into ChatGPT."
