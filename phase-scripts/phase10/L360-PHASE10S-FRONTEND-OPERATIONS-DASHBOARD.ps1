param([ValidateSet("DRYRUN","APPLY")][string]$Mode="DRYRUN")

$Root="C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software"
$Frontend=Join-Path $Root "frontend"
$Src=Join-Path $Frontend "src"
$OpsDir=Join-Path $Src "enterprise"
$ApiDir=Join-Path $OpsDir "api"
$PagesDir=Join-Path $OpsDir "pages"
$ComponentsDir=Join-Path $OpsDir "components"
$Phase=Join-Path $Root "_operations\phase-10S-frontend-operations-dashboard"
$Reports=Join-Path $Phase "reports"
$Backups=Join-Path $Phase "backups"
$Logs=Join-Path $Phase "logs"
$Docs=Join-Path $Phase "docs"
$Validation=Join-Path $Phase "validation"

New-Item -ItemType Directory -Force -Path $Reports,$Backups,$Logs,$Docs,$Validation,$OpsDir,$ApiDir,$PagesDir,$ComponentsDir | Out-Null
$Log=Join-Path $Logs "phase-10S-frontend-dashboard-log.txt"

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
Write-Host "L360 PHASE 10S FRONTEND OPERATIONS DASHBOARD"
Write-Host "============================================================"
Write-Host "Mode: $Mode"
Write-Host ""

if(!(Test-Path -LiteralPath $Frontend)){
  Write-Host "ERROR: frontend folder not found." -ForegroundColor Red
  Read-Host "Press Enter"
  exit 1
}

$ApiFile=Join-Path $ApiDir "enterpriseApi.js"
$DashboardFile=Join-Path $PagesDir "EnterpriseOperationsDashboard.jsx"
$CardFile=Join-Path $ComponentsDir "EnterpriseStatusCard.jsx"
$ReadmeFile=Join-Path $Docs "PHASE10S-FRONTEND-DASHBOARD-PROTOCOL.md"

if($Mode -eq "APPLY"){
  Backup $ApiFile
  Backup $DashboardFile
  Backup $CardFile

@'
const API_BASE = "http://localhost:5000";

async function getJson(path) {
  const response = await fetch(`${API_BASE}${path}`);
  if (!response.ok) {
    return {
      ok: false,
      status: response.status,
      error: `Request failed: ${response.status}`,
      path
    };
  }
  return await response.json();
}

export async function getEnterpriseHealthBundle() {
  const endpoints = {
    monitoring: "/api/enterprise/monitoring/health",
    hardening: "/api/enterprise/hardening/deployment/readiness",
    backupRecovery: "/api/enterprise/backup-recovery/health",
    performance: "/api/enterprise/performance/health",
    governance: "/api/enterprise/governance/health",
    autonomous: "/api/enterprise/autonomous/health",
    maps: "/api/enterprise/maps/health",
    navigation: "/api/enterprise/navigation/health",
    predictive: "/api/enterprise/predictive/health",
    assistant: "/api/enterprise/assistant/health",
    commandCentre: "/api/enterprise/command-centre/health"
  };

  const result = {};

  for (const [key, path] of Object.entries(endpoints)) {
    result[key] = await getJson(path);
  }

  return {
    generatedAt: new Date().toISOString(),
    result
  };
}

export async function getEnterpriseDashboard() {
  return await getJson("/api/enterprise/monitoring/dashboard");
}

export async function getPerformanceBenchmark() {
  return await getJson("/api/enterprise/performance/benchmark");
}

export async function getDeploymentReadiness() {
  return await getJson("/api/enterprise/hardening/deployment/readiness");
}
'@ | Out-File -LiteralPath $ApiFile -Encoding UTF8

@'
import React from "react";

export default function EnterpriseStatusCard({ title, status, value, details }) {
  const normalized = String(status || "UNKNOWN").toUpperCase();

  const color =
    normalized === "HEALTHY" || normalized === "READY" || normalized === "PASS"
      ? "#d1fae5"
      : normalized === "ATTENTION" || normalized === "WARNING"
      ? "#fef3c7"
      : "#fee2e2";

  return (
    <div style={{
      border: "1px solid #ddd",
      borderRadius: 12,
      padding: 16,
      background: color,
      minHeight: 110
    }}>
      <h3 style={{ margin: "0 0 8px 0" }}>{title}</h3>
      <div style={{ fontSize: 20, fontWeight: 700 }}>{status || "UNKNOWN"}</div>
      {value !== undefined && <div style={{ marginTop: 6 }}>{value}</div>}
      {details && <pre style={{ fontSize: 11, whiteSpace: "pre-wrap" }}>{details}</pre>}
    </div>
  );
}
'@ | Out-File -LiteralPath $CardFile -Encoding UTF8

@'
import React, { useEffect, useState } from "react";
import EnterpriseStatusCard from "../components/EnterpriseStatusCard";
import {
  getEnterpriseHealthBundle,
  getEnterpriseDashboard,
  getDeploymentReadiness,
  getPerformanceBenchmark
} from "../api/enterpriseApi";

export default function EnterpriseOperationsDashboard() {
  const [bundle, setBundle] = useState(null);
  const [dashboard, setDashboard] = useState(null);
  const [readiness, setReadiness] = useState(null);
  const [performance, setPerformance] = useState(null);
  const [error, setError] = useState(null);

  async function refresh() {
    try {
      setError(null);
      const [healthBundle, monitoringDashboard, deploymentReadiness, benchmark] = await Promise.all([
        getEnterpriseHealthBundle(),
        getEnterpriseDashboard(),
        getDeploymentReadiness(),
        getPerformanceBenchmark()
      ]);

      setBundle(healthBundle);
      setDashboard(monitoringDashboard);
      setReadiness(deploymentReadiness);
      setPerformance(benchmark);
    } catch (err) {
      setError(err.message);
    }
  }

  useEffect(() => {
    refresh();
    const timer = setInterval(refresh, 15000);
    return () => clearInterval(timer);
  }, []);

  const result = bundle?.result || {};

  return (
    <div style={{ padding: 24, fontFamily: "Arial, sans-serif" }}>
      <h1>Litigation 360 Enterprise Operations Dashboard</h1>
      <p>Live monitoring view for Phase 10A–10S modules. Auto-refreshes every 15 seconds.</p>

      <button onClick={refresh} style={{ padding: "8px 14px", marginBottom: 16 }}>
        Refresh Now
      </button>

      {error && <div style={{ color: "red" }}>Error: {error}</div>}

      <div style={{
        display: "grid",
        gridTemplateColumns: "repeat(auto-fit, minmax(240px, 1fr))",
        gap: 16
      }}>
        <EnterpriseStatusCard
          title="Monitoring"
          status={result.monitoring?.status}
          value={`Score: ${result.monitoring?.healthScore ?? "N/A"}`}
        />
        <EnterpriseStatusCard
          title="Deployment Readiness"
          status={readiness?.status}
          value={`Ready: ${String(readiness?.deploymentReady ?? false)}`}
        />
        <EnterpriseStatusCard
          title="Performance"
          status={result.performance?.status}
          value={`Avg: ${result.performance?.avgMs ?? "N/A"} ms`}
        />
        <EnterpriseStatusCard
          title="Backup Recovery"
          status={result.backupRecovery?.status}
          value={`Snapshots: ${result.backupRecovery?.snapshotsCreated ?? "N/A"}`}
        />
        <EnterpriseStatusCard
          title="Governance"
          status={result.governance?.status}
          value={`Score: ${result.governance?.governanceScore ?? "N/A"}`}
        />
        <EnterpriseStatusCard
          title="Autonomous Ops"
          status={result.autonomous?.status}
          value={`Escalations: ${result.autonomous?.openEscalations ?? "N/A"}`}
        />
        <EnterpriseStatusCard
          title="Maps"
          status={result.maps?.status}
          value={`Courts: ${result.maps?.registeredCourts ?? "N/A"}`}
        />
        <EnterpriseStatusCard
          title="Navigation"
          status={result.navigation?.status}
          value={`Courts: ${result.navigation?.courtsRegistered ?? "N/A"}`}
        />
      </div>

      <h2 style={{ marginTop: 32 }}>Special Court / Agency Monitoring</h2>
      <ul>
        <li>Industrial Court Kuala Lumpur</li>
        <li>PERKESO Kuala Lumpur — Wisma PERKESO, Jalan Tun Razak</li>
        <li>PERKESO Headquarters — Menara PERKESO, Jalan Ampang</li>
      </ul>

      <h2>Operational Details</h2>
      <pre style={{ background: "#f5f5f5", padding: 16, borderRadius: 8, overflow: "auto" }}>
        {JSON.stringify({ bundle, dashboard, readiness, performance }, null, 2)}
      </pre>
    </div>
  );
}
'@ | Out-File -LiteralPath $DashboardFile -Encoding UTF8

@"
# LITIGATION 360 - PHASE 10S FRONTEND OPERATIONS DASHBOARD

## Purpose
Create reusable frontend files for an enterprise operations dashboard.

## Created Paths
- frontend\src\enterprise\api\enterpriseApi.js
- frontend\src\enterprise\components\EnterpriseStatusCard.jsx
- frontend\src\enterprise\pages\EnterpriseOperationsDashboard.jsx

## How To Use
Import the page into your existing React router or App.jsx:

import EnterpriseOperationsDashboard from "./enterprise/pages/EnterpriseOperationsDashboard";

Then render:

<EnterpriseOperationsDashboard />

## Dashboard Refresh
- Auto-refresh every 15 seconds
- Manual refresh button included

## Backend Endpoints Used
- /api/enterprise/monitoring/health
- /api/enterprise/monitoring/dashboard
- /api/enterprise/hardening/deployment/readiness
- /api/enterprise/performance/benchmark
- /api/enterprise/backup-recovery/health
- /api/enterprise/governance/health
- /api/enterprise/autonomous/health
- /api/enterprise/maps/health
- /api/enterprise/navigation/health
- /api/enterprise/predictive/health
- /api/enterprise/assistant/health
- /api/enterprise/command-centre/health

## Special Monitoring
- Industrial Court Kuala Lumpur
- PERKESO Kuala Lumpur
- PERKESO Headquarters Jalan Ampang
"@ | Out-File -LiteralPath $ReadmeFile -Encoding UTF8
}

$Validate=Join-Path $Validation "validate-phase10S-frontend-dashboard.js"

@"
const fs = require("fs");
const path = require("path");

const root = "$Root".replace(/\\\\/g, "\\\\");
const frontend = path.join(root, "frontend");
const reports = path.join(root, "_operations", "phase-10S-frontend-operations-dashboard", "reports");

fs.mkdirSync(reports, { recursive: true });

const files = {
  api: path.join(frontend, "src", "enterprise", "api", "enterpriseApi.js"),
  card: path.join(frontend, "src", "enterprise", "components", "EnterpriseStatusCard.jsx"),
  page: path.join(frontend, "src", "enterprise", "pages", "EnterpriseOperationsDashboard.jsx")
};

const report = {
  phase: "10S",
  module: "Frontend Operations Dashboard",
  timestamp: new Date().toISOString(),
  files: {
    apiExists: fs.existsSync(files.api),
    cardExists: fs.existsSync(files.card),
    pageExists: fs.existsSync(files.page)
  },
  content: {
    apiHasMonitoringEndpoint: fs.existsSync(files.api) && fs.readFileSync(files.api, "utf8").includes("/api/enterprise/monitoring/health"),
    pageHasAutoRefresh: fs.existsSync(files.page) && fs.readFileSync(files.page, "utf8").includes("setInterval"),
    pageHasIndustrialCourt: fs.existsSync(files.page) && fs.readFileSync(files.page, "utf8").includes("Industrial Court Kuala Lumpur"),
    pageHasPERKESO: fs.existsSync(files.page) && fs.readFileSync(files.page, "utf8").includes("PERKESO")
  }
};

report.status = (
  report.files.apiExists &&
  report.files.cardExists &&
  report.files.pageExists &&
  report.content.apiHasMonitoringEndpoint &&
  report.content.pageHasAutoRefresh &&
  report.content.pageHasIndustrialCourt &&
  report.content.pageHasPERKESO
) ? "PASS" : "FAIL";

fs.writeFileSync(path.join(reports, "phase10S-frontend-dashboard-report.json"), JSON.stringify(report, null, 2));

console.log([
  "LITIGATION 360 - PHASE 10S FRONTEND DASHBOARD REPORT",
  "===================================================",
  "",
  "Timestamp: " + report.timestamp,
  "Status: " + report.status,
  "API File Exists: " + report.files.apiExists,
  "Card Component Exists: " + report.files.cardExists,
  "Dashboard Page Exists: " + report.files.pageExists,
  "Monitoring Endpoint Present: " + report.content.apiHasMonitoringEndpoint,
  "Auto Refresh Present: " + report.content.pageHasAutoRefresh,
  "Industrial Court Present: " + report.content.pageHasIndustrialCourt,
  "PERKESO Present: " + report.content.pageHasPERKESO
].join("\\n"));

if (report.status !== "PASS") process.exit(1);
"@ | Out-File -LiteralPath $Validate -Encoding UTF8

Write-Host ""
Write-Host "Running validation..."
node $Validate
$exit=$LASTEXITCODE

Write-Host ""
Write-Host "Reports:"
Write-Host $Reports
Write-Host ""
Write-Host "Backups:"
Write-Host $Backups
Write-Host ""

if($exit -eq 0){Write-Host "PHASE 10S FRONTEND DASHBOARD STATUS: PASS" -ForegroundColor Green}else{Write-Host "PHASE 10S FRONTEND DASHBOARD STATUS: FAIL" -ForegroundColor Yellow}
Read-Host "Press Enter to close"
exit $exit
