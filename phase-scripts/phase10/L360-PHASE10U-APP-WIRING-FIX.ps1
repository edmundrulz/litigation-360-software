param([ValidateSet("DRYRUN","APPLY")][string]$Mode="DRYRUN")

$Root="C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software"
$Frontend=Join-Path $Root "frontend"
$Src=Join-Path $Frontend "src"
$Phase=Join-Path $Root "_operations\phase-10U-app-wiring-fix"
$Reports=Join-Path $Phase "reports"
$Backups=Join-Path $Phase "backups"
$Docs=Join-Path $Phase "docs"
$Validation=Join-Path $Phase "validation"

New-Item -ItemType Directory -Force -Path $Reports,$Backups,$Docs,$Validation | Out-Null

$AppFile=Join-Path $Src "App.jsx"
if(!(Test-Path -LiteralPath $AppFile)){ $AppFile=Join-Path $Src "App.js" }

$DashboardFile=Join-Path $Src "enterprise\pages\EnterpriseOperationsDashboard.jsx"
$ConnectivityFile=Join-Path $Src "enterprise\pages\FrontendBackendConnectivityValidator.jsx"

function Backup($Path){
  if(Test-Path -LiteralPath $Path){
    $name=Split-Path $Path -Leaf
    $dest=Join-Path $Backups ($name+"."+(Get-Date -Format "yyyyMMdd_HHmmss")+".bak")
    Copy-Item -LiteralPath $Path -Destination $dest -Force
  }
}

Clear-Host
Write-Host "============================================================"
Write-Host "L360 PHASE 10U APP WIRING FIX"
Write-Host "============================================================"
Write-Host "Mode: $Mode"

if(!(Test-Path -LiteralPath $ConnectivityFile)){
  Write-Host "ERROR: Connectivity page missing. Run Phase 10U first." -ForegroundColor Red
  Read-Host "Press Enter"
  exit 1
}

if(!(Test-Path -LiteralPath $DashboardFile)){
  Write-Host "ERROR: Enterprise dashboard page missing. Run Phase 10S first." -ForegroundColor Red
  Read-Host "Press Enter"
  exit 1
}

if($Mode -eq "APPLY"){
  Backup $AppFile

@'
import React, { useState } from "react";
import EnterpriseOperationsDashboard from "./enterprise/pages/EnterpriseOperationsDashboard";
import FrontendBackendConnectivityValidator from "./enterprise/pages/FrontendBackendConnectivityValidator";

function LegacyHome() {
  return (
    <div style={{ padding: 24, fontFamily: "Arial, sans-serif" }}>
      <h1>Litigation 360</h1>
      <p>Frontend shell active.</p>
      <p>Use the buttons above to open the Enterprise Dashboard or Connectivity Validator.</p>
    </div>
  );
}

export default function App() {
  const [view, setView] = useState("enterprise");

  return (
    <div>
      <div style={{
        display: "flex",
        gap: 12,
        alignItems: "center",
        padding: "12px 18px",
        borderBottom: "1px solid #ddd",
        fontFamily: "Arial, sans-serif",
        background: "#f8fafc",
        position: "sticky",
        top: 0,
        zIndex: 10
      }}>
        <strong>Litigation 360</strong>
        <button onClick={() => setView("enterprise")}>Enterprise Dashboard</button>
        <button onClick={() => setView("connectivity")}>Connectivity Validator</button>
        <button onClick={() => setView("home")}>Home</button>
        <span style={{ marginLeft: "auto", fontSize: 12 }}>
          Phase 10U Frontend Backend Connectivity
        </span>
      </div>

      {view === "enterprise" ? (
        <EnterpriseOperationsDashboard />
      ) : view === "connectivity" ? (
        <FrontendBackendConnectivityValidator />
      ) : (
        <LegacyHome />
      )}
    </div>
  );
}
'@ | Out-File -LiteralPath $AppFile -Encoding UTF8
}

$Validate=Join-Path $Validation "validate-phase10U-app-wiring-fix.js"

@"
const fs = require("fs");
const path = require("path");

const app = process.env.L360_APP_FILE;
const dashboard = process.env.L360_DASHBOARD_FILE;
const connectivity = process.env.L360_CONNECTIVITY_FILE;
const reports = process.env.L360_REPORTS_DIR;

fs.mkdirSync(reports, { recursive: true });

function has(file, text) {
  return fs.existsSync(file) && fs.readFileSync(file, "utf8").includes(text);
}

const report = {
  phase: "10U-APP-WIRING-FIX",
  timestamp: new Date().toISOString(),
  files: {
    appExists: fs.existsSync(app),
    dashboardExists: fs.existsSync(dashboard),
    connectivityExists: fs.existsSync(connectivity)
  },
  content: {
    appImportsDashboard: has(app, "EnterpriseOperationsDashboard"),
    appImportsConnectivity: has(app, "FrontendBackendConnectivityValidator"),
    appHasConnectivityButton: has(app, "Connectivity Validator"),
    appHasEnterpriseButton: has(app, "Enterprise Dashboard"),
    appHasPhaseMarker: has(app, "Phase 10U")
  }
};

report.status = (
  report.files.appExists &&
  report.files.dashboardExists &&
  report.files.connectivityExists &&
  report.content.appImportsDashboard &&
  report.content.appImportsConnectivity &&
  report.content.appHasConnectivityButton &&
  report.content.appHasEnterpriseButton &&
  report.content.appHasPhaseMarker
) ? "PASS" : "FAIL";

fs.writeFileSync(path.join(reports, "phase10U-app-wiring-fix-report.json"), JSON.stringify(report, null, 2));

console.log([
  "LITIGATION 360 - PHASE 10U APP WIRING FIX REPORT",
  "================================================",
  "",
  "Timestamp: " + report.timestamp,
  "Status: " + report.status,
  "App Exists: " + report.files.appExists,
  "Dashboard Exists: " + report.files.dashboardExists,
  "Connectivity Exists: " + report.files.connectivityExists,
  "App Imports Dashboard: " + report.content.appImportsDashboard,
  "App Imports Connectivity: " + report.content.appImportsConnectivity,
  "Connectivity Button Present: " + report.content.appHasConnectivityButton,
  "Enterprise Button Present: " + report.content.appHasEnterpriseButton,
  "Phase Marker Present: " + report.content.appHasPhaseMarker
].join("\\n"));

if (report.status !== "PASS") process.exit(1);
"@ | Out-File -LiteralPath $Validate -Encoding UTF8

Write-Host ""
Write-Host "Running validation..."
$env:L360_APP_FILE=$AppFile
$env:L360_DASHBOARD_FILE=$DashboardFile
$env:L360_CONNECTIVITY_FILE=$ConnectivityFile
$env:L360_REPORTS_DIR=$Reports
node $Validate
$exit=$LASTEXITCODE

Write-Host ""
Write-Host "Reports:"
Write-Host $Reports
Write-Host ""
Write-Host "Backups:"
Write-Host $Backups

if($exit -eq 0){
  Write-Host "PHASE 10U APP WIRING FIX STATUS: PASS" -ForegroundColor Green
}else{
  Write-Host "PHASE 10U APP WIRING FIX STATUS: FAIL" -ForegroundColor Yellow
}

Read-Host "Press Enter to close"
exit $exit
