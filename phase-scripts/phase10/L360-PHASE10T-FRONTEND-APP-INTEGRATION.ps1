param([ValidateSet("DRYRUN","APPLY")][string]$Mode="DRYRUN")

$Root="C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software"
$Frontend=Join-Path $Root "frontend"
$Src=Join-Path $Frontend "src"
$Phase=Join-Path $Root "_operations\phase-10T-frontend-app-integration"
$Reports=Join-Path $Phase "reports"
$Backups=Join-Path $Phase "backups"
$Logs=Join-Path $Phase "logs"
$Docs=Join-Path $Phase "docs"
$Validation=Join-Path $Phase "validation"

New-Item -ItemType Directory -Force -Path $Reports,$Backups,$Logs,$Docs,$Validation | Out-Null

$AppFile=Join-Path $Src "App.jsx"
$AltAppFile=Join-Path $Src "App.js"
$DashboardFile=Join-Path $Src "enterprise\pages\EnterpriseOperationsDashboard.jsx"
$Log=Join-Path $Logs "phase-10T-log.txt"

function Backup($Path){
  if(Test-Path -LiteralPath $Path){
    $name=Split-Path $Path -Leaf
    $dest=Join-Path $Backups ($name+"."+(Get-Date -Format "yyyyMMdd_HHmmss")+".bak")
    Copy-Item -LiteralPath $Path -Destination $dest -Force
    Add-Content -LiteralPath $Log -Value "Backup $Path --> $dest"
  }
}

Clear-Host
Write-Host "============================================================"
Write-Host "L360 PHASE 10T FRONTEND APP INTEGRATION"
Write-Host "============================================================"
Write-Host "Mode: $Mode"
Write-Host ""

if(!(Test-Path -LiteralPath $Frontend)){
  Write-Host "ERROR: frontend folder not found." -ForegroundColor Red
  Read-Host "Press Enter"
  exit 1
}

if(!(Test-Path -LiteralPath $DashboardFile)){
  Write-Host "ERROR: EnterpriseOperationsDashboard.jsx not found. Run Phase 10S V2 first." -ForegroundColor Red
  Read-Host "Press Enter"
  exit 1
}

$TargetApp=$AppFile
if(!(Test-Path -LiteralPath $TargetApp)){
  $TargetApp=$AltAppFile
}

if($Mode -eq "APPLY"){
  if(Test-Path -LiteralPath $TargetApp){
    Backup $TargetApp
  }

@'
import React, { useState } from "react";
import EnterpriseOperationsDashboard from "./enterprise/pages/EnterpriseOperationsDashboard";

function LegacyHome() {
  return (
    <div style={{ padding: 24, fontFamily: "Arial, sans-serif" }}>
      <h1>Litigation 360</h1>
      <p>Frontend shell active.</p>
      <p>Use the Enterprise Operations Dashboard button above to view Phase 10 monitoring.</p>
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
        <button onClick={() => setView("home")}>Home</button>
        <span style={{ marginLeft: "auto", fontSize: 12 }}>
          Phase 10T Frontend App Integration
        </span>
      </div>

      {view === "enterprise" ? <EnterpriseOperationsDashboard /> : <LegacyHome />}
    </div>
  );
}
'@ | Out-File -LiteralPath $TargetApp -Encoding UTF8
}

$Validate=Join-Path $Validation "validate-phase10T.js"

@"
const fs = require("fs");
const path = require("path");

const app = process.env.L360_APP_FILE;
const dashboard = process.env.L360_DASHBOARD_FILE;
const reports = process.env.L360_REPORTS_DIR;

fs.mkdirSync(reports, { recursive: true });

function has(file, text) {
  return fs.existsSync(file) && fs.readFileSync(file, "utf8").includes(text);
}

const report = {
  phase: "10T",
  module: "Frontend App Integration",
  timestamp: new Date().toISOString(),
  files: {
    appExists: fs.existsSync(app),
    dashboardExists: fs.existsSync(dashboard)
  },
  content: {
    appImportsDashboard: has(app, "EnterpriseOperationsDashboard"),
    appHasEnterpriseButton: has(app, "Enterprise Dashboard"),
    appHasPhaseMarker: has(app, "Phase 10T")
  }
};

report.status = (
  report.files.appExists &&
  report.files.dashboardExists &&
  report.content.appImportsDashboard &&
  report.content.appHasEnterpriseButton &&
  report.content.appHasPhaseMarker
) ? "PASS" : "FAIL";

fs.writeFileSync(path.join(reports, "phase10T-frontend-app-integration-report.json"), JSON.stringify(report, null, 2));

console.log([
  "LITIGATION 360 - PHASE 10T FRONTEND APP INTEGRATION REPORT",
  "=========================================================",
  "",
  "Timestamp: " + report.timestamp,
  "Status: " + report.status,
  "App Exists: " + report.files.appExists,
  "Dashboard Exists: " + report.files.dashboardExists,
  "App Imports Dashboard: " + report.content.appImportsDashboard,
  "Enterprise Button Present: " + report.content.appHasEnterpriseButton,
  "Phase Marker Present: " + report.content.appHasPhaseMarker
].join("\n"));

if (report.status !== "PASS") process.exit(1);
"@ | Out-File -LiteralPath $Validate -Encoding UTF8

@"
# LITIGATION 360 - PHASE 10T FRONTEND APP INTEGRATION

## Purpose
Wire the Phase 10S Enterprise Operations Dashboard into the frontend app shell.

## Modified File
- frontend\src\App.jsx or frontend\src\App.js

## Required Existing File
- frontend\src\enterprise\pages\EnterpriseOperationsDashboard.jsx

## Run Frontend
cd /d "$Frontend"
npm run dev

## Expected
The frontend should open with a top bar and Enterprise Dashboard visible.
"@ | Out-File -LiteralPath (Join-Path $Docs "PHASE10T-FRONTEND-APP-INTEGRATION.md") -Encoding UTF8

Write-Host ""
Write-Host "Running validation..."
$env:L360_APP_FILE=$TargetApp
$env:L360_DASHBOARD_FILE=$DashboardFile
$env:L360_REPORTS_DIR=$Reports
node $Validate
$exit=$LASTEXITCODE

Write-Host ""
Write-Host "App File:"
Write-Host $TargetApp
Write-Host ""
Write-Host "Reports:"
Write-Host $Reports
Write-Host ""
Write-Host "Backups:"
Write-Host $Backups
Write-Host ""

if($exit -eq 0){Write-Host "PHASE 10T FRONTEND APP INTEGRATION STATUS: PASS" -ForegroundColor Green}else{Write-Host "PHASE 10T FRONTEND APP INTEGRATION STATUS: FAIL" -ForegroundColor Yellow}
Read-Host "Press Enter to close"
exit $exit
