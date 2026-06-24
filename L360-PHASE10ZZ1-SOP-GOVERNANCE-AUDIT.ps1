param(
    [ValidateSet("AUDIT")]
    [string]$Mode = "AUDIT"
)

$ErrorActionPreference = "Stop"

$Root = "C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software"
$MetadataRoot = Join-Path $Root "_operations\phase-10ZY1-enterprise-metadata-extraction-audit\inventory"
$Out = Join-Path $Root "_operations\phase-10ZZ1-sop-governance-audit"

$Dirs = @("reports","docs","registry","matrices","gaps","logs","validation","sops")
foreach ($d in $Dirs) {
    $target = Join-Path $Out $d
    if (!(Test-Path -LiteralPath $target)) {
        New-Item -ItemType Directory -Path $target -Force | Out-Null
    }
}

function Title($text) {
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

function Match-Any($rows, [string[]]$terms) {
    return @($rows | Where-Object {
        $hit = $false
        foreach ($term in $terms) {
            if ($_.Name -like "*$term*" -or $_.FullPath -like "*$term*") {
                $hit = $true
            }
        }
        $hit
    })
}

Title "PHASE 10ZZ.1 SOP GOVERNANCE AUDIT"

if (!(Test-Path -LiteralPath $Root)) {
    throw "Project root not found: $Root"
}

$docs = Import-Inventory "DOCUMENT-INVENTORY.csv"
$routes = Import-Inventory "ROUTE-INVENTORY.csv"
$automation = Import-Inventory "AUTOMATION-INVENTORY.csv"
$operations = Import-Inventory "OPERATIONS-INVENTORY.csv"
$validation = Import-Inventory "VALIDATION-INVENTORY.csv"
$tests = Import-Inventory "TEST-INVENTORY.csv"

$sopDocs = @($docs | Where-Object {
    $_.Name -like "*sop*" -or
    $_.FullPath -like "*sop*" -or
    $_.Name -like "*standard-operating*" -or
    $_.FullPath -like "*standard-operating*"
})

$requiredSopDomains = @(
    [pscustomobject]@{ Domain="Foundation"; Terms=@("foundation","setup","environment","installation","architecture"); RequiredSOP="FOUNDATION-OPERATIONS-SOP.md" },
    [pscustomobject]@{ Domain="Authentication"; Terms=@("auth","login","password","account","user"); RequiredSOP="AUTHENTICATION-SOP.md" },
    [pscustomobject]@{ Domain="RBAC"; Terms=@("rbac","role","permission","access"); RequiredSOP="RBAC-ACCESS-CONTROL-SOP.md" },
    [pscustomobject]@{ Domain="Client Intake"; Terms=@("client","intake","conflict"); RequiredSOP="CLIENT-INTAKE-SOP.md" },
    [pscustomobject]@{ Domain="Matter Management"; Terms=@("matter","case","assignment"); RequiredSOP="MATTER-MANAGEMENT-SOP.md" },
    [pscustomobject]@{ Domain="Document Lifecycle"; Terms=@("document","file","version","retention","archive"); RequiredSOP="DOCUMENT-LIFECYCLE-SOP.md" },
    [pscustomobject]@{ Domain="Court Operations"; Terms=@("court","hearing","filing","attendance"); RequiredSOP="COURT-OPERATIONS-SOP.md" },
    [pscustomobject]@{ Domain="Industrial Court"; Terms=@("industrial","industrial court"); RequiredSOP="INDUSTRIAL-COURT-SOP.md" },
    [pscustomobject]@{ Domain="PERKESO"; Terms=@("perkeso","socso"); RequiredSOP="PERKESO-SOP.md" },
    [pscustomobject]@{ Domain="Navigation"; Terms=@("navigation","maps","waze","route"); RequiredSOP="COURT-NAVIGATION-SOP.md" },
    [pscustomobject]@{ Domain="Billing"; Terms=@("billing","invoice","finance","payment"); RequiredSOP="BILLING-FINANCE-SOP.md" },
    [pscustomobject]@{ Domain="Executive Operations"; Terms=@("executive","dashboard","reporting","management"); RequiredSOP="EXECUTIVE-OPERATIONS-SOP.md" },
    [pscustomobject]@{ Domain="Deployment"; Terms=@("deployment","release","gatekeeper","environment"); RequiredSOP="DEPLOYMENT-SOP.md" },
    [pscustomobject]@{ Domain="Monitoring"; Terms=@("monitoring","health","metrics","alert"); RequiredSOP="MONITORING-SOP.md" },
    [pscustomobject]@{ Domain="Alert & Escalation"; Terms=@("alert","escalation","notification"); RequiredSOP="ALERT-ESCALATION-SOP.md" },
    [pscustomobject]@{ Domain="Analytics"; Terms=@("analytics","metrics","dashboard"); RequiredSOP="ANALYTICS-SOP.md" },
    [pscustomobject]@{ Domain="Predictive Intelligence"; Terms=@("predictive","forecast","risk","trend"); RequiredSOP="PREDICTIVE-INTELLIGENCE-SOP.md" },
    [pscustomobject]@{ Domain="Autonomous Operations"; Terms=@("autonomous","watchdog","recovery","remediation","decision"); RequiredSOP="AUTONOMOUS-OPERATIONS-SOP.md" },
    [pscustomobject]@{ Domain="Security"; Terms=@("security","hardening","audit","compliance"); RequiredSOP="SECURITY-SOP.md" },
    [pscustomobject]@{ Domain="Backup Recovery"; Terms=@("backup","restore","recovery","disaster"); RequiredSOP="BACKUP-RECOVERY-SOP.md" },
    [pscustomobject]@{ Domain="Testing"; Terms=@("test","testing","smoke","regression"); RequiredSOP="TESTING-SOP.md" },
    [pscustomobject]@{ Domain="Validation"; Terms=@("validation","validator","verify","audit"); RequiredSOP="VALIDATION-SOP.md" },
    [pscustomobject]@{ Domain="Training"; Terms=@("training","user guide","manual","operator"); RequiredSOP="TRAINING-SOP.md" },
    [pscustomobject]@{ Domain="Governance"; Terms=@("governance","approval","risk","compliance"); RequiredSOP="GOVERNANCE-SOP.md" }
)

$coverageRows = @()
foreach ($domain in $requiredSopDomains) {
    $matchingSops = Match-Any $sopDocs $domain.Terms
    $matchingDocs = Match-Any $docs $domain.Terms
    $matchingRoutes = Match-Any $routes $domain.Terms
    $matchingAutomation = Match-Any $automation $domain.Terms
    $matchingOps = Match-Any $operations $domain.Terms
    $matchingValidation = Match-Any $validation $domain.Terms
    $matchingTests = Match-Any $tests $domain.Terms

    $score = 0
    if ($matchingSops.Count -gt 0) { $score += 45 }
    if ($matchingDocs.Count -gt 0) { $score += 15 }
    if ($matchingRoutes.Count -gt 0) { $score += 10 }
    if ($matchingAutomation.Count -gt 0) { $score += 10 }
    if ($matchingOps.Count -gt 0) { $score += 10 }
    if ($matchingValidation.Count -gt 0) { $score += 5 }
    if ($matchingTests.Count -gt 0) { $score += 5 }

    $coverageRows += [pscustomobject]@{
        Domain = $domain.Domain
        RequiredSOP = $domain.RequiredSOP
        ExistingSOPMatches = $matchingSops.Count
        RelatedDocs = $matchingDocs.Count
        RelatedRoutes = $matchingRoutes.Count
        RelatedAutomation = $matchingAutomation.Count
        RelatedOperationsFolders = $matchingOps.Count
        RelatedValidation = $matchingValidation.Count
        RelatedTests = $matchingTests.Count
        Score = $score
        Status = $(if ($matchingSops.Count -gt 0 -and $score -ge 80) { "STRONG" } elseif ($matchingSops.Count -gt 0) { "PARTIAL" } else { "MISSING_SOP" })
    }
}

$missingRows = @($coverageRows | Where-Object { $_.Status -eq "MISSING_SOP" })
$partialRows = @($coverageRows | Where-Object { $_.Status -eq "PARTIAL" })
$strongRows = @($coverageRows | Where-Object { $_.Status -eq "STRONG" })

$registryPath = Join-Path $Out "registry\MASTER-SOP-REGISTRY.md"
$coveragePath = Join-Path $Out "matrices\SOP-COVERAGE-MATRIX.md"
$ownershipPath = Join-Path $Out "matrices\SOP-OWNERSHIP-MATRIX.md"
$missingPath = Join-Path $Out "gaps\MISSING-SOPS.md"
$summaryPath = Join-Path $Out "reports\PHASE-10ZZ1-SUMMARY.txt"
$jsonPath = Join-Path $Out "reports\PHASE-10ZZ1-SUMMARY.json"
$coverageCsv = Join-Path $Out "matrices\SOP-COVERAGE-MATRIX.csv"
$missingCsv = Join-Path $Out "gaps\MISSING-SOPS.csv"

$coverageRows | Export-Csv -LiteralPath $coverageCsv -NoTypeInformation -Encoding UTF8
$missingRows | Export-Csv -LiteralPath $missingCsv -NoTypeInformation -Encoding UTF8

$coverageLines = $coverageRows | ForEach-Object {
    "| $($_.Domain) | $($_.RequiredSOP) | $($_.ExistingSOPMatches) | $($_.RelatedDocs) | $($_.RelatedRoutes) | $($_.RelatedAutomation) | $($_.Score)% | $($_.Status) |"
}

$registry = @"
# MASTER SOP REGISTRY

## Phase
10ZZ.1 SOP Governance Audit

## Purpose
Create a governed registry of SOP coverage across Litigation 360 using the metadata inventories generated by Phase 10ZY.1.

## Source Evidence
- DOCUMENT-INVENTORY.csv
- ROUTE-INVENTORY.csv
- AUTOMATION-INVENTORY.csv
- OPERATIONS-INVENTORY.csv
- VALIDATION-INVENTORY.csv
- TEST-INVENTORY.csv

## SOP Summary
| Item | Count |
|---|---:|
| Existing SOP-like documentation files | $($sopDocs.Count) |
| Required SOP domains | $($requiredSopDomains.Count) |
| Strong SOP domains | $($strongRows.Count) |
| Partial SOP domains | $($partialRows.Count) |
| Missing SOP domains | $($missingRows.Count) |

## SOP Governance Rules
1. Every major operational domain must have a named SOP.
2. Every SOP must include purpose, scope, inputs, outputs, parameters, rules, process, validation and operator checklist.
3. SOPs must be reviewed every 30 days during active build phases.
4. SOPs must be reviewed before moving into Phase 11.
5. Missing SOPs must be created or formally accepted as controlled exceptions.

## Next Required Phase
10ZZ.2 Validation Governance Audit
"@
$registry | Out-File -LiteralPath $registryPath -Encoding UTF8

$coverageMd = @"
# SOP COVERAGE MATRIX

## Purpose
Score SOP coverage across enterprise operating domains.

| Domain | Required SOP | Existing SOP Matches | Related Docs | Related Routes | Related Automation | Score | Status |
|---|---|---:|---:|---:|---:|---:|---|
$($coverageLines -join "`r`n")

## Scoring
- SOP match: 45 points
- Related docs: 15 points
- Related routes: 10 points
- Related automation: 10 points
- Operations folder: 10 points
- Validation: 5 points
- Testing: 5 points

## Gate Rule
MISSING_SOP domains must be remediated before Phase 11.
"@
$coverageMd | Out-File -LiteralPath $coveragePath -Encoding UTF8

$ownerLines = $requiredSopDomains | ForEach-Object {
    "| $($_.Domain) | $($_.RequiredSOP) | Operations Owner | Technical Owner | Governance Owner | 30 days |"
}
$ownership = @"
# SOP OWNERSHIP MATRIX

## Purpose
Assign default ownership and review cycles for each required SOP.

| Domain | SOP | Primary Owner | Technical Owner | Governance Owner | Review Cycle |
|---|---|---|---|---|---|
$($ownerLines -join "`r`n")

## Rule
Until named individuals are assigned, ownership defaults to Operations Owner, Technical Owner and Governance Owner.
"@
$ownership | Out-File -LiteralPath $ownershipPath -Encoding UTF8

$missingLines = $missingRows | ForEach-Object {
    "| $($_.Domain) | $($_.RequiredSOP) | Create SOP from existing docs/routes/automation evidence | HIGH |"
}
if ($missingLines.Count -eq 0) {
    $missingLines = @("| None | None | No missing SOP domains detected | LOW |")
}
$missingMd = @"
# MISSING SOPS

## Purpose
List SOPs required before Phase 11.

| Domain | Required SOP | Remediation | Priority |
|---|---|---|---|
$($missingLines -join "`r`n")

## Standard SOP Template
Each missing SOP must include:
1. Purpose
2. Scope
3. Inputs
4. Outputs
5. Parameters
6. Rules
7. Process
8. Validation
9. Operator checklist
10. Escalation path
11. Recovery action
12. Evidence/report path
"@
$missingMd | Out-File -LiteralPath $missingPath -Encoding UTF8

foreach ($row in $missingRows) {
    $sopPath = Join-Path $Out ("sops\" + $row.RequiredSOP)
    $sop = @"
# $($row.RequiredSOP)

## Status
Generated skeleton pending operational review.

## Domain
$($row.Domain)

## Purpose
Define the standard operating procedure for $($row.Domain) within Litigation 360.

## Scope
Applies to all users, operators, administrators and governance reviewers involved in $($row.Domain).

## Inputs
- Related documentation
- Related routes
- Related automation engines
- Related validation reports
- Related test reports
- Operator feedback

## Outputs
- Completed operational action
- Audit evidence
- Logs
- Reports
- Escalations where required

## Parameters
- Review cycle: 30 days
- Evidence retention: project operations folder
- Escalation threshold: operational blocker, data integrity issue, missed deadline, failed validation or failed health check

## Rules
1. Follow this SOP before performing production-impacting work.
2. Record evidence for all completed actions.
3. Escalate unresolved blockers.
4. Do not perform destructive actions without approval.
5. Update this SOP after operational changes.

## Process
1. Confirm the relevant module or domain.
2. Confirm the required route, page, engine or operations folder exists.
3. Review current documentation.
4. Execute the approved process.
5. Capture evidence.
6. Validate output.
7. Record issue or escalation if validation fails.

## Validation
- Confirm expected files exist.
- Confirm related endpoints work where applicable.
- Confirm logs/reports are generated.
- Confirm operator checklist is complete.

## Operator Checklist
- [ ] Scope confirmed
- [ ] Inputs confirmed
- [ ] Process followed
- [ ] Evidence captured
- [ ] Validation completed
- [ ] Escalation created if required

## Escalation Path
Operations Owner -> Technical Owner -> Governance Owner -> Executive Owner

## Recovery Action
If the SOP fails or cannot be executed, stop the process, preserve logs, create an issue report and escalate.
"@
    $sop | Out-File -LiteralPath $sopPath -Encoding UTF8
}

$summary = [ordered]@{
    Phase = "10ZZ.1"
    Status = "PASS"
    ExistingSopDocuments = $sopDocs.Count
    RequiredSopDomains = $requiredSopDomains.Count
    StrongSopDomains = $strongRows.Count
    PartialSopDomains = $partialRows.Count
    MissingSopDomains = $missingRows.Count
    SkeletonSopsGenerated = $missingRows.Count
    GeneratedAt = (Get-Date).ToString("o")
}

$summary | ConvertTo-Json -Depth 5 | Out-File -LiteralPath $jsonPath -Encoding UTF8

@"
PHASE 10ZZ.1 SOP GOVERNANCE AUDIT

Status: PASS

Existing SOP-like documentation files: $($sopDocs.Count)
Required SOP domains: $($requiredSopDomains.Count)
Strong SOP domains: $($strongRows.Count)
Partial SOP domains: $($partialRows.Count)
Missing SOP domains: $($missingRows.Count)
Skeleton SOPs generated for missing domains: $($missingRows.Count)

Generated:
$registryPath
$coveragePath
$ownershipPath
$missingPath
$coverageCsv
$missingCsv

Next Phase:
10ZZ.2 Validation Governance Audit
"@ | Out-File -LiteralPath $summaryPath -Encoding UTF8

Write-Host ""
Write-Host "Generated:"
Write-Host $registryPath
Write-Host $coveragePath
Write-Host $ownershipPath
Write-Host $missingPath
Write-Host $summaryPath

Write-Host ""
Write-Host "===================================================="
Write-Host "PHASE 10ZZ.1 SOP GOVERNANCE AUDIT STATUS: PASS"
Write-Host "===================================================="
Write-Host ""
Read-Host "Press Enter to close"
