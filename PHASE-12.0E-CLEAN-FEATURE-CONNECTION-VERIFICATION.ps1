# ============================================================
# LITIGATION 360 LEOS
# PHASE 12.0E CLEAN FEATURE CONNECTION VERIFICATION
#
# PURPOSE:
#   Clean up the overly broad Phase 12.0D matrix by excluding:
#   - backups
#   - node_modules
#   - _LEOS_CONTROL
#   - generated PHASE scripts
#   - patch / repair / migration helper scripts
#   - docs-only matches
#
# RESULT:
#   Creates a cleaner feature-by-feature review matrix focused on
#   actual frontend/backend/database source candidates.
#
# SAFE MODE:
#   - DOES NOT delete
#   - DOES NOT rename
#   - DOES NOT move
#   - DOES NOT modify source code
#   - DOES NOT modify database
#   - DOES NOT unlock production
# ============================================================

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$DeclaredProjectRoot = "C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software"

function Write-Step {
    param([string]$Message)
    Write-Host "[PHASE 12.0E] $Message" -ForegroundColor Cyan
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

function Import-Csv-Safe {
    param([string]$Path)

    if (Test-Path -LiteralPath $Path) {
        return @(Import-Csv -LiteralPath $Path)
    }

    return @()
}

function Is-ExcludedPath {
    param([string]$Path)

    $p = $Path.ToLower()

    if ($p -match "\\node_modules\\") { return $true }
    if ($p -match "\\_leos_control\\") { return $true }
    if ($p -match "\\\.git\\") { return $true }
    if ($p -match "\\backups?\\") { return $true }
    if ($p -match "\\backup\\") { return $true }
    if ($p -match "\\dist\\") { return $true }
    if ($p -match "\\build\\") { return $true }
    if ($p -match "\\coverage\\") { return $true }
    if ($p -match "\\logs\\") { return $true }
    if ($p -match "\\archive\\") { return $true }
    if ($p -match "\\reports\\") { return $true }

    $name = [System.IO.Path]::GetFileName($Path).ToLower()

    if ($name -match "^phase\d+") { return $true }
    if ($name -match "^patch-") { return $true }
    if ($name -match "^repair-") { return $true }
    if ($name -match "^migrate-") { return $true }
    if ($name -match "^test-") { return $true }
    if ($name -match "smoke") { return $true }
    if ($name -match "governance") { return $true }
    if ($name -match "handover") { return $true }
    if ($name -match "certification") { return $true }

    return $false
}

function Is-FrontendSource {
    param([string]$Path)

    $p = $Path.ToLower()

    if (Is-ExcludedPath $Path) { return $false }

    if ($p -match "\\frontend\\src\\") { return $true }
    if ($p -match "\\src\\") {
        if ($p -notmatch "\\backend\\") { return $true }
    }
    if ($p -match "\\components\\") { return $true }
    if ($p -match "\\pages\\") { return $true }
    if ($p -match "\\views\\") { return $true }
    if ($p -match "\\screens\\") { return $true }

    return $false
}

function Is-BackendSource {
    param([string]$Path)

    $p = $Path.ToLower()

    if (Is-ExcludedPath $Path) { return $false }

    if ($p -match "\\backend\\src\\") { return $true }
    if ($p -match "\\backend\\routes\\") { return $true }
    if ($p -match "\\backend\\controllers\\") { return $true }
    if ($p -match "\\backend\\middleware\\") { return $true }
    if ($p -match "\\backend\\models\\") { return $true }
    if ($p -match "\\routes\\") { return $true }
    if ($p -match "\\controllers\\") { return $true }
    if ($p -match "\\middleware\\") { return $true }
    if ($p -match "\\models\\") { return $true }
    if ($p -match "\\api\\") { return $true }

    return $false
}

function Is-DatabaseSource {
    param([string]$Path)

    $p = $Path.ToLower()

    if (Is-ExcludedPath $Path) { return $false }

    if ($p -match "\\database\\") { return $true }
    if ($p -match "\\db\\") { return $true }
    if ($p -match "\\prisma\\") { return $true }
    if ($p -match "\\migrations\\") { return $true }
    if ($p -match "\\models\\") { return $true }
    if ($p -match "\.db$") { return $true }
    if ($p -match "\.sqlite$") { return $true }
    if ($p -match "\.sqlite3$") { return $true }
    if ($p -match "schema") { return $true }

    return $false
}

function Matches-AnyKeyword {
    param(
        [string]$Text,
        [string[]]$Keywords
    )

    $lower = $Text.ToLower()

    foreach ($k in $Keywords) {
        if ($lower.Contains($k.ToLower())) {
            return $true
        }
    }

    return $false
}

function Count-Rows {
    param(
        [object[]]$Rows,
        [string[]]$Keywords
    )

    $Count = 0

    foreach ($Row in $Rows) {
        $Path = [string]$Row.FullName
        if (Matches-AnyKeyword -Text $Path -Keywords $Keywords) {
            $Count++
        }
    }

    return $Count
}

function Sample-Rows {
    param(
        [object[]]$Rows,
        [string[]]$Keywords,
        [int]$Limit = 8
    )

    $Samples = New-Object System.Collections.Generic.List[string]

    foreach ($Row in $Rows) {
        $Path = [string]$Row.FullName
        if (Matches-AnyKeyword -Text $Path -Keywords $Keywords) {
            $Samples.Add($Path) | Out-Null
        }

        if ($Samples.Count -ge $Limit) {
            break
        }
    }

    return ($Samples -join " | ")
}

# ------------------------------------------------------------
# 1. RESOLVE PROJECT ROOT
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
$DiscoveryRoot = Join-Path $ControlRoot "feature-exploration\discovery"
$MatrixRoot = Join-Path $ControlRoot "feature-exploration\matrix"
$ReportRoot = Join-Path $ControlRoot "reports"
$ReviewRoot = Join-Path $ControlRoot "feature-exploration\review"

New-Item -ItemType Directory -Path $MatrixRoot -Force | Out-Null
New-Item -ItemType Directory -Path $ReportRoot -Force | Out-Null
New-Item -ItemType Directory -Path $ReviewRoot -Force | Out-Null

Write-Pass "Project root:"
Write-Host $ProjectRoot -ForegroundColor Green

# ------------------------------------------------------------
# 2. LOAD AVAILABLE DISCOVERY INVENTORY
# ------------------------------------------------------------
Write-Step "Loading discovery inventories..."

$PrimaryInventory = Join-Path $DiscoveryRoot "PROJECT-FILE-INVENTORY-EXCLUDING-NODEMODULES.csv"
$FastInventory = Join-Path $DiscoveryRoot "PROJECT-FILE-INVENTORY-FAST.csv"
$CodeInventory = Join-Path $DiscoveryRoot "FRONTEND-BACKEND-CODE-CANDIDATES.csv"
$BackendInventory = Join-Path $DiscoveryRoot "BACKEND-CANDIDATE-FILES.csv"
$DatabaseInventory = Join-Path $DiscoveryRoot "DATABASE-CANDIDATE-FILES.csv"
$DocumentationInventory = Join-Path $DiscoveryRoot "DOCUMENTATION-FILES.csv"

if (Test-Path -LiteralPath $PrimaryInventory) {
    $AllRows = Import-Csv-Safe $PrimaryInventory
}
elseif (Test-Path -LiteralPath $FastInventory) {
    $AllRows = Import-Csv-Safe $FastInventory
}
elseif (Test-Path -LiteralPath $CodeInventory) {
    $AllRows = Import-Csv-Safe $CodeInventory
}
else {
    throw "No discovery inventory found. Run Phase 12.0C first."
}

$DocRows = Import-Csv-Safe $DocumentationInventory

Write-Host "Loaded rows: $(@($AllRows).Count)"

# ------------------------------------------------------------
# 3. CLEAN CLASSIFICATION
# ------------------------------------------------------------
Write-Step "Filtering actual source candidates..."

$FrontendRows = @($AllRows | Where-Object { Is-FrontendSource ([string]$_.FullName) })
$BackendRows = @($AllRows | Where-Object { Is-BackendSource ([string]$_.FullName) })
$DatabaseRows = @($AllRows | Where-Object { Is-DatabaseSource ([string]$_.FullName) })

$ExcludedRows = @($AllRows | Where-Object { Is-ExcludedPath ([string]$_.FullName) })

$FrontendRows | Export-Csv -Path (Join-Path $ReviewRoot "CLEAN-FRONTEND-SOURCE-CANDIDATES.csv") -NoTypeInformation -Encoding UTF8
$BackendRows | Export-Csv -Path (Join-Path $ReviewRoot "CLEAN-BACKEND-SOURCE-CANDIDATES.csv") -NoTypeInformation -Encoding UTF8
$DatabaseRows | Export-Csv -Path (Join-Path $ReviewRoot "CLEAN-DATABASE-CANDIDATES.csv") -NoTypeInformation -Encoding UTF8
$ExcludedRows | Export-Csv -Path (Join-Path $ReviewRoot "EXCLUDED-NON-ACTIVE-CANDIDATES.csv") -NoTypeInformation -Encoding UTF8

# ------------------------------------------------------------
# 4. FEATURE DEFINITIONS
# ------------------------------------------------------------
$FeatureDefinitions = @(
    [PSCustomObject]@{ Priority="P1"; Feature="Workspace"; Keywords=@("workspace","home","commandcenter","command-center","dashboard") },
    [PSCustomObject]@{ Priority="P1"; Feature="Clients"; Keywords=@("client","clients") },
    [PSCustomObject]@{ Priority="P1"; Feature="Matters"; Keywords=@("matter","matters","case","cases") },
    [PSCustomObject]@{ Priority="P1"; Feature="Deadlines"; Keywords=@("deadline","deadlines") },
    [PSCustomObject]@{ Priority="P1"; Feature="Documents"; Keywords=@("document","documents") },
    [PSCustomObject]@{ Priority="P1"; Feature="Court Dates"; Keywords=@("court","hearing") },
    [PSCustomObject]@{ Priority="P2"; Feature="Staff"; Keywords=@("staff","employee","team","users") },
    [PSCustomObject]@{ Priority="P2"; Feature="Dashboard / ECC"; Keywords=@("dashboard","ecc","commandcenter","command-center","health","monitor") },
    [PSCustomObject]@{ Priority="P0"; Feature="Authentication"; Keywords=@("auth","login","logout","jwt","session","password") },
    [PSCustomObject]@{ Priority="P0"; Feature="RBAC"; Keywords=@("rbac","role","roles","permission","permissions","access") },
    [PSCustomObject]@{ Priority="P0"; Feature="Audit Logging"; Keywords=@("audit","auditlog","audit-log","activitylog","activity-log") },
    [PSCustomObject]@{ Priority="P2"; Feature="Notifications"; Keywords=@("notification","notifications","alert","alerts") },
    [PSCustomObject]@{ Priority="P2"; Feature="Automation"; Keywords=@("automation","scheduler","workflow","job","cron") },
    [PSCustomObject]@{ Priority="P2"; Feature="Reports"; Keywords=@("report","reports","analytics","export") },
    [PSCustomObject]@{ Priority="P3"; Feature="Client Portal"; Keywords=@("portal","clientportal","client-portal") },
    [PSCustomObject]@{ Priority="P3"; Feature="Communications Hub"; Keywords=@("communication","communications","message","messages","inbox") },
    [PSCustomObject]@{ Priority="P3"; Feature="Finance / Billing"; Keywords=@("finance","billing","invoice","payment","receipt") },
    [PSCustomObject]@{ Priority="P4"; Feature="Knowledge Graph"; Keywords=@("knowledge","graph","ontology") },
    [PSCustomObject]@{ Priority="P4"; Feature="AI Copilot"; Keywords=@("copilot","assistant","llm","openai","legaloperationsassistant") },
    [PSCustomObject]@{ Priority="P4"; Feature="Mobile App"; Keywords=@("mobile","android","ios","reactnative","capacitor") }
)

# ------------------------------------------------------------
# 5. CREATE CLEAN FEATURE MATRIX
# ------------------------------------------------------------
Write-Step "Creating clean feature connection verification matrix..."

$CleanRows = foreach ($Def in $FeatureDefinitions) {
    $FrontendCount = Count-Rows -Rows $FrontendRows -Keywords $Def.Keywords
    $BackendCount = Count-Rows -Rows $BackendRows -Keywords $Def.Keywords
    $DatabaseCount = Count-Rows -Rows $DatabaseRows -Keywords $Def.Keywords
    $DocumentationCount = Count-Rows -Rows $DocRows -Keywords $Def.Keywords

    $FrontendSample = Sample-Rows -Rows $FrontendRows -Keywords $Def.Keywords -Limit 5
    $BackendSample = Sample-Rows -Rows $BackendRows -Keywords $Def.Keywords -Limit 5
    $DatabaseSample = Sample-Rows -Rows $DatabaseRows -Keywords $Def.Keywords -Limit 5

    $CleanStatus = "NOT CONFIRMED"

    if ($FrontendCount -gt 0 -and $BackendCount -gt 0 -and $DatabaseCount -gt 0) {
        $CleanStatus = "SOURCE CANDIDATES FOUND - VERIFY ROUTE/API/DB"
    }
    elseif ($FrontendCount -gt 0 -and $BackendCount -gt 0) {
        $CleanStatus = "FRONTEND + BACKEND FOUND - DB NOT CONFIRMED"
    }
    elseif ($FrontendCount -gt 0 -and $BackendCount -eq 0) {
        $CleanStatus = "FRONTEND ONLY - BACKEND REQUIRED"
    }
    elseif ($FrontendCount -eq 0 -and $BackendCount -gt 0) {
        $CleanStatus = "BACKEND ONLY - FRONTEND REQUIRED"
    }
    elseif ($DocumentationCount -gt 0) {
        $CleanStatus = "DOCUMENTED / PLANNED ONLY"
    }

    $UnlockAdvice = "DO NOT UNLOCK"
    if ($Def.Priority -eq "P1" -and $FrontendCount -gt 0 -and $BackendCount -gt 0) {
        $UnlockAdvice = "VERIFY FIRST - POSSIBLE LAB CONNECTION CANDIDATE"
    }
    elseif ($Def.Priority -eq "P0") {
        $UnlockAdvice = "VERIFY SECURITY FOUNDATION ONLY - DO NOT CHANGE YET"
    }

    [PSCustomObject]@{
        Priority = $Def.Priority
        Feature = $Def.Feature
        CleanStatus = $CleanStatus
        FrontendSourceCandidateCount = $FrontendCount
        BackendSourceCandidateCount = $BackendCount
        DatabaseCandidateCount = $DatabaseCount
        DocumentationCandidateCount = $DocumentationCount
        FrontendSample = $FrontendSample
        BackendSample = $BackendSample
        DatabaseSample = $DatabaseSample
        LabConnectionAllowed = "AFTER MANUAL VERIFICATION ONLY"
        ProductionUnlockAllowed = "NO"
        UnlockAdvice = $UnlockAdvice
        RequiredEvidence = "Exact frontend route; exact backend API; database table/model; RBAC; audit logging; tests; rollback; approval"
    }
}

$CleanMatrixPath = Join-Path $MatrixRoot "PHASE-12.0E-CLEAN-FEATURE-CONNECTION-MATRIX.csv"
$CleanRows | Export-Csv -Path $CleanMatrixPath -NoTypeInformation -Encoding UTF8

# ------------------------------------------------------------
# 6. CREATE HUMAN SUMMARY
# ------------------------------------------------------------
$P1Rows = @($CleanRows | Where-Object { $_.Priority -eq "P1" })
$P0Rows = @($CleanRows | Where-Object { $_.Priority -eq "P0" })

$Summary = New-Object System.Collections.Generic.List[string]

$Summary.Add("# PHASE 12.0E CLEAN FEATURE CONNECTION VERIFICATION REPORT") | Out-Null
$Summary.Add("") | Out-Null
$Summary.Add("Generated: $(Get-Date -Format "yyyy-MM-dd HH:mm:ss")") | Out-Null
$Summary.Add("") | Out-Null
$Summary.Add("Project Root:") | Out-Null
$Summary.Add($ProjectRoot) | Out-Null
$Summary.Add("") | Out-Null
$Summary.Add("## Result") | Out-Null
$Summary.Add("") | Out-Null
$Summary.Add("A cleaner feature matrix was created by excluding backups, generated governance scripts, phase scripts, patch scripts, repair scripts, migration helpers, node_modules, build folders, reports and control folders.") | Out-Null
$Summary.Add("") | Out-Null
$Summary.Add("## Clean Candidate Counts") | Out-Null
$Summary.Add("") | Out-Null
$Summary.Add("Clean frontend source candidates: $(@($FrontendRows).Count)") | Out-Null
$Summary.Add("Clean backend source candidates: $(@($BackendRows).Count)") | Out-Null
$Summary.Add("Clean database candidates: $(@($DatabaseRows).Count)") | Out-Null
$Summary.Add("Excluded non-active candidates: $(@($ExcludedRows).Count)") | Out-Null
$Summary.Add("") | Out-Null
$Summary.Add("## P0 Foundation Items") | Out-Null
$Summary.Add("") | Out-Null

foreach ($Row in $P0Rows) {
    $Summary.Add("### $($Row.Feature)") | Out-Null
    $Summary.Add("Status: $($Row.CleanStatus)") | Out-Null
    $Summary.Add("Frontend source candidates: $($Row.FrontendSourceCandidateCount)") | Out-Null
    $Summary.Add("Backend source candidates: $($Row.BackendSourceCandidateCount)") | Out-Null
    $Summary.Add("Database candidates: $($Row.DatabaseCandidateCount)") | Out-Null
    $Summary.Add("Advice: $($Row.UnlockAdvice)") | Out-Null
    $Summary.Add("") | Out-Null
}

$Summary.Add("## P1 Core Workflow Items") | Out-Null
$Summary.Add("") | Out-Null

foreach ($Row in $P1Rows) {
    $Summary.Add("### $($Row.Feature)") | Out-Null
    $Summary.Add("Status: $($Row.CleanStatus)") | Out-Null
    $Summary.Add("Frontend source candidates: $($Row.FrontendSourceCandidateCount)") | Out-Null
    $Summary.Add("Backend source candidates: $($Row.BackendSourceCandidateCount)") | Out-Null
    $Summary.Add("Database candidates: $($Row.DatabaseCandidateCount)") | Out-Null
    $Summary.Add("Advice: $($Row.UnlockAdvice)") | Out-Null
    if ($Row.FrontendSample -ne "") {
        $Summary.Add("Frontend sample: $($Row.FrontendSample)") | Out-Null
    }
    if ($Row.BackendSample -ne "") {
        $Summary.Add("Backend sample: $($Row.BackendSample)") | Out-Null
    }
    $Summary.Add("") | Out-Null
}

$Summary.Add("## Safe Next Step") | Out-Null
$Summary.Add("") | Out-Null
$Summary.Add("Do not unlock production.") | Out-Null
$Summary.Add("") | Out-Null
$Summary.Add("Next: Manually verify only the P1 core workflow in this order:") | Out-Null
$Summary.Add("") | Out-Null
$Summary.Add("1. Workspace") | Out-Null
$Summary.Add("2. Clients") | Out-Null
$Summary.Add("3. Matters") | Out-Null
$Summary.Add("4. Deadlines") | Out-Null
$Summary.Add("5. Documents") | Out-Null
$Summary.Add("6. Court Dates") | Out-Null
$Summary.Add("") | Out-Null
$Summary.Add("P0 Authentication, RBAC and Audit Logging must be verified as foundation controls, but not modified yet.") | Out-Null
$Summary.Add("") | Out-Null
$Summary.Add("## Files Created") | Out-Null
$Summary.Add("") | Out-Null
$Summary.Add("- _LEOS_CONTROL\feature-exploration\matrix\PHASE-12.0E-CLEAN-FEATURE-CONNECTION-MATRIX.csv") | Out-Null
$Summary.Add("- _LEOS_CONTROL\feature-exploration\review\CLEAN-FRONTEND-SOURCE-CANDIDATES.csv") | Out-Null
$Summary.Add("- _LEOS_CONTROL\feature-exploration\review\CLEAN-BACKEND-SOURCE-CANDIDATES.csv") | Out-Null
$Summary.Add("- _LEOS_CONTROL\feature-exploration\review\CLEAN-DATABASE-CANDIDATES.csv") | Out-Null
$Summary.Add("- _LEOS_CONTROL\feature-exploration\review\EXCLUDED-NON-ACTIVE-CANDIDATES.csv") | Out-Null
$Summary.Add("") | Out-Null
$Summary.Add("## Safety Confirmation") | Out-Null
$Summary.Add("") | Out-Null
$Summary.Add("No files were deleted.") | Out-Null
$Summary.Add("No files were renamed.") | Out-Null
$Summary.Add("No files were moved.") | Out-Null
$Summary.Add("No source code was modified.") | Out-Null
$Summary.Add("No database was modified.") | Out-Null
$Summary.Add("No production features were unlocked.") | Out-Null

$ReportPath = Join-Path $ReportRoot "PHASE-12.0E-CLEAN-FEATURE-CONNECTION-VERIFICATION-REPORT.md"
Save-Text -Path $ReportPath -Content ($Summary -join "`r`n")

Write-Host ""
Write-Pass "PHASE 12.0E CLEAN FEATURE CONNECTION VERIFICATION COMPLETE"
Write-Host ""
Write-Host "Open clean report:" -ForegroundColor Cyan
Write-Host "notepad `"_LEOS_CONTROL\reports\PHASE-12.0E-CLEAN-FEATURE-CONNECTION-VERIFICATION-REPORT.md`""
Write-Host ""
Write-Host "Open clean matrix:" -ForegroundColor Cyan
Write-Host "notepad `"_LEOS_CONTROL\feature-exploration\matrix\PHASE-12.0E-CLEAN-FEATURE-CONNECTION-MATRIX.csv`""
Write-Host ""
Write-Pass "Paste the clean report back into ChatGPT."
