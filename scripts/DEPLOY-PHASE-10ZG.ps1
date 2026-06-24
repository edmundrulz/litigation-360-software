$ROOT = "C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software"
$OPS = "$ROOT\_operations\phase-10ZG-dashboard-framework"
$BACKUPS = "$OPS\backups"
$REPORTS = "$OPS\reports"
$DOCS = "$ROOT\docs\phase-10ZG"
$REPORT = "$REPORTS\PHASE-10ZG-DEPLOYMENT-REPORT.txt"
$BLUEPRINT = "$DOCS\PHASE-10ZG-DASHBOARD-BLUEPRINT.md"

New-Item -ItemType Directory -Force -Path $OPS, $BACKUPS, $REPORTS, $DOCS | Out-Null

"PHASE 10ZG DEPLOYMENT REPORT" | Set-Content $REPORT
"Date: $(Get-Date)" | Add-Content $REPORT

Copy-Item "$ROOT\frontend\src\App.jsx" "$BACKUPS\App.jsx.before-10ZG" -Force
Copy-Item "$ROOT\frontend\src\App.css" "$BACKUPS\App.css.before-10ZG" -Force

@"
# PHASE 10ZG — ENTERPRISE DASHBOARD FRAMEWORK

## 1. Executive Health
System health, database status, deployment readiness, risk level.

## 2. Operations Centre
Monitoring, governance, performance, backup recovery, navigation, deployment centre.

## 3. Matter Statistics
Future matter, client, case, document, staff, and court-date counts.

## 4. Staff Statistics
Future workload and role-based statistics.

## 5. KPI Panel
Open matters, closed matters, upcoming hearings, pending documents, compliance score.

## 6. Monitoring Panel
Realtime endpoint health and enterprise status.

## 7. Roadmap Panel
Legal AI, client portal, workflow automation, predictive analytics, marketplace, mobile app.

## 8. Future Integrations
Court systems, government portals, maps, finance, AI agents, autonomous operations.

## Rule
Phase 10ZG must not break Phase 10ZF navigation.
"@ | Set-Content $BLUEPRINT

@"
@echo off
set ROOT=$ROOT
copy "%ROOT%\_operations\phase-10ZG-dashboard-framework\backups\App.jsx.before-10ZG" "%ROOT%\frontend\src\App.jsx"
copy "%ROOT%\_operations\phase-10ZG-dashboard-framework\backups\App.css.before-10ZG" "%ROOT%\frontend\src\App.css"
cd /d "%ROOT%\frontend"
npm run build
pause
"@ | Set-Content "$ROOT\scripts\ROLLBACK-PHASE-10ZG.bat"

cd "$ROOT\frontend"
npm run build
if ($LASTEXITCODE -ne 0) {
  "BUILD: FAIL" | Add-Content $REPORT
  Write-Host "PHASE 10ZG FAILED"
  Write-Host "Run rollback: scripts\ROLLBACK-PHASE-10ZG.bat"
  exit 1
}

cd "$ROOT"
curl.exe -s http://localhost:5000/api/health | Add-Content $REPORT
curl.exe -s http://localhost:5000/api/enterprise/monitoring/health | Add-Content $REPORT
curl.exe -s http://localhost:5000/api/enterprise/deployment-centre/health | Add-Content $REPORT

"BUILD: PASS" | Add-Content $REPORT
"PHASE 10ZG GOVERNANCE + BLUEPRINT: PASS" | Add-Content $REPORT

Write-Host ""
Write-Host "PHASE 10ZG GOVERNANCE + BLUEPRINT: PASS"
Write-Host "Blueprint created."
Write-Host "Backup created."
Write-Host "Rollback created."
Write-Host "Report created."