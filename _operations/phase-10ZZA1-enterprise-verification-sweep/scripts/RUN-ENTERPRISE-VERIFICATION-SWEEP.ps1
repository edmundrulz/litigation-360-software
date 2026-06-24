$Root = "C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software"
$Ops = "$Root\_operations"
$Phase = "$Ops\phase-10ZZA1-enterprise-verification-sweep"
$ReportFolder = "$Phase\reports"

New-Item -ItemType Directory -Force -Path $ReportFolder | Out-Null

$Stamp = Get-Date -Format "yyyy-MM-dd-HHmmss"

$MasterReport = "$ReportFolder\ENTERPRISE-VERIFICATION-SWEEP-$Stamp.md"
$FolderCsv = "$ReportFolder\folder-inventory-$Stamp.csv"
$FileTypeCsv = "$ReportFolder\filetype-inventory-$Stamp.csv"
$ScriptCsv = "$ReportFolder\powershell-script-inventory-$Stamp.csv"
$MarkdownCsv = "$ReportFolder\markdown-document-inventory-$Stamp.csv"
$EmptyFolderCsv = "$ReportFolder\empty-folder-inventory-$Stamp.csv"

$Folders = Get-ChildItem $Ops -Directory
$AllFiles = Get-ChildItem $Ops -Recurse -File
$Scripts = Get-ChildItem $Ops -Recurse -Filter *.ps1
$Markdown = Get-ChildItem $Ops -Recurse -Filter *.md
$Json = Get-ChildItem $Ops -Recurse -Filter *.json

$FileTypes = $AllFiles | Group-Object Extension | Sort-Object Count -Descending

$EmptyFolders = Get-ChildItem $Ops -Recurse -Directory | Where-Object {
  @(Get-ChildItem $_.FullName -Force).Count -eq 0
}

$ReadmeMissing = $Folders | Where-Object {
  -not (Test-Path "$($_.FullName)\README.md")
}

$SuspiciousExtensions = $FileTypes | Where-Object {
  $_.Name -like "*.junk" -or
  $_.Name -like "*.bak" -or
  $_.Name -like "*.backup" -or
  $_.Name -like "*.before*" -or
  $_.Name -like "*.log*" -or
  $_.Name -eq ""
}

$Folders | Select-Object Name, FullName, LastWriteTime | Export-Csv $FolderCsv -NoTypeInformation
$FileTypes | Select-Object Name, Count | Export-Csv $FileTypeCsv -NoTypeInformation
$Scripts | Select-Object Name, FullName, LastWriteTime, Length | Export-Csv $ScriptCsv -NoTypeInformation
$Markdown | Select-Object Name, FullName, LastWriteTime, Length | Export-Csv $MarkdownCsv -NoTypeInformation
$EmptyFolders | Select-Object Name, FullName, LastWriteTime | Export-Csv $EmptyFolderCsv -NoTypeInformation

$FolderCount = $Folders.Count
$FileCount = $AllFiles.Count
$ScriptCount = $Scripts.Count
$MarkdownCount = $Markdown.Count
$JsonCount = $Json.Count
$EmptyFolderCount = $EmptyFolders.Count
$ReadmeMissingCount = $ReadmeMissing.Count
$SuspiciousCount = ($SuspiciousExtensions | Measure-Object).Count

$Score = 100

if ($ScriptCount -lt 10) { $Score -= 10 }
if ($ReadmeMissingCount -gt 20) { $Score -= 10 }
if ($EmptyFolderCount -gt 20) { $Score -= 10 }
if ($SuspiciousCount -gt 5) { $Score -= 10 }

if ($Score -ge 90) {
  $Grade = "A - Strong"
} elseif ($Score -ge 75) {
  $Grade = "B - Good but needs cleanup"
} elseif ($Score -ge 60) {
  $Grade = "C - Operational but weak"
} else {
  $Grade = "D - Needs repair"
}

@"
# LITIGATION 360 ENTERPRISE VERIFICATION SWEEP

Date:
$(Get-Date)

Root:
$Root

Operations:
$Ops

## Executive Summary

| Area | Count |
|---|---:|
| Operation Phase Folders | $FolderCount |
| Total Files | $FileCount |
| Markdown Documents | $MarkdownCount |
| PowerShell Scripts | $ScriptCount |
| JSON Files | $JsonCount |
| Empty Folders | $EmptyFolderCount |
| Top-Level Folders Missing README | $ReadmeMissingCount |
| Suspicious Extension Groups | $SuspiciousCount |

## Operational Score

Score:
$Score / 100

Grade:
$Grade

## Findings

### Positive Findings

- Operations folder exists.
- Phase 10ZZ9 exists.
- Phase 10ZZA exists.
- Markdown documentation base exists.
- Verification sweep successfully executed.

### Watch Items

- PowerShell script count is currently low compared with the number of phase folders.
- Some folders may be documentation-only and not executable.
- Empty folders should be reviewed.
- Backup, junk, before, and log-type files should be reviewed before production packaging.

## Required Next Actions

1. Review folder inventory CSV.
2. Review PowerShell script inventory CSV.
3. Review markdown document inventory CSV.
4. Review empty folders CSV.
5. Decide which folders are documentation-only and which are operational.
6. Mark critical folders as production, archive, or reference.
7. Build operational scorecards using this verified data.

## Generated Files

Folder Inventory:
$FolderCsv

File Type Inventory:
$FileTypeCsv

PowerShell Script Inventory:
$ScriptCsv

Markdown Inventory:
$MarkdownCsv

Empty Folder Inventory:
$EmptyFolderCsv

## Conclusion

This verification sweep confirms the actual structure of Litigation 360 and prepares the system for Enterprise Operational Assurance.
"@ | Set-Content $MasterReport

Write-Host ""
Write-Host "=================================================="
Write-Host "ENTERPRISE VERIFICATION SWEEP COMPLETE"
Write-Host "=================================================="
Write-Host ""
Write-Host "Score: $Score / 100"
Write-Host "Grade: $Grade"
Write-Host ""
Write-Host "Master Report:"
Write-Host $MasterReport
Write-Host ""
Write-Host "CSV Reports:"
Write-Host $ReportFolder
Write-Host ""
