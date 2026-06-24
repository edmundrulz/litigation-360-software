param(
    [string]$PmoRoot = ""
)

Set-StrictMode -Version 2.0
$ErrorActionPreference = "Stop"

if ([string]::IsNullOrWhiteSpace($PmoRoot)) {
    $ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
    $PmoRoot = Split-Path -Parent $ScriptDir
}

$tasks = Import-Csv (Join-Path $PmoRoot "01_DATABASE\TASKS.csv")
$today = Get-Date
$dueSoon = $tasks | Where-Object {
    $_.Status -ne "COMPLETED" -and
    $_.DueDate -and
    ([datetime]$_.DueDate) -le $today.AddDays(3)
}

$path = Join-Path $PmoRoot "12_REMINDERS\REMINDER-LATEST.md"

if (@($dueSoon).Count -eq 0) {
    $body = "# PMO REMINDER`r`n`r`nNo tasks due in the next 3 days."
}
else {
    $lines = ($dueSoon | ForEach-Object {
        "- $($_.TaskID): $($_.TaskName) | Priority: $($_.Priority) | Due: $($_.DueDate) | Status: $($_.Status)"
    }) -join "`r`n"

    $body = "# PMO REMINDER`r`n`r`nTasks due in the next 3 days:`r`n`r`n$lines"
}

$utf8NoBom = New-Object System.Text.UTF8Encoding($false)
[System.IO.File]::WriteAllText($path, $body, $utf8NoBom)

Write-Host "[PASS] Reminder generated:" -ForegroundColor Green
Write-Host $path