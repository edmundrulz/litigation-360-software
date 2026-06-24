param([ValidateSet("DRYRUN","APPLY")][string]$Mode="DRYRUN")

$Root="C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software"
$Frontend=Join-Path $Root "frontend"
$Src=Join-Path $Frontend "src"
$Enterprise=Join-Path $Src "enterprise"
$ApiDir=Join-Path $Enterprise "api"
$ComponentsDir=Join-Path $Enterprise "components"
$PagesDir=Join-Path $Enterprise "pages"
$Phase=Join-Path $Root "_operations\phase-10U-frontend-backend-connectivity-validator"
$Reports=Join-Path $Phase "reports"
$Backups=Join-Path $Phase "backups"
$Logs=Join-Path $Phase "logs"
$Docs=Join-Path $Phase "docs"
$Validation=Join-Path $Phase "validation"

New-Item -ItemType Directory -Force -Path $ApiDir,$ComponentsDir,$PagesDir,$Reports,$Backups,$Logs,$Docs,$Validation | Out-Null

$ApiFile=Join-Path $ApiDir "connectivityValidatorApi.js"
$PanelFile=Join-Path $ComponentsDir "BackendConnectivityPanel.jsx"
$PageFile=Join-Path $PagesDir "FrontendBackendConnectivityValidator.jsx"
$AppFile=Join-Path $Src "App.jsx"
if(!(Test-Path -LiteralPath $AppFile)){ $AppFile=Join-Path $Src "App.js" }

function Backup($Path){
  if(Test-Path -LiteralPath $Path){
    $name=Split-Path $Path -Leaf
    $dest=Join-Path $Backups ($name+"."+(Get-Date -Format "yyyyMMdd_HHmmss")+".bak")
    Copy-Item -LiteralPath $Path -Destination $dest -Force
  }
}

Clear-Host
Write-Host "============================================================"
Write-Host "L360 PHASE 10U FRONTEND BACKEND CONNECTIVITY VALIDATOR"
Write-Host "============================================================"
Write-Host "Mode: $Mode"
Write-Host ""

if(!(Test-Path -LiteralPath $Frontend)){
  Write-Host "ERROR: frontend folder not found." -ForegroundColor Red
  Read-Host "Press Enter"
  exit 1
}

if($Mode -eq "APPLY"){
  Backup $ApiFile
  Backup $PanelFile
  Backup $PageFile
  Backup $AppFile

@'
const API_BASE = "http://localhost:5000";

const ENTERPRISE_ENDPOINTS = [
  { key: "monitoring", label: "Monitoring", path: "/api/enterprise/monitoring/health" },
  { key: "hardening", label: "Hardening Readiness", path: "/api/enterprise/hardening/deployment/readiness" },
  { key: "backupRecovery", label: "Backup Recovery", path: "/api/enterprise/backup-recovery/health" },
  { key: "performance", label: "Performance", path: "/api/enterprise/performance/health" },
  { key: "governance", label: "Governance", path: "/api/enterprise/governance/health" },
  { key: "autonomous", label: "Autonomous Operations", path: "/api/enterprise/autonomous/health" },
  { key: "maps", label: "Maps Integration", path: "/api/enterprise/maps/health" },
  { key: "navigation", label: "Court Navigation", path: "/api/enterprise/navigation/health" },
  { key: "predictive", label: "Predictive Analytics", path: "/api/enterprise/predictive/health" },
  { key: "assistant", label: "Legal Assistant", path: "/api/enterprise/assistant/health" },
  { key: "commandCentre", label: "Command Centre", path: "/api/enterprise/command-centre/health" },
  { key: "documents", label: "Document Lifecycle", path: "/api/enterprise/documents/lifecycle/health" },
  { key: "courtOperations", label: "Court Operations", path: "/api/enterprise/court-operations/health" },
  { key: "matterIntelligence", label: "Matter Intelligence", path: "/api/enterprise/matters/intelligence/health" }
];

async function testEndpoint(endpoint) {
  const startedAt = performance.now();

  try {
    const response = await fetch(`${API_BASE}${endpoint.path}`);
    const durationMs = Math.round((performance.now() - startedAt) * 100) / 100;

    let data = null;
    try {
      data = await response.json();
    } catch {
      data = { parseError: true };
    }

    return {
      ...endpoint,
      ok: response.ok,
      httpStatus: response.status,
      durationMs,
      data,
      status: response.ok ? "PASS" : "FAIL",
      testedAt: new Date().toISOString()
    };
  } catch (err) {
    return {
      ...endpoint,
      ok: false,
      httpStatus: "NETWORK_ERROR",
      durationMs: Math.round((performance.now() - startedAt) * 100) / 100,
      error: err.message,
      status: "FAIL",
      testedAt: new Date().toISOString()
    };
  }
}

export async function validateFrontendBackendConnectivity() {
  const results = [];
  for (const endpoint of ENTERPRISE_ENDPOINTS) {
    results.push(await testEndpoint(endpoint));
  }

  const passed = results.filter(r => r.ok).length;
  const failed = results.length - passed;
  const avgMs = Math.round(results.reduce((sum, r) => sum + r.durationMs, 0) / Math.max(1, results.length) * 100) / 100;

  return {
    module: "Frontend Backend Connectivity Validator",
    apiBase: API_BASE,
    status: failed === 0 ? "PASS" : "FAIL",
    endpointsTested: results.length,
    passed,
    failed,
    avgMs,
    results,
    generatedAt: new Date().toISOString()
  };
}

export { ENTERPRISE_ENDPOINTS };
'@ | Out-File -LiteralPath $ApiFile -Encoding UTF8

@'
import React from "react";

export default function BackendConnectivityPanel({ report }) {
  if (!report) {
    return <div>Connectivity report not generated yet.</div>;
  }

  return (
    <div style={{ marginTop: 24 }}>
      <h2>Backend Connectivity Report</h2>
      <div style={{
        display: "grid",
        gridTemplateColumns: "repeat(auto-fit, minmax(240px, 1fr))",
        gap: 12
      }}>
        {report.results.map((item) => (
          <div key={item.key} style={{
            border: "1px solid #ddd",
            borderRadius: 10,
            padding: 12,
            background: item.ok ? "#d1fae5" : "#fee2e2"
          }}>
            <strong>{item.label}</strong>
            <div>Status: {item.status}</div>
            <div>HTTP: {item.httpStatus}</div>
            <div>Time: {item.durationMs} ms</div>
            <div style={{ fontSize: 11, marginTop: 6 }}>{item.path}</div>
          </div>
        ))}
      </div>
    </div>
  );
}
'@ | Out-File -LiteralPath $PanelFile -Encoding UTF8

@'
import React, { useEffect, useState } from "react";
import BackendConnectivityPanel from "../components/BackendConnectivityPanel";
import { validateFrontendBackendConnectivity } from "../api/connectivityValidatorApi";

export default function FrontendBackendConnectivityValidator() {
  const [report, setReport] = useState(null);
  const [running, setRunning] = useState(false);

  async function runValidation() {
    setRunning(true);
    const result = await validateFrontendBackendConnectivity();
    setReport(result);
    setRunning(false);
  }

  useEffect(() => {
    runValidation();
    const timer = setInterval(runValidation, 30000);
    return () => clearInterval(timer);
  }, []);

  return (
    <div style={{ padding: 24, fontFamily: "Arial, sans-serif" }}>
      <h1>Frontend Backend Connectivity Validator</h1>
      <p>Validates frontend access to all major Phase 10 backend endpoints. Auto-refreshes every 30 seconds.</p>

      <button onClick={runValidation} disabled={running} style={{ padding: "8px 14px" }}>
        {running ? "Testing..." : "Run Connectivity Test"}
      </button>

      {report && (
        <div style={{ marginTop: 16 }}>
          <h2>Status: {report.status}</h2>
          <p>Passed: {report.passed} / {report.endpointsTested}</p>
          <p>Failed: {report.failed}</p>
          <p>Average Response: {report.avgMs} ms</p>
          <p>Generated: {report.generatedAt}</p>
        </div>
      )}

      <BackendConnectivityPanel report={report} />

      <h2>Special Court / Agency Coverage</h2>
      <ul>
        <li>Industrial Court Kuala Lumpur</li>
        <li>PERKESO Kuala Lumpur — Wisma PERKESO, Jalan Tun Razak</li>
        <li>PERKESO Headquarters — Menara PERKESO, Jalan Ampang</li>
      </ul>
    </div>
  );
}
'@ | Out-File -LiteralPath $PageFile -Encoding UTF8

  if(Test-Path -LiteralPath $AppFile){
    $txt=Get-Content -LiteralPath $AppFile -Raw

    if($txt -notlike "*FrontendBackendConnectivityValidator*"){
      $txt=$txt -replace 'import EnterpriseOperationsDashboard from "./enterprise/pages/EnterpriseOperationsDashboard";', 'import EnterpriseOperationsDashboard from "./enterprise/pages/EnterpriseOperationsDashboard";'+"`r`n"+'import FrontendBackendConnectivityValidator from "./enterprise/pages/FrontendBackendConnectivityValidator";'
      $txt=$txt -replace '<button onClick=\{\(\) => setView\("home"\)\}>Home</button>', '<button onClick={() => setView("connectivity")}>Connectivity Validator</button>'+"`r`n"+'        <button onClick={() => setView("home")}>Home</button>'
      $txt=$txt -replace '\{view === "enterprise" \? <EnterpriseOperationsDashboard /> : <LegacyHome />\}', '{view === "enterprise" ? <EnterpriseOperationsDashboard /> : view === "connectivity" ? <FrontendBackendConnectivityValidator /> : <LegacyHome />}'
      Set-Content -LiteralPath $AppFile -Value $txt -Encoding UTF8
    }
  }

@"
# PHASE 10U FRONTEND BACKEND CONNECTIVITY VALIDATOR

## Purpose
Prove that the React frontend can reach all major Phase 10 backend endpoints.

## Created Files
- $ApiFile
- $PanelFile
- $PageFile

## Integrated File
- $AppFile

## Runtime
Start backend and frontend, then open the frontend and click Connectivity Validator.

## Auto Refresh
- Every 30 seconds

## Endpoints Tested
- Monitoring
- Hardening
- Backup Recovery
- Performance
- Governance
- Autonomous
- Maps
- Navigation
- Predictive
- Assistant
- Command Centre
- Documents
- Court Operations
- Matter Intelligence
"@ | Out-File -LiteralPath (Join-Path $Docs "PHASE10U-CONNECTIVITY-VALIDATOR.md") -Encoding UTF8
}

$Validate=Join-Path $Validation "validate-phase10U.js"

@"
const fs = require("fs");
const path = require("path");

const api = process.env.L360_CONNECTIVITY_API;
const panel = process.env.L360_CONNECTIVITY_PANEL;
const page = process.env.L360_CONNECTIVITY_PAGE;
const app = process.env.L360_APP_FILE;
const reports = process.env.L360_REPORTS_DIR;

fs.mkdirSync(reports, { recursive: true });

function has(file, text) {
  return fs.existsSync(file) && fs.readFileSync(file, "utf8").includes(text);
}

const report = {
  phase: "10U",
  module: "Frontend Backend Connectivity Validator",
  timestamp: new Date().toISOString(),
  files: {
    apiExists: fs.existsSync(api),
    panelExists: fs.existsSync(panel),
    pageExists: fs.existsSync(page),
    appExists: fs.existsSync(app)
  },
  content: {
    apiHasMonitoring: has(api, "/api/enterprise/monitoring/health"),
    apiHasMaps: has(api, "/api/enterprise/maps/health"),
    apiHasDocuments: has(api, "/api/enterprise/documents/lifecycle/health"),
    pageHasAutoRefresh: has(page, "setInterval"),
    pageHasIndustrialCourt: has(page, "Industrial Court Kuala Lumpur"),
    appHasConnectivity: has(app, "Connectivity Validator")
  }
};

report.status = (
  report.files.apiExists &&
  report.files.panelExists &&
  report.files.pageExists &&
  report.files.appExists &&
  report.content.apiHasMonitoring &&
  report.content.apiHasMaps &&
  report.content.apiHasDocuments &&
  report.content.pageHasAutoRefresh &&
  report.content.pageHasIndustrialCourt &&
  report.content.appHasConnectivity
) ? "PASS" : "FAIL";

fs.writeFileSync(path.join(reports, "phase10U-connectivity-validator-report.json"), JSON.stringify(report, null, 2));

console.log([
  "LITIGATION 360 - PHASE 10U CONNECTIVITY VALIDATOR REPORT",
  "=======================================================",
  "",
  "Timestamp: " + report.timestamp,
  "Status: " + report.status,
  "API Exists: " + report.files.apiExists,
  "Panel Exists: " + report.files.panelExists,
  "Page Exists: " + report.files.pageExists,
  "App Exists: " + report.files.appExists,
  "Monitoring Endpoint Present: " + report.content.apiHasMonitoring,
  "Maps Endpoint Present: " + report.content.apiHasMaps,
  "Documents Endpoint Present: " + report.content.apiHasDocuments,
  "Auto Refresh Present: " + report.content.pageHasAutoRefresh,
  "Industrial Court Present: " + report.content.pageHasIndustrialCourt,
  "App Connectivity Button Present: " + report.content.appHasConnectivity
].join("\n"));

if (report.status !== "PASS") process.exit(1);
"@ | Out-File -LiteralPath $Validate -Encoding UTF8

Write-Host ""
Write-Host "Running validation..."
$env:L360_CONNECTIVITY_API=$ApiFile
$env:L360_CONNECTIVITY_PANEL=$PanelFile
$env:L360_CONNECTIVITY_PAGE=$PageFile
$env:L360_APP_FILE=$AppFile
$env:L360_REPORTS_DIR=$Reports
node $Validate
$exit=$LASTEXITCODE

Write-Host ""
Write-Host "Reports:"
Write-Host $Reports
Write-Host ""
Write-Host "Backups:"
Write-Host $Backups
Write-Host ""

if($exit -eq 0){Write-Host "PHASE 10U CONNECTIVITY VALIDATOR STATUS: PASS" -ForegroundColor Green}else{Write-Host "PHASE 10U CONNECTIVITY VALIDATOR STATUS: FAIL" -ForegroundColor Yellow}
Read-Host "Press Enter to close"
exit $exit
