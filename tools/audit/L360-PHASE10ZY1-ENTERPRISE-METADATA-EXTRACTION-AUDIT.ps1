param(
    [ValidateSet("AUDIT")]
    [string]$Mode = "AUDIT"
)

$ErrorActionPreference = "Stop"

$Root = "C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software"
$Out = Join-Path $Root "_operations\phase-10ZY1-enterprise-metadata-extraction-audit"

$Dirs = @("reports","inventory","docs","logs","validation")

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

function Export-Inventory($Name, $Files, $Path) {
    $rows = @()

    foreach ($file in $Files) {
        $category = "General"
        $full = $file.FullName.ToLower()

        if ($full -like "*sop*") { $category = "SOP" }
        elseif ($full -like "*protocol*") { $category = "Protocol" }
        elseif ($full -like "*runbook*") { $category = "Runbook" }
        elseif ($full -like "*validation*") { $category = "Validation" }
        elseif ($full -like "*test*") { $category = "Testing" }
        elseif ($full -like "*governance*") { $category = "Governance" }
        elseif ($full -like "*deployment*") { $category = "Deployment" }
        elseif ($full -like "*recovery*") { $category = "Recovery" }
        elseif ($full -like "*training*") { $category = "Training" }
        elseif ($full -like "*security*") { $category = "Security" }
        elseif ($full -like "*monitoring*") { $category = "Monitoring" }
        elseif ($full -like "*court*") { $category = "Court" }
        elseif ($full -like "*perkeso*") { $category = "PERKESO" }
        elseif ($full -like "*industrial*") { $category = "Industrial Court" }

        $rows += [pscustomobject]@{
            Name = $file.Name
            FullPath = $file.FullName
            Extension = $file.Extension
            SizeBytes = $file.Length
            LastModified = $file.LastWriteTime
            Category = $category
        }
    }

    $rows | Export-Csv -LiteralPath $Path -NoTypeInformation -Encoding UTF8
    Write-Host ("{0}: {1} items -> {2}" -f $Name, $rows.Count, $Path)
    return $rows.Count
}

Write-Title "PHASE 10ZY.1 ENTERPRISE METADATA EXTRACTION AUDIT"

if (!(Test-Path -LiteralPath $Root)) {
    throw "Project root not found: $Root"
}

Write-Host "Scanning project root:"
Write-Host $Root
Write-Host ""

$all = Get-ChildItem -LiteralPath $Root -Recurse -File -ErrorAction SilentlyContinue

$documents = $all | Where-Object { $_.Extension -in ".md",".txt",".doc",".docx",".pdf" }
$routes = $all | Where-Object { $_.Name -like "*Routes.js" -or $_.FullName -like "*\backend\src\routes\*.js" }
$automation = $all | Where-Object { $_.FullName -like "*\backend\src\automation\*.js" }
$frontend = $all | Where-Object { $_.FullName -like "*\frontend\src\*.jsx" -or $_.FullName -like "*\frontend\src\*.tsx" }
$powershell = $all | Where-Object { $_.Extension -eq ".ps1" }
$validation = $all | Where-Object { $_.FullName -like "*validation*" -or $_.Name -like "*validate*" }
$testing = $all | Where-Object { $_.FullName -like "*test*" -or $_.Name -like "*.test.js" -or $_.Name -like "*.spec.js" }

$operationsRoot = Join-Path $Root "_operations"
if (Test-Path -LiteralPath $operationsRoot) {
    $operationsFolders = Get-ChildItem -LiteralPath $operationsRoot -Directory -Recurse -ErrorAction SilentlyContinue
} else {
    $operationsFolders = @()
}

$documentCsv = Join-Path $Out "inventory\DOCUMENT-INVENTORY.csv"
$routeCsv = Join-Path $Out "inventory\ROUTE-INVENTORY.csv"
$automationCsv = Join-Path $Out "inventory\AUTOMATION-INVENTORY.csv"
$frontendCsv = Join-Path $Out "inventory\FRONTEND-INVENTORY.csv"
$powershellCsv = Join-Path $Out "inventory\POWERSHELL-INVENTORY.csv"
$validationCsv = Join-Path $Out "inventory\VALIDATION-INVENTORY.csv"
$testCsv = Join-Path $Out "inventory\TEST-INVENTORY.csv"
$operationsCsv = Join-Path $Out "inventory\OPERATIONS-INVENTORY.csv"

$docCount = Export-Inventory "Documentation Inventory" $documents $documentCsv
$routeCount = Export-Inventory "Route Inventory" $routes $routeCsv
$automationCount = Export-Inventory "Automation Inventory" $automation $automationCsv
$frontendCount = Export-Inventory "Frontend Inventory" $frontend $frontendCsv
$psCount = Export-Inventory "PowerShell Inventory" $powershell $powershellCsv
$validationCount = Export-Inventory "Validation Inventory" $validation $validationCsv
$testCount = Export-Inventory "Test Inventory" $testing $testCsv

$opRows = @()
foreach ($folder in $operationsFolders) {
    $filesInside = @(Get-ChildItem -LiteralPath $folder.FullName -File -ErrorAction SilentlyContinue)
    $subFolders = @(Get-ChildItem -LiteralPath $folder.FullName -Directory -ErrorAction SilentlyContinue)

    $opRows += [pscustomobject]@{
        Name = $folder.Name
        FullPath = $folder.FullName
        SubfolderCount = $subFolders.Count
        FileCount = $filesInside.Count
        LastModified = $folder.LastWriteTime
    }
}
$opRows | Export-Csv -LiteralPath $operationsCsv -NoTypeInformation -Encoding UTF8
Write-Host ("Operations Inventory: {0} folders -> {1}" -f $opRows.Count, $operationsCsv)

$summary = [ordered]@{
    ScanDate = (Get-Date).ToString("o")
    TotalFiles = $all.Count
    DocumentationItems = $docCount
    RouteItems = $routeCount
    AutomationItems = $automationCount
    FrontendItems = $frontendCount
    PowerShellItems = $psCount
    ValidationItems = $validationCount
    TestItems = $testCount
    OperationsFolders = $opRows.Count
}

$summaryJson = Join-Path $Out "reports\METADATA-SUMMARY.json"
$summaryTxt = Join-Path $Out "reports\METADATA-SUMMARY.txt"

$summary | ConvertTo-Json -Depth 5 | Out-File -LiteralPath $summaryJson -Encoding UTF8

@"
PHASE 10ZY.1 ENTERPRISE METADATA EXTRACTION AUDIT

Scan Date: $($summary.ScanDate)

Total Files: $($summary.TotalFiles)
Documentation Items: $($summary.DocumentationItems)
Route Items: $($summary.RouteItems)
Automation Items: $($summary.AutomationItems)
Frontend Items: $($summary.FrontendItems)
PowerShell Items: $($summary.PowerShellItems)
Validation Items: $($summary.ValidationItems)
Test Items: $($summary.TestItems)
Operations Folders: $($summary.OperationsFolders)

Inventory Folder:
$Out\inventory

Generated Files:
DOCUMENT-INVENTORY.csv
ROUTE-INVENTORY.csv
AUTOMATION-INVENTORY.csv
OPERATIONS-INVENTORY.csv
FRONTEND-INVENTORY.csv
POWERSHELL-INVENTORY.csv
VALIDATION-INVENTORY.csv
TEST-INVENTORY.csv
"@ | Out-File -LiteralPath $summaryTxt -Encoding UTF8

$protocol = @"
# PHASE 10ZY.1 ENTERPRISE METADATA EXTRACTION AUDIT PROTOCOL

## Purpose
Create file-level inventories for documentation governance, SOP recovery, validation recovery, testing recovery and governance recovery.

## Scope
Scans Litigation 360 filesystem and exports categorized metadata.

## Inputs
- Project root
- Backend routes
- Backend automation
- Frontend source
- PowerShell scripts
- Documentation files
- Operations folders

## Outputs
- DOCUMENT-INVENTORY.csv
- ROUTE-INVENTORY.csv
- AUTOMATION-INVENTORY.csv
- OPERATIONS-INVENTORY.csv
- FRONTEND-INVENTORY.csv
- POWERSHELL-INVENTORY.csv
- VALIDATION-INVENTORY.csv
- TEST-INVENTORY.csv
- METADATA-SUMMARY.txt
- METADATA-SUMMARY.json

## Parameters
Project root:
$Root

## Rules
1. This script does not modify application source files.
2. This script only creates audit inventory outputs.
3. Phase 10ZZ.0 must use these inventories as evidence.
4. If counts are zero for routes, automation or frontend, verify folder structure before continuing.

## Process
1. Confirm project root exists.
2. Create audit folders.
3. Scan filesystem.
4. Export CSV inventories.
5. Generate summary report.
6. Print PASS status.

## Validation
Expected:
PHASE 10ZY.1 ENTERPRISE METADATA EXTRACTION AUDIT STATUS: PASS

## Operator Checklist
- [ ] Inventory folder exists
- [ ] DOCUMENT-INVENTORY.csv exists
- [ ] ROUTE-INVENTORY.csv exists
- [ ] AUTOMATION-INVENTORY.csv exists
- [ ] OPERATIONS-INVENTORY.csv exists
- [ ] METADATA-SUMMARY.txt exists
"@

$protocolPath = Join-Path $Out "docs\PHASE-10ZY1-METADATA-EXTRACTION-PROTOCOL.md"
$protocol | Out-File -LiteralPath $protocolPath -Encoding UTF8

Write-Host ""
Write-Host "Summary:"
Write-Host $summaryTxt
Write-Host $summaryJson
Write-Host ""
Write-Host "Inventory folder:"
Write-Host (Join-Path $Out "inventory")

Write-Host ""
Write-Host "===================================================="
Write-Host "PHASE 10ZY.1 ENTERPRISE METADATA EXTRACTION AUDIT STATUS: PASS"
Write-Host "===================================================="
Write-Host ""
Read-Host "Press Enter to close"
