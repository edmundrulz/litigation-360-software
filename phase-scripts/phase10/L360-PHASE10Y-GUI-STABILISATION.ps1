$Root = "C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software"
$Frontend = "$Root\frontend"
$Src = "$Frontend\src"
$Ops = "$Root\_operations\phase-10Y-gui-stabilisation"
$Stamp = Get-Date -Format "yyyyMMdd_HHmmss"
$Backup = "$Ops\backups\src_$Stamp"

New-Item -ItemType Directory -Force -Path $Ops, "$Ops\backups", "$Ops\reports", "$Ops\docs", "$Ops\logs" | Out-Null
Copy-Item $Src $Backup -Recurse -Force

$AppPath = "$Src\App.jsx"
$CssPath = "$Src\App.css"

$App = Get-Content $AppPath -Raw

$App = $App -replace 'End User Legal Workspace', 'End User Legal Workspace - Role Dashboard'
$App = $App -replace 'Welcome Back', 'Welcome Back - Litigation 360 Workspace'
$App = $App -replace 'This is the normal user workspace\. No raw JSON\. No developer diagnostics\. No merged headings\.', 'Role-based daily workspace for lawyers, clerks, admin staff, finance, HR, partners, and system operators.'

$App = $App -replace '\["Reports", "Matter summaries, workload reports and executive overview\."\]', @'
["Reports", "Matter summaries, workload reports and executive overview."],
    ["Lawyer View", "Hearings, active matters, client updates, pleadings, deadlines and court preparation."],
    ["Clerk View", "Filing tasks, court dates, service tracking, document bundles and registry follow-ups."],
    ["Admin View", "Client intake, appointment scheduling, reminders, correspondence and office coordination."],
    ["Finance View", "Invoices, payments, disbursements, billing status and financial follow-up."],
    ["Partner View", "Firm-wide performance, risk view, workload overview and strategic supervision."]
'@

Set-Content -Encoding UTF8 $AppPath $App

Add-Content -Encoding UTF8 $CssPath @'

/* Phase 10Y Stabilisation Enhancements */
.card {
  min-height: 165px;
}

.card:hover {
  transform: translateY(-2px);
  transition: 0.15s ease;
}

.sidebar {
  position: sticky;
  top: 0;
  height: 100vh;
}

.actions button:hover,
.summary button:hover,
.sidebar button:hover {
  opacity: 0.9;
}

.topbar {
  position: sticky;
  top: 0;
  z-index: 5;
}

@media (max-width: 850px) {
  .sidebar {
    position: relative;
    height: auto;
  }
}
'@

@'
# Phase 10Y GUI Stabilisation Documentation

## Objective
Stabilise the improved Litigation 360 frontend GUI.

## Added
- Role-based dashboard cards
- Lawyer View
- Clerk View
- Admin View
- Finance View
- Partner View
- Improved layout stability
- Sticky sidebar
- Sticky topbar
- Backup before modification
- Build validation

## Protocol
End User Workspace remains the default screen.
Developer diagnostics remain separated.
Raw JSON remains inside Developer Centre only.
'@ | Set-Content -Encoding UTF8 "$Ops\docs\PHASE10Y_DOCUMENTATION.md"

@'
# Phase 10Y Verification Checklist

[ ] Frontend builds successfully
[ ] End User Workspace appears first
[ ] Role cards appear
[ ] No broken PERKESO encoding
[ ] No raw JSON on user workspace
[ ] Sidebar works
[ ] Developer Centre still exists
[ ] Operations Centre still exists
[ ] Admin Centre still exists
[ ] Cards do not overlap
[ ] Header does not merge
'@ | Set-Content -Encoding UTF8 "$Ops\reports\PHASE10Y_VERIFICATION_CHECKLIST.md"

Set-Location $Frontend
npm run build | Tee-Object "$Ops\logs\npm-build-$Stamp.log"

Write-Host ""
Write-Host "PHASE 10Y GUI STABILISATION COMPLETE"
Write-Host "Backup: $Backup"
Write-Host "Docs: $Ops\docs"
Write-Host "Reports: $Ops\reports"
Write-Host ""
Write-Host "Next run:"
Write-Host "cd /d $Frontend"
Write-Host "npm run dev"