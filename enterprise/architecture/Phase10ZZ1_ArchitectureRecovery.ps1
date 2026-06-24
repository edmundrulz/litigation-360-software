$Root = "C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software"
$Out = "$Root\enterprise\architecture\SystemArchitecture-Recovered.md"

$routeCount = (Import-Csv "$Root\enterprise\reports\RouteInventory.csv").Count
$dbCount = (Import-Csv "$Root\enterprise\reports\DatabaseInventory.csv").Count
$autoCount = (Import-Csv "$Root\enterprise\reports\AutomationInventory.csv").Count
$fileCount = (Import-Csv "$Root\enterprise\reports\AllFiles.csv").Count

@"
# Litigation 360 Recovered Enterprise Architecture

Generated: $(Get-Date)

## Discovery Summary

| Area | Count |
|---|---:|
| Total Files | $fileCount |
| Route Matches | $routeCount |
| Database Matches | $dbCount |
| Automation Matches | $autoCount |

## Current Architecture Finding

Litigation 360 has reached enterprise-scale structure. The project contains a large codebase, many route definitions, database-related references, and automation/workflow references.

## Layer Map

### 1. Frontend Layer
Pending detailed frontend scan.

### 2. Backend Layer
Backend route inventory exists in:
enterprise/reports/RouteInventory.csv

### 3. Database Layer
Database inventory exists in:
enterprise/reports/DatabaseInventory.csv

### 4. Automation Layer
Automation inventory exists in:
enterprise/reports/AutomationInventory.csv

### 5. Documentation Layer
Documentation inventory exists in:
enterprise/reports/DocumentationFiles.csv

## Phase 10ZZ.1 Status

Architecture recovery has started.

Next required outputs:
- Production Route Map
- Backend Module Map
- Database Entity Map
- Automation Workflow Map
- Legacy/Duplicate Route Review
"@ | Set-Content $Out

Write-Host "DONE:"
Write-Host $Out