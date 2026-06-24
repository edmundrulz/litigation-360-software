param(
    [ValidateSet("AUDIT")]
    [string]$Mode = "AUDIT"
)

$ErrorActionPreference = "Stop"

$Root = "C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software"
$MetadataRoot = Join-Path $Root "_operations\phase-10ZY1-enterprise-metadata-extraction-audit\inventory"
$Out = Join-Path $Root "_operations\phase-10ZZ0-enterprise-documentation-governance-audit"

$Dirs = @("reports","docs","registry","matrices","gaps","logs","validation")
foreach ($d in $Dirs) {
    $target = Join-Path $Out $d
    if (!(Test-Path -LiteralPath $target)) {
        New-Item -ItemType Directory -Path $target -Force | Out-Null
    }
}

function Write-Title($text) {
    Write-Host ""
    Write-Host "===================================================="
    Write-Host $text
    Write-Host "===================================================="
}

function Import-Inventory($name) {
    $path = Join-Path $MetadataRoot $name
    if (!(Test-Path -LiteralPath $path)) {
        throw "Missing metadata inventory: $path. Run Phase 10ZY.1 first."
    }
    return Import-Csv -LiteralPath $path
}

function Count-ByCategory($rows) {
    $groups = $rows | Group-Object Category | Sort-Object Name
    $lines = @()
    foreach ($g in $groups) {
        $lines += "| $($g.Name) | $($g.Count) |"
    }
    return $lines -join "`r`n"
}

function Find-Docs($docs, $needle) {
    return @($docs | Where-Object {
        $_.FullPath -like "*$needle*" -or $_.Name -like "*$needle*"
    })
}

Write-Title "PHASE 10ZZ.0 ENTERPRISE DOCUMENTATION GOVERNANCE AUDIT"

if (!(Test-Path -LiteralPath $Root)) {
    throw "Project root not found: $Root"
}

$docs = Import-Inventory "DOCUMENT-INVENTORY.csv"
$routes = Import-Inventory "ROUTE-INVENTORY.csv"
$automation = Import-Inventory "AUTOMATION-INVENTORY.csv"
$frontend = Import-Inventory "FRONTEND-INVENTORY.csv"
$powershell = Import-Inventory "POWERSHELL-INVENTORY.csv"
$validation = Import-Inventory "VALIDATION-INVENTORY.csv"
$tests = Import-Inventory "TEST-INVENTORY.csv"
$operations = Import-Inventory "OPERATIONS-INVENTORY.csv"

Write-Host "Loaded inventories:"
Write-Host ("Documents: {0}" -f $docs.Count)
Write-Host ("Routes: {0}" -f $routes.Count)
Write-Host ("Automation Engines: {0}" -f $automation.Count)
Write-Host ("Frontend Items: {0}" -f $frontend.Count)
Write-Host ("PowerShell Scripts: {0}" -f $powershell.Count)
Write-Host ("Validation Items: {0}" -f $validation.Count)
Write-Host ("Test Items: {0}" -f $tests.Count)
Write-Host ("Operations Folders: {0}" -f $operations.Count)

$docCategories = Count-ByCategory $docs

$sopDocs = Find-Docs $docs "sop"
$protocolDocs = Find-Docs $docs "protocol"
$runbookDocs = Find-Docs $docs "runbook"
$validationDocs = Find-Docs $docs "validation"
$testDocs = Find-Docs $docs "test"
$governanceDocs = Find-Docs $docs "governance"
$deploymentDocs = Find-Docs $docs "deployment"
$recoveryDocs = Find-Docs $docs "recovery"
$trainingDocs = Find-Docs $docs "training"
$courtDocs = Find-Docs $docs "court"
$perkesoDocs = Find-Docs $docs "perkeso"
$industrialDocs = Find-Docs $docs "industrial"

$requiredDomains = @(
    "Foundation",
    "Authentication",
    "RBAC",
    "Client",
    "Matter",
    "Document",
    "Court",
    "Industrial Court",
    "PERKESO",
    "Billing",
    "Finance",
    "Executive",
    "Deployment",
    "Monitoring",
    "Analytics",
    "Predictive",
    "Autonomous",
    "Governance",
    "Recovery",
    "Testing",
    "Validation",
    "Training",
    "Security"
)

$coverageRows = @()
foreach ($domain in $requiredDomains) {
    $matchingDocs = @($docs | Where-Object {
        $_.Name -like "*$domain*" -or $_.FullPath -like "*$domain*"
    })

    $matchingRoutes = @($routes | Where-Object {
        $_.Name -like "*$domain*" -or $_.FullPath -like "*$domain*"
    })

    $matchingAutomation = @($automation | Where-Object {
        $_.Name -like "*$domain*" -or $_.FullPath -like "*$domain*"
    })

    $score = 0
    if ($matchingDocs.Count -gt 0) { $score += 40 }
    if ($matchingRoutes.Count -gt 0) { $score += 20 }
    if ($matchingAutomation.Count -gt 0) { $score += 20 }
    if (@($validation | Where-Object { $_.Name -like "*$domain*" -or $_.FullPath -like "*$domain*" }).Count -gt 0) { $score += 10 }
    if (@($tests | Where-Object { $_.Name -like "*$domain*" -or $_.FullPath -like "*$domain*" }).Count -gt 0) { $score += 10 }

    $coverageRows += [pscustomobject]@{
        Domain = $domain
        DocumentationCount = $matchingDocs.Count
        RouteCount = $matchingRoutes.Count
        AutomationCount = $matchingAutomation.Count
        CoverageScore = $score
        Status = $(if ($score -ge 80) { "STRONG" } elseif ($score -ge 40) { "PARTIAL" } else { "GAP" })
    }
}

$gapRows = @($coverageRows | Where-Object { $_.Status -ne "STRONG" })

$duplicateRows = $docs |
    Group-Object Name |
    Where-Object { $_.Count -gt 1 } |
    ForEach-Object {
        [pscustomobject]@{
            FileName = $_.Name
            DuplicateCount = $_.Count
            Paths = ($_.Group.FullPath -join " | ")
        }
    }

$registryPath = Join-Path $Out "registry\MASTER-DOCUMENTATION-REGISTRY.md"
$coveragePath = Join-Path $Out "matrices\DOCUMENTATION-COVERAGE-MATRIX.md"
$ownershipPath = Join-Path $Out "matrices\DOCUMENTATION-OWNERSHIP-MATRIX.md"
$duplicatePath = Join-Path $Out "reports\DOCUMENTATION-DUPLICATION-REPORT.md"
$gapPath = Join-Path $Out "gaps\DOCUMENTATION-GAP-ANALYSIS.md"
$lifecyclePath = Join-Path $Out "docs\DOCUMENTATION-LIFECYCLE-POLICY.md"
$summaryPath = Join-Path $Out "reports\PHASE-10ZZ0-SUMMARY.txt"
$jsonPath = Join-Path $Out "reports\PHASE-10ZZ0-SUMMARY.json"
$coverageCsv = Join-Path $Out "matrices\DOCUMENTATION-COVERAGE-MATRIX.csv"
$gapCsv = Join-Path $Out "gaps\DOCUMENTATION-GAP-ANALYSIS.csv"
$duplicateCsv = Join-Path $Out "reports\DOCUMENTATION-DUPLICATION-REPORT.csv"

$coverageRows | Export-Csv -LiteralPath $coverageCsv -NoTypeInformation -Encoding UTF8
$gapRows | Export-Csv -LiteralPath $gapCsv -NoTypeInformation -Encoding UTF8
$duplicateRows | Export-Csv -LiteralPath $duplicateCsv -NoTypeInformation -Encoding UTF8

$registry = @"
# MASTER DOCUMENTATION REGISTRY

## Phase
10ZZ.0 Enterprise Documentation Governance Audit

## Purpose
Create a governed master registry from the Phase 10ZY.1 metadata inventories.

## Source Evidence
- DOCUMENT-INVENTORY.csv
- ROUTE-INVENTORY.csv
- AUTOMATION-INVENTORY.csv
- OPERATIONS-INVENTORY.csv
- FRONTEND-INVENTORY.csv
- POWERSHELL-INVENTORY.csv
- VALIDATION-INVENTORY.csv
- TEST-INVENTORY.csv

## Inventory Totals
| Asset Type | Count |
|---|---:|
| Documents | $($docs.Count) |
| Routes | $($routes.Count) |
| Automation Engines | $($automation.Count) |
| Frontend Items | $($frontend.Count) |
| PowerShell Scripts | $($powershell.Count) |
| Validation Items | $($validation.Count) |
| Test Items | $($tests.Count) |
| Operations Folders | $($operations.Count) |

## Documentation Classification
| Category | Count |
|---|---:|
$docCategories

## Critical Documentation Counts
| Documentation Type | Count |
|---|---:|
| SOP | $($sopDocs.Count) |
| Protocol | $($protocolDocs.Count) |
| Runbook | $($runbookDocs.Count) |
| Validation | $($validationDocs.Count) |
| Testing | $($testDocs.Count) |
| Governance | $($governanceDocs.Count) |
| Deployment | $($deploymentDocs.Count) |
| Recovery | $($recoveryDocs.Count) |
| Training | $($trainingDocs.Count) |
| Court | $($courtDocs.Count) |
| Industrial Court | $($industrialDocs.Count) |
| PERKESO | $($perkesoDocs.Count) |

## Governance Finding
Documentation exists, but the system requires governed classification, ownership, lifecycle, coverage scoring, duplicate control, missing-doc remediation and phase-level traceability.

## Next Required Phases
1. 10ZZ.1 SOP Governance Audit
2. 10ZZ.2 Validation Governance Audit
3. 10ZZ.3 Testing Governance Audit
4. 10ZZ.4 Enterprise Governance Recovery
5. 10ZZ Final Readiness Audit
"@
$registry | Out-File -LiteralPath $registryPath -Encoding UTF8

$coverageLines = $coverageRows | ForEach-Object {
    "| $($_.Domain) | $($_.DocumentationCount) | $($_.RouteCount) | $($_.AutomationCount) | $($_.CoverageScore)% | $($_.Status) |"
}
$coverageMd = @"
# DOCUMENTATION COVERAGE MATRIX

## Purpose
Score documentation visibility across enterprise domains using real inventory metadata.

| Domain | Docs | Routes | Automation | Score | Status |
|---|---:|---:|---:|---:|---|
$($coverageLines -join "`r`n")

## Rule
- 80–100 = STRONG
- 40–79 = PARTIAL
- 0–39 = GAP

## Next Action
Domains marked PARTIAL or GAP must be remediated in SOP, validation, testing and governance recovery phases.
"@
$coverageMd | Out-File -LiteralPath $coveragePath -Encoding UTF8

$ownershipLines = $requiredDomains | ForEach-Object {
    "| $_ | Operations Owner | Technical Owner | Governance Owner | Review every 30 days |"
}
$ownershipMd = @"
# DOCUMENTATION OWNERSHIP MATRIX

## Purpose
Assign default governance ownership for every enterprise documentation domain.

| Domain | Primary Owner | Technical Owner | Governance Owner | Review Cycle |
|---|---|---|---|---|
$($ownershipLines -join "`r`n")

## Rule
No document should remain ownerless. Until named individuals are assigned, ownership defaults to Operations Owner, Technical Owner and Governance Owner.
"@
$ownershipMd | Out-File -LiteralPath $ownershipPath -Encoding UTF8

$dupPreview = $duplicateRows | Select-Object -First 100 | ForEach-Object {
    "| $($_.FileName) | $($_.DuplicateCount) | $($_.Paths) |"
}
$duplicateMd = @"
# DOCUMENTATION DUPLICATION REPORT

## Purpose
Identify documentation files sharing identical names across the project.

## Duplicate Summary
Total duplicate filename groups: $($duplicateRows.Count)

## First 100 Duplicate Groups
| File Name | Duplicate Count | Paths |
|---|---:|---|
$($dupPreview -join "`r`n")

## Rule
Duplicate documents are not automatically bad, but they must be reviewed for:
1. stale copies,
2. conflicting procedures,
3. outdated runbooks,
4. duplicate phase handovers,
5. uncontrolled versions.
"@
$duplicateMd | Out-File -LiteralPath $duplicatePath -Encoding UTF8

$gapLines = $gapRows | ForEach-Object {
    "| $($_.Domain) | $($_.CoverageScore)% | $($_.Status) | Create or consolidate docs, SOPs, validation and testing artifacts |"
}
$gapMd = @"
# DOCUMENTATION GAP ANALYSIS

## Purpose
Identify weak documentation domains before Phase 11.

| Domain | Score | Status | Remediation |
|---|---:|---|---|
$($gapLines -join "`r`n")

## Gate Rule
Do not proceed to Phase 11 until GAP domains are either remediated or formally accepted as known exceptions.
"@
$gapMd | Out-File -LiteralPath $gapPath -Encoding UTF8

$lifecycleMd = @"
# DOCUMENTATION LIFECYCLE POLICY

## Purpose
Govern creation, review, approval, retirement and recovery of Litigation 360 documentation.

## Scope
Applies to all documentation, SOPs, protocols, runbooks, validation reports, testing reports, governance artifacts and handovers.

## Rules
1. Every document must have a purpose, scope, inputs, outputs, process, validation and operator checklist.
2. Every phase must have a registry entry.
3. Every SOP must have an owner and review cycle.
4. Duplicate documents must be reviewed before being relied upon.
5. Obsolete documents must be archived, not deleted.
6. Phase 11 is blocked until 10ZZ recovery phases are complete.

## Process
1. Inventory documents.
2. Classify documents.
3. Assign ownership.
4. Score coverage.
5. Identify duplicates.
6. Identify gaps.
7. Remediate through 10ZZ.1 to 10ZZ.4.
8. Run final readiness audit.

## Operator Checklist
- [ ] Registry generated
- [ ] Coverage matrix generated
- [ ] Ownership matrix generated
- [ ] Duplication report generated
- [ ] Gap analysis generated
- [ ] Lifecycle policy generated
"@
$lifecycleMd | Out-File -LiteralPath $lifecyclePath -Encoding UTF8

$summary = [ordered]@{
    Phase = "10ZZ.0"
    Status = "PASS"
    Documents = $docs.Count
    Routes = $routes.Count
    AutomationEngines = $automation.Count
    FrontendItems = $frontend.Count
    PowerShellScripts = $powershell.Count
    ValidationItems = $validation.Count
    TestItems = $tests.Count
    OperationsFolders = $operations.Count
    SopDocs = $sopDocs.Count
    ProtocolDocs = $protocolDocs.Count
    RunbookDocs = $runbookDocs.Count
    GovernanceDocs = $governanceDocs.Count
    DuplicateFilenameGroups = $duplicateRows.Count
    GapOrPartialDomains = $gapRows.Count
    GeneratedAt = (Get-Date).ToString("o")
}
$summary | ConvertTo-Json -Depth 5 | Out-File -LiteralPath $jsonPath -Encoding UTF8

@"
PHASE 10ZZ.0 ENTERPRISE DOCUMENTATION GOVERNANCE AUDIT

Status: PASS

Documents: $($docs.Count)
Routes: $($routes.Count)
Automation Engines: $($automation.Count)
Frontend Items: $($frontend.Count)
PowerShell Scripts: $($powershell.Count)
Validation Items: $($validation.Count)
Test Items: $($tests.Count)
Operations Folders: $($operations.Count)

SOP Docs: $($sopDocs.Count)
Protocol Docs: $($protocolDocs.Count)
Runbook Docs: $($runbookDocs.Count)
Governance Docs: $($governanceDocs.Count)

Duplicate Filename Groups: $($duplicateRows.Count)
Gap Or Partial Domains: $($gapRows.Count)

Generated:
$registryPath
$coveragePath
$ownershipPath
$duplicatePath
$gapPath
$lifecyclePath
"@ | Out-File -LiteralPath $summaryPath -Encoding UTF8

Write-Host ""
Write-Host "Generated:"
Write-Host $registryPath
Write-Host $coveragePath
Write-Host $ownershipPath
Write-Host $duplicatePath
Write-Host $gapPath
Write-Host $lifecyclePath
Write-Host $summaryPath

Write-Host ""
Write-Host "===================================================="
Write-Host "PHASE 10ZZ.0 ENTERPRISE DOCUMENTATION GOVERNANCE AUDIT STATUS: PASS"
Write-Host "===================================================="
Write-Host ""
Read-Host "Press Enter to close"
