$Root = "C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software"
$Ops = "$Root\_operations"
$Phase = "$Ops\phase-10ZZA3-enterprise-automation-assurance"
$Reports = "$Phase\reports"

New-Item -ItemType Directory -Force -Path $Reports | Out-Null

$Stamp = Get-Date -Format "yyyy-MM-dd-HHmmss"
$Report = "$Reports\WEEKLY-GOVERNANCE-AUDIT-$Stamp.md"

$Folders = Get-ChildItem $Ops -Directory
$AllFolders = Get-ChildItem $Ops -Recurse -Directory
$Files = Get-ChildItem $Ops -Recurse -File
$Scripts = Get-ChildItem $Ops -Recurse -Filter *.ps1
$Markdown = Get-ChildItem $Ops -Recurse -Filter *.md

$ReadmeMissing = $Folders | Where-Object { -not (Test-Path "$($_.FullName)\README.md") }
$EmptyFolders = $AllFolders | Where-Object { @(Get-ChildItem $_.FullName -Force).Count -eq 0 }
$Suspicious = $Files | Where-Object {
  $_.Extension -in @(".junk",".bak",".backup",".log") -or
  $_.Name -like "*.before*" -or
  $_.Extension -eq ""
}

$Score = 100
if ($ReadmeMissing.Count -gt 20) { $Score -= 10 }
if ($EmptyFolders.Count -gt 20) { $Score -= 10 }
if ($Scripts.Count -lt 10) { $Score -= 10 }
if ($Suspicious.Count -gt 20) { $Score -= 10 }

$Grade = if ($Score -ge 90) { "A - Strong" } elseif ($Score -ge 75) { "B - Good" } elseif ($Score -ge 60) { "C - Needs Strengthening" } else { "D - Repair Required" }

@"
# WEEKLY GOVERNANCE AUDIT REPORT

Date:
$(Get-Date)

Governance Score:
$Score / 100

Grade:
$Grade

## Inventory

Top-Level Operation Folders:
$($Folders.Count)

All Operation Subfolders:
$($AllFolders.Count)

Total Files:
$($Files.Count)

Markdown Documents:
$($Markdown.Count)

PowerShell Scripts:
$($Scripts.Count)

## Findings

Top-Level Folders Missing README:
$($ReadmeMissing.Count)

Empty Folders:
$($EmptyFolders.Count)

Suspicious Files:
$($Suspicious.Count)

## Missing README Folder Names

$(
if ($ReadmeMissing.Count -eq 0) {
  "None"
} else {
  $ReadmeMissing | Select-Object -First 50 -ExpandProperty Name | ForEach-Object { "- $_" } | Out-String
}
)

## Decision

$(if ($Score -ge 90) { "Governance structure is strong." } elseif ($Score -ge 75) { "Governance is operational but needs cleanup." } else { "Pause expansion and repair governance gaps." })
"@ | Set-Content $Report

Write-Host ""
Write-Host "WEEKLY GOVERNANCE AUDIT COMPLETE"
Write-Host "Score: $Score / 100"
Write-Host "Grade: $Grade"
Write-Host "Report: $Report"
Write-Host ""
