param(
    [string]$PmoRoot = "",
    [string]$TaskID = "",
    [string]$Status = "",
    [string]$PercentComplete = "",
    [string]$VerificationStatus = "",
    [string]$EvidencePath = "",
    [string]$NextAction = ""
)

Set-StrictMode -Version 2.0
$ErrorActionPreference = "Stop"

if ([string]::IsNullOrWhiteSpace($PmoRoot)) {
    $ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
    $PmoRoot = Split-Path -Parent $ScriptDir
}

$tasksPath = Join-Path $PmoRoot "01_DATABASE\TASKS.csv"

if (!(Test-Path $tasksPath)) {
    throw "TASKS.csv not found: $tasksPath"
}

if ([string]::IsNullOrWhiteSpace($TaskID)) {
    $TaskID = Read-Host "Enter Task ID, example TASK-0001"
}

$tasks = Import-Csv $tasksPath
$task = $tasks | Where-Object { $_.TaskID -eq $TaskID } | Select-Object -First 1

if (!$task) {
    throw "Task ID not found: $TaskID"
}

if ([string]::IsNullOrWhiteSpace($Status)) {
    $Status = Read-Host "Enter status: PENDING / IN_PROGRESS / COMPLETED / BLOCKED"
}

if ([string]::IsNullOrWhiteSpace($PercentComplete)) {
    $PercentComplete = Read-Host "Enter percent complete, 0-100"
}

if ([string]::IsNullOrWhiteSpace($VerificationStatus)) {
    $VerificationStatus = Read-Host "Enter verification status, example PENDING EVIDENCE / PASS / FAIL"
}

if ([string]::IsNullOrWhiteSpace($EvidencePath)) {
    $EvidencePath = Read-Host "Enter evidence path or leave blank"
}

if ([string]::IsNullOrWhiteSpace($NextAction)) {
    $NextAction = Read-Host "Enter next action"
}

foreach ($row in $tasks) {
    if ($row.TaskID -eq $TaskID) {
        $row.Status = $Status
        $row.PercentComplete = $PercentComplete
        $row.VerificationStatus = $VerificationStatus
        $row.EvidencePath = $EvidencePath
        $row.NextAction = $NextAction
        $row.LastUpdated = Get-Date -Format "yyyy-MM-dd HH:mm:ss"

        if ($Status -eq "COMPLETED" -and [string]::IsNullOrWhiteSpace($row.CompletedDate)) {
            $row.CompletedDate = Get-Date -Format "yyyy-MM-dd"
        }
    }
}

$tasks | Export-Csv -Path $tasksPath -NoTypeInformation

$audit = Join-Path $PmoRoot "09_AUDIT_LOGS\AUDIT_TRAIL.csv"
[PSCustomObject]@{
    Timestamp=(Get-Date -Format "yyyy-MM-dd HH:mm:ss")
    Action="Task updated"
    Status="PASS"
    Detail="$TaskID updated to $Status"
    Script="02-ADD-PROGRESS-UPDATE.ps1"
    User=$env:USERNAME
} | Export-Csv -Path $audit -NoTypeInformation -Append

Write-Host "[PASS] Task updated: $TaskID" -ForegroundColor Green