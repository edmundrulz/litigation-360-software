$Root = "C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software"
$In = "$Root\enterprise\reports\ProductionRouteSummary.csv"
$Out = "$Root\enterprise\architecture\ProductionRouteMap.md"

$routes = Import-Csv $In

$body = @()
$body += "# Litigation 360 Production Route Map"
$body += ""
$body += "Generated: $(Get-Date)"
$body += ""
$body += "## Summary"
$body += ""
$body += "Production route files identified: $($routes.Count)"
$body += ""
$body += "## Production Route Files"
$body += ""
$body += "| Count | Route File |"
$body += "|---:|---|"

foreach ($r in $routes) {
    $body += "| $($r.Count) | $($r.Name) |"
}

$body | Set-Content $Out

Write-Host "DONE:"
Write-Host $Out