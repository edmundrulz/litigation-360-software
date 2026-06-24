param(
    [ValidateSet("PLAN","APPLY","VERIFY")]
    [string]$Mode = "APPLY"
)

$ErrorActionPreference = "Stop"

$Root = "C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software"
$PhaseRoot = Join-Path $Root "_operations\phase-10ZZ3-testing-governance-audit"

$Folders = @(
    "registry",
    "matrices",
    "reports",
    "validation",
    "logs",
    "monitoring",
    "evidence",
    "protocols",
    "parameters",
    "checks-and-balances",
    "blueprints",
    "prompts",
    "backups"
)

$Domains = @(
    "Clients",
    "Staff",
    "Matters",
    "Cases",
    "Documents",
    "Deadlines",
    "Health",
    "Security",
    "Routes",
    "Frontend",
    "Backend",
    "Services",
    "Utilities",
    "Automation",
    "Monitoring",
    "Commercialisation",
    "Licensing",
    "Governance",
    "Validation",
    "Deployment",
    "Recovery",
    "Audit",
    "Dashboard"
)

function Write-Step($Message) {
    Write-Host "[10ZZ.3] $Message"
}

function New-SafeFolder($Path) {
    if (!(Test-Path $Path)) {
        New-Item -ItemType Directory -Path $Path -Force | Out-Null
    }
}

function Get-TestingAssets {
    $Files = Get-ChildItem -Path $Root -Recurse -File -ErrorAction SilentlyContinue |
        Where-Object {
            $_.FullName -notmatch "\\node_modules\\" -and
            $_.FullName -notmatch "\\.git\\" -and
            $_.FullName -notmatch "\\runtime-snapshots\\" -and
            (
                $_.Name -match "test" -or
                $_.Name -match "spec" -or
                $_.Name -match "jest" -or
                $_.Name -match "verify" -or
                $_.Name -match "run-" -or
                $_.DirectoryName -match "\\tests\\" -or
                $_.DirectoryName -match "\\testing\\"
            )
        }

    $Files | Sort-Object FullName -Unique
}

function Invoke-Apply {
    Write-Step "Creating testing governance audit structure..."

    New-SafeFolder $PhaseRoot

    foreach ($Folder in $Folders) {
        New-SafeFolder (Join-Path $PhaseRoot $Folder)
    }

    $Assets = Get-TestingAssets

    $RegistryPath = Join-Path $PhaseRoot "registry\MASTER-TEST-REGISTRY.md"
    $CoveragePath = Join-Path $PhaseRoot "matrices\TEST-COVERAGE-MATRIX.md"
    $OwnershipPath = Join-Path $PhaseRoot "matrices\TEST-OWNERSHIP-MATRIX.md"
    $MissingPath = Join-Path $PhaseRoot "reports\MISSING-TESTS.md"
    $ProtocolPath = Join-Path $PhaseRoot "protocols\TESTING-GOVERNANCE-PROTOCOL.md"
    $ParameterPath = Join-Path $PhaseRoot "parameters\TESTING-GOVERNANCE-PARAMETERS.md"
    $BlueprintPath = Join-Path $PhaseRoot "blueprints\TESTING-GOVERNANCE-BLUEPRINT.md"
    $PromptPath = Join-Path $PhaseRoot "prompts\TESTING-GOVERNANCE-PROMPTS.md"
    $ChecksPath = Join-Path $PhaseRoot "checks-and-balances\TESTING-CHECKS-AND-BALANCES.md"
    $ReportPath = Join-Path $PhaseRoot "reports\PHASE-10ZZ3-TESTING-GOVERNANCE-AUDIT-REPORT.md"
    $StatusPath = Join-Path $PhaseRoot "monitoring\testing-governance-status.json"
    $InventoryPath = Join-Path $PhaseRoot "evidence\TEST-ASSET-INVENTORY.txt"
    $LogPath = Join-Path $PhaseRoot "logs\PHASE-10ZZ3.log"

    $Assets.FullName | Set-Content $InventoryPath -Encoding UTF8

    "# MASTER TEST REGISTRY`n" | Set-Content $RegistryPath -Encoding UTF8

    foreach ($Asset in $Assets) {
        $Relative = $Asset.FullName.Replace($Root + "\", "")
        "- $Relative | Type: $($Asset.Extension) | Status: DISCOVERED | Owner: QA / Governance" |
            Add-Content $RegistryPath -Encoding UTF8
    }

    "# TEST COVERAGE MATRIX`n`n| Domain | Test Evidence | Status |`n|---|---|---|" |
        Set-Content $CoveragePath -Encoding UTF8

    "# MISSING TESTS`n" | Set-Content $MissingPath -Encoding UTF8

    $GapCount = 0

    foreach ($Domain in $Domains) {
        $Matches = $Assets | Where-Object { $_.FullName -match $Domain }

        if ($Matches.Count -gt 0) {
            "| $Domain | $($Matches.Count) assets found | COVERED |" |
                Add-Content $CoveragePath -Encoding UTF8
        }
        else {
            "| $Domain | 0 assets found | GAP REVIEW REQUIRED |" |
                Add-Content $CoveragePath -Encoding UTF8

            "- $Domain testing coverage requires review or test creation." |
                Add-Content $MissingPath -Encoding UTF8

            $GapCount++
        }
    }

    "# TEST OWNERSHIP MATRIX`n`n| Domain | Owner | Review Cycle | Evidence Path |`n|---|---|---|---|" |
        Set-Content $OwnershipPath -Encoding UTF8

    foreach ($Domain in $Domains) {
        "| $Domain | QA / Governance Owner | Every Phase Gate | _operations\phase-10ZZ3-testing-governance-audit |" |
            Add-Content $OwnershipPath -Encoding UTF8
    }

    @"
# TESTING GOVERNANCE PROTOCOL

## Purpose
Define how Litigation 360 testing evidence is discovered, registered, reviewed, monitored, and governed.

## Rules
1. Every major module must have identifiable test coverage.
2. Every test asset must be traceable to a domain.
3. Every missing test domain must be recorded.
4. No Phase 11 approval is allowed while testing governance is incomplete.
5. Test evidence must be stored or referenced from the master test registry.
6. Regression baseline must be preserved.
7. Failed tests must trigger stop, review, correction, and re-test.

## Minimum Governance Evidence
- MASTER-TEST-REGISTRY.md
- TEST-COVERAGE-MATRIX.md
- TEST-OWNERSHIP-MATRIX.md
- MISSING-TESTS.md
- TEST-ASSET-INVENTORY.txt
- testing-governance-status.json
- PHASE-10ZZ3-TESTING-GOVERNANCE-AUDIT-REPORT.md
"@ | Set-Content $ProtocolPath -Encoding UTF8

    @"
# TESTING GOVERNANCE PARAMETERS

ProjectRoot=$Root
PhaseRoot=$PhaseRoot
RequiredDomains=$($Domains.Count)
DiscoveredTestAssets=$($Assets.Count)
GapCount=$GapCount
MinimumRequiredAssets=1
Phase11Locked=TRUE
NoDeleteRule=TRUE
NoManualCreationRule=TRUE
"@ | Set-Content $ParameterPath -Encoding UTF8

    @"
# TESTING GOVERNANCE BLUEPRINT

## Objective
Create a formal testing governance layer for Litigation 360.

## Coverage Areas
- Unit tests
- Integration tests
- Route tests
- API tests
- Frontend tests
- Regression tests
- Security tests
- Validation tests
- Licensing tests
- Commercialisation tests
- Monitoring tests
- Deployment tests

## Required Flow
1. Discover test assets.
2. Register test assets.
3. Map assets to domains.
4. Identify missing domains.
5. Assign ownership.
6. Generate monitoring status.
7. Produce report.
8. Produce PASS/FAIL validation.
"@ | Set-Content $BlueprintPath -Encoding UTF8

    @"
# TESTING GOVERNANCE PROMPTS

Use these prompts in future chats:

1. Continue Litigation 360 from Phase 10ZZ.3 Testing Governance Audit.
2. Do not restart architecture.
3. Preserve the current test baseline.
4. Generate parser-safe PowerShell only.
5. Include folders, files, reports, validation, monitoring, and PASS/FAIL output.
6. Do not delete files.
7. Do not refactor services yet.
8. Identify missing testing domains before creating new features.
"@ | Set-Content $PromptPath -Encoding UTF8

    @"
# TESTING CHECKS AND BALANCES

Mandatory checks:
- Test asset discovery check
- Registry existence check
- Coverage matrix check
- Ownership matrix check
- Missing tests report check
- Monitoring JSON check
- Report generation check
- PASS/FAIL validation check
- Phase 11 lock check
"@ | Set-Content $ChecksPath -Encoding UTF8

    $Status = [ordered]@{
        phase = "10ZZ.3"
        name = "Testing Governance Audit"
        discoveredTestAssets = $Assets.Count
        reviewedDomains = $Domains.Count
        gapCount = $GapCount
        status = if ($Assets.Count -gt 0) { "GENERATED" } else { "NO_TEST_ASSETS_FOUND" }
        generatedAt = (Get-Date).ToString("s")
        nextPhase = "10ZZ.4 Enterprise Governance Recovery"
    }

    $Status | ConvertTo-Json -Depth 5 | Set-Content $StatusPath -Encoding UTF8

    @"
# PHASE 10ZZ.3 TESTING GOVERNANCE AUDIT REPORT

Project Root:
$Root

Phase Root:
$PhaseRoot

Discovered Test Assets:
$($Assets.Count)

Reviewed Domains:
$($Domains.Count)

Gap Review Count:
$GapCount

Generated:
- MASTER-TEST-REGISTRY.md
- TEST-COVERAGE-MATRIX.md
- TEST-OWNERSHIP-MATRIX.md
- MISSING-TESTS.md
- TESTING-GOVERNANCE-PROTOCOL.md
- TESTING-GOVERNANCE-PARAMETERS.md
- TESTING-GOVERNANCE-BLUEPRINT.md
- TESTING-GOVERNANCE-PROMPTS.md
- TESTING-CHECKS-AND-BALANCES.md
- TEST-ASSET-INVENTORY.txt
- testing-governance-status.json

Result:
GENERATED - VERIFY REQUIRED

Next Recommended Phase:
10ZZ.4 Enterprise Governance Recovery
"@ | Set-Content $ReportPath -Encoding UTF8

    "Phase 10ZZ.3 generated at $(Get-Date)" | Set-Content $LogPath -Encoding UTF8

    Write-Step "Generation complete."
}

function Invoke-Verify {
    Write-Step "Verifying testing governance audit..."

    $Failures = @()

    foreach ($Folder in $Folders) {
        $Path = Join-Path $PhaseRoot $Folder
        if (!(Test-Path $Path)) {
            $Failures += "Missing folder: $Path"
        }
    }

    $RequiredFiles = @(
        "registry\MASTER-TEST-REGISTRY.md",
        "matrices\TEST-COVERAGE-MATRIX.md",
        "matrices\TEST-OWNERSHIP-MATRIX.md",
        "reports\MISSING-TESTS.md",
        "reports\PHASE-10ZZ3-TESTING-GOVERNANCE-AUDIT-REPORT.md",
        "protocols\TESTING-GOVERNANCE-PROTOCOL.md",
        "parameters\TESTING-GOVERNANCE-PARAMETERS.md",
        "blueprints\TESTING-GOVERNANCE-BLUEPRINT.md",
        "prompts\TESTING-GOVERNANCE-PROMPTS.md",
        "checks-and-balances\TESTING-CHECKS-AND-BALANCES.md",
        "monitoring\testing-governance-status.json",
        "evidence\TEST-ASSET-INVENTORY.txt",
        "logs\PHASE-10ZZ3.log"
    )

    foreach ($File in $RequiredFiles) {
        $Path = Join-Path $PhaseRoot $File
        if (!(Test-Path $Path)) {
            $Failures += "Missing required file: $File"
        }
    }

    $InventoryPath = Join-Path $PhaseRoot "evidence\TEST-ASSET-INVENTORY.txt"
    $AssetCount = 0

    if (Test-Path $InventoryPath) {
        $AssetCount = (Get-Content $InventoryPath -ErrorAction SilentlyContinue | Where-Object { $_.Trim() -ne "" }).Count
    }

    $ValidationPath = Join-Path $PhaseRoot "validation\PHASE-10ZZ3-VALIDATION-RESULT.md"

    if ($Failures.Count -eq 0 -and $AssetCount -gt 0) {
        @"
# PHASE 10ZZ.3 VALIDATION RESULT

Result:
PASS

Test Assets Found:
$AssetCount

Validation Time:
$(Get-Date)

Next Recommended Phase:
10ZZ.4 Enterprise Governance Recovery
"@ | Set-Content $ValidationPath -Encoding UTF8

        Write-Host ""
        Write-Host "========================================"
        Write-Host "PHASE 10ZZ.3 TESTING GOVERNANCE: PASS"
        Write-Host "Test Assets Found: $AssetCount"
        Write-Host "Next: 10ZZ.4 Enterprise Governance Recovery"
        Write-Host "========================================"
        Write-Host ""
        exit 0
    }
    else {
        if ($AssetCount -eq 0) {
            $Failures += "No test assets discovered."
        }

        @"
# PHASE 10ZZ.3 VALIDATION RESULT

Result:
FAIL

Failures:
$($Failures -join "`n")

Validation Time:
$(Get-Date)

Action:
Do not proceed to Phase 11.
Review test asset discovery and re-run.
"@ | Set-Content $ValidationPath -Encoding UTF8

        Write-Host ""
        Write-Host "========================================"
        Write-Host "PHASE 10ZZ.3 TESTING GOVERNANCE: FAIL"
        Write-Host "Failure Count: $($Failures.Count)"
        Write-Host "========================================"
        $Failures | ForEach-Object { Write-Host "- $_" }
        Write-Host ""
        exit 1
    }
}

if (!(Test-Path $Root)) {
    throw "Project root not found: $Root"
}

Set-Location $Root

if ($Mode -eq "PLAN") {
    Write-Step "PLAN mode selected."
    Write-Host "Will create: $PhaseRoot"
    Write-Host "Will inventory testing assets and create governance reports."
    exit 0
}

if ($Mode -eq "APPLY") {
    Invoke-Apply
    Invoke-Verify
}

if ($Mode -eq "VERIFY") {
    Invoke-Verify
}
