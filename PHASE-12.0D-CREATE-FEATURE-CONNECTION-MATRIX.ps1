# ============================================================
# LITIGATION 360 LEOS
# PHASE 12.0D CREATE FEATURE CONNECTION MATRIX
# PURPOSE:
#   Create the missing feature connection matrix from the discovery
#   files already produced by Phase 12.0C.
#
# SAFE MODE:
#   - DOES NOT delete
#   - DOES NOT rename
#   - DOES NOT move source files
#   - DOES NOT modify database
#   - DOES NOT modify source code
#   - DOES NOT unlock production
# ============================================================

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$DeclaredProjectRoot = "C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software"

function Write-Step {
    param([string]$Message)
    Write-Host "[PHASE 12.0D] $Message" -ForegroundColor Cyan
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

New-Item -ItemType Directory -Path $MatrixRoot -Force | Out-Null
New-Item -ItemType Directory -Path $ReportRoot -Force | Out-Null

Write-Pass "Project root:"
Write-Host $ProjectRoot -ForegroundColor Green

Write-Pass "Discovery root:"
Write-Host $DiscoveryRoot -ForegroundColor Green

# ------------------------------------------------------------
# 1. LOAD DISCOVERY FILES IF THEY EXIST
# ------------------------------------------------------------
$FrontendBackendCsv = Join-Path $DiscoveryRoot "FRONTEND-BACKEND-CODE-CANDIDATES.csv"
$BackendCsv = Join-Path $DiscoveryRoot "BACKEND-CANDIDATE-FILES.csv"
$DatabaseCsv = Join-Path $DiscoveryRoot "DATABASE-CANDIDATE-FILES.csv"
$DocumentationCsv = Join-Path $DiscoveryRoot "DOCUMENTATION-FILES.csv"

if (!(Test-Path -LiteralPath $FrontendBackendCsv)) {
    throw "Missing discovery file: $FrontendBackendCsv. Run PHASE-12.0C-READONLY-PROJECT-DISCOVERY.ps1 first."
}

$CodeFiles = Import-Csv -LiteralPath $FrontendBackendCsv

if (Test-Path -LiteralPath $BackendCsv) {
    $BackendFiles = Import-Csv -LiteralPath $BackendCsv
}
else {
    $BackendFiles = @()
}

if (Test-Path -LiteralPath $DatabaseCsv) {
    $DatabaseFiles = Import-Csv -LiteralPath $DatabaseCsv
}
else {
    $DatabaseFiles = @()
}

if (Test-Path -LiteralPath $DocumentationCsv) {
    $DocumentationFiles = Import-Csv -LiteralPath $DocumentationCsv
}
else {
    $DocumentationFiles = @()
}

# ------------------------------------------------------------
# 2. DEFINE FEATURE KEYWORDS
# ------------------------------------------------------------
$FeatureDefinitions = @(
    [PSCustomObject]@{ Feature="Workspace"; Keywords=@("workspace","home","command","dashboard") },
    [PSCustomObject]@{ Feature="Clients"; Keywords=@("client","clients","customer") },
    [PSCustomObject]@{ Feature="Matters"; Keywords=@("matter","matters","case","cases") },
    [PSCustomObject]@{ Feature="Deadlines"; Keywords=@("deadline","deadlines","due","reminder") },
    [PSCustomObject]@{ Feature="Documents"; Keywords=@("document","documents","doc","docs","file","files") },
    [PSCustomObject]@{ Feature="Court Dates"; Keywords=@("court","hearing","date","calendar") },
    [PSCustomObject]@{ Feature="Staff"; Keywords=@("staff","user","users","employee","team") },
    [PSCustomObject]@{ Feature="Dashboard / ECC"; Keywords=@("dashboard","ecc","command","monitor","health") },
    [PSCustomObject]@{ Feature="Authentication"; Keywords=@("auth","login","logout","jwt","session","password") },
    [PSCustomObject]@{ Feature="RBAC"; Keywords=@("rbac","role","roles","permission","permissions","access") },
    [PSCustomObject]@{ Feature="Audit Logging"; Keywords=@("audit","log","logs","logging","activity") },
    [PSCustomObject]@{ Feature="Notifications"; Keywords=@("notification","notifications","alert","alerts","email","sms","whatsapp") },
    [PSCustomObject]@{ Feature="Automation"; Keywords=@("automation","scheduler","job","jobs","cron","workflow") },
    [PSCustomObject]@{ Feature="Reports"; Keywords=@("report","reports","analytics","export","pdf","csv") },
    [PSCustomObject]@{ Feature="Client Portal"; Keywords=@("portal","clientportal","client-portal") },
    [PSCustomObject]@{ Feature="Communications Hub"; Keywords=@("communication","communications","message","messages","inbox","outbox") },
    [PSCustomObject]@{ Feature="Finance / Billing"; Keywords=@("finance","billing","invoice","payment","receipt","fee") },
    [PSCustomObject]@{ Feature="Knowledge Graph"; Keywords=@("knowledge","graph","ontology","relationship") },
    [PSCustomObject]@{ Feature="AI Copilot"; Keywords=@("ai","copilot","assistant","llm","openai","model") },
    [PSCustomObject]@{ Feature="Mobile App"; Keywords=@("mobile","android","ios","reactnative","capacitor") }
)

function Count-Matches {
    param(
        [object[]]$Rows,
        [string[]]$Keywords
    )

    if ($null -eq $Rows) {
        return 0
    }

    $Count = 0

    foreach ($Row in $Rows) {
        $Text = ""

        if ($Row.PSObject.Properties.Name -contains "FullName") {
            $Text = [string]$Row.FullName
        }
        elseif ($Row.PSObject.Properties.Name -contains "Name") {
            $Text = [string]$Row.Name
        }

        $TextLower = $Text.ToLower()

        foreach ($Keyword in $Keywords) {
            if ($TextLower.Contains($Keyword.ToLower())) {
                $Count++
                break
            }
        }
    }

    return $Count
}

function First-Matches {
    param(
        [object[]]$Rows,
        [string[]]$Keywords,
        [int]$Limit = 5
    )

    $Matches = New-Object System.Collections.Generic.List[string]

    foreach ($Row in $Rows) {
        $Text = ""

        if ($Row.PSObject.Properties.Name -contains "FullName") {
            $Text = [string]$Row.FullName
        }
        elseif ($Row.PSObject.Properties.Name -contains "Name") {
            $Text = [string]$Row.Name
        }

        $TextLower = $Text.ToLower()

        foreach ($Keyword in $Keywords) {
            if ($TextLower.Contains($Keyword.ToLower())) {
                $Matches.Add($Text) | Out-Null
                break
            }
        }

        if ($Matches.Count -ge $Limit) {
            break
        }
    }

    if ($Matches.Count -eq 0) {
        return ""
    }

    return ($Matches -join " | ")
}

# ------------------------------------------------------------
# 3. CREATE MATRIX
# ------------------------------------------------------------
Write-Step "Creating feature connection matrix..."

$MatrixRows = foreach ($Def in $FeatureDefinitions) {
    $Keywords = $Def.Keywords

    $CodeCount = Count-Matches -Rows $CodeFiles -Keywords $Keywords
    $BackendCount = Count-Matches -Rows $BackendFiles -Keywords $Keywords
    $DatabaseCount = Count-Matches -Rows $DatabaseFiles -Keywords $Keywords
    $DocumentationCount = Count-Matches -Rows $DocumentationFiles -Keywords $Keywords

    $EvidenceSample = First-Matches -Rows $CodeFiles -Keywords $Keywords -Limit 3

    $Status = "PENDING REVIEW"
    $NextAction = "Manually verify exact frontend route, backend route, database impact, RBAC, audit, tests and rollback."

    if ($CodeCount -gt 0 -and $BackendCount -gt 0) {
        $Status = "POSSIBLY CONNECTABLE - VERIFY"
    }
    elseif ($CodeCount -gt 0 -and $BackendCount -eq 0) {
        $Status = "FRONTEND/CODE FOUND - BACKEND NOT CONFIRMED"
    }
    elseif ($CodeCount -eq 0 -and $BackendCount -gt 0) {
        $Status = "BACKEND FOUND - FRONTEND NOT CONFIRMED"
    }
    elseif ($DocumentationCount -gt 0) {
        $Status = "DOCUMENTED / PLANNED ONLY - VERIFY"
    }

    [PSCustomObject]@{
        Feature = $Def.Feature
        LabExplorationAllowed = "YES"
        ProductionUnlockAllowed = "NO"
        CurrentStatus = $Status
        CodeCandidateCount = $CodeCount
        BackendCandidateCount = $BackendCount
        DatabaseCandidateCount = $DatabaseCount
        DocumentationCandidateCount = $DocumentationCount
        EvidenceSample = $EvidenceSample
        RequiredBeforeUnlock = "Frontend route; backend API; RBAC; audit logging; database impact; testing evidence; rollback plan; approval"
        NextAction = $NextAction
    }
}

$MatrixPath = Join-Path $MatrixRoot "FEATURE-CONNECTION-MATRIX.csv"
$FastMatrixPath = Join-Path $MatrixRoot "FEATURE-CONNECTION-MATRIX-FAST.csv"

$MatrixRows | Export-Csv -Path $MatrixPath -NoTypeInformation -Encoding UTF8
$MatrixRows | Export-Csv -Path $FastMatrixPath -NoTypeInformation -Encoding UTF8

# Also create a readable markdown summary
$SummaryLines = New-Object System.Collections.Generic.List[string]
$SummaryLines.Add("# PHASE 12.0D FEATURE CONNECTION MATRIX SUMMARY") | Out-Null
$SummaryLines.Add("") | Out-Null
$SummaryLines.Add("Generated: $(Get-Date -Format "yyyy-MM-dd HH:mm:ss")") | Out-Null
$SummaryLines.Add("") | Out-Null
$SummaryLines.Add("Project Root:") | Out-Null
$SummaryLines.Add($ProjectRoot) | Out-Null
$SummaryLines.Add("") | Out-Null
$SummaryLines.Add("Matrix Files Created:") | Out-Null
$SummaryLines.Add("- _LEOS_CONTROL\feature-exploration\matrix\FEATURE-CONNECTION-MATRIX.csv") | Out-Null
$SummaryLines.Add("- _LEOS_CONTROL\feature-exploration\matrix\FEATURE-CONNECTION-MATRIX-FAST.csv") | Out-Null
$SummaryLines.Add("") | Out-Null
$SummaryLines.Add("Safety: No source code, database, folders, or production settings were modified.") | Out-Null
$SummaryLines.Add("") | Out-Null
$SummaryLines.Add("## Feature Status Summary") | Out-Null
$SummaryLines.Add("") | Out-Null

foreach ($Row in $MatrixRows) {
    $SummaryLines.Add("### $($Row.Feature)") | Out-Null
    $SummaryLines.Add("Status: $($Row.CurrentStatus)") | Out-Null
    $SummaryLines.Add("Code candidates: $($Row.CodeCandidateCount)") | Out-Null
    $SummaryLines.Add("Backend candidates: $($Row.BackendCandidateCount)") | Out-Null
    $SummaryLines.Add("Database candidates: $($Row.DatabaseCandidateCount)") | Out-Null
    $SummaryLines.Add("Documentation candidates: $($Row.DocumentationCandidateCount)") | Out-Null
    $SummaryLines.Add("") | Out-Null
}

$SummaryPath = Join-Path $ReportRoot "PHASE-12.0D-FEATURE-CONNECTION-MATRIX-SUMMARY.md"
Save-Text -Path $SummaryPath -Content ($SummaryLines -join "`r`n")

Write-Host ""
Write-Pass "PHASE 12.0D FEATURE CONNECTION MATRIX CREATED"
Write-Host ""
Write-Host "Open matrix:" -ForegroundColor Cyan
Write-Host "notepad `"_LEOS_CONTROL\feature-exploration\matrix\FEATURE-CONNECTION-MATRIX.csv`""
Write-Host ""
Write-Host "Open fast matrix alias:" -ForegroundColor Cyan
Write-Host "notepad `"_LEOS_CONTROL\feature-exploration\matrix\FEATURE-CONNECTION-MATRIX-FAST.csv`""
Write-Host ""
Write-Host "Open readable summary:" -ForegroundColor Cyan
Write-Host "notepad `"_LEOS_CONTROL\reports\PHASE-12.0D-FEATURE-CONNECTION-MATRIX-SUMMARY.md`""
Write-Host ""
Write-Pass "Paste the summary back into ChatGPT for the next safe connection step."
