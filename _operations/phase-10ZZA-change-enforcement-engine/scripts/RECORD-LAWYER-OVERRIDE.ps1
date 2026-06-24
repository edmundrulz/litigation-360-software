param(
  [string]$User = "Unknown User",
  [string]$MatterID = "Unknown Matter",
  [string]$Recommendation = "System recommendation not provided",
  [string]$Decision = "User override",
  [string]$Reason = "Reason not provided"
)

$Phase = "C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software\_operations\phase-10ZZA-change-enforcement-engine"
$Registry = "$Phase\04-override-registry\LAWYER-OVERRIDE-REGISTRY.md"

$OverrideID = "OVR-" + (Get-Date -Format "yyyyMMdd-HHmmss")
$Date = Get-Date -Format "yyyy-MM-dd"
$Time = Get-Date -Format "HH:mm:ss"

$Line = "| $OverrideID | $Date | $Time | $User | $MatterID | $Recommendation | $Decision | $Reason | Yes |"

Add-Content $Registry $Line

Write-Host ""
Write-Host "LAWYER OVERRIDE RECORDED"
Write-Host "Override ID: $OverrideID"
Write-Host "Registry: $Registry"
Write-Host ""
