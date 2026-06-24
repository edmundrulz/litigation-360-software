$Root = "C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software"
$Ops = "$Root\_operations"
$Phase = "$Ops\phase-10ZZA-change-enforcement-engine"
$ReportFolder = "$Phase\reports"

New-Item -ItemType Directory -Force -Path $ReportFolder | Out-Null

$Stamp = Get-Date -Format "yyyy-MM-dd-HHmmss"
$Report = "$ReportFolder\SYSTEM-STATUS-$Stamp.md"

$FolderCount = (Get-ChildItem $Ops -Directory | Measure-Object).Count
$MarkdownCount = (Get-ChildItem $Ops -Recurse -Filter *.md | Measure-Object).Count
$ScriptCount = (Get-ChildItem $Ops -Recurse -Filter *.ps1 | Measure-Object).Count
$JsonCount = (Get-ChildItem $Ops -Recurse -Filter *.json | Measure-Object).Count

@"
# LITIGATION 360 LIVE SYSTEM STATUS REPORT

Date:
$(Get-Date)

## Verified Paths

Root:
$(Test-Path $Root)

Operations:
$(Test-Path $Ops)

Phase 10ZZ9:
$(Test-Path "$Ops\phase-10ZZ9-safe-change-autopilot")

Phase 10ZZA:
$(Test-Path $Phase)

## Inventory

Operation Folders:
$FolderCount

Markdown Documents:
$MarkdownCount

PowerShell Scripts:
$ScriptCount

JSON Files:
$JsonCount

## Status

Phase 10ZZA Change Enforcement Engine is active.

## Next Action

Use this report to verify change control, deployment readiness, override tracking, and monitoring.
"@ | Set-Content $Report

Write-Host ""
Write-Host "SYSTEM STATUS REPORT CREATED"
Write-Host $Report
Write-Host ""
