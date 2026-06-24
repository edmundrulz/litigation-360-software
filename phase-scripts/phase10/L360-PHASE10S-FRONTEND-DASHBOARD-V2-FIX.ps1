param([ValidateSet("DRYRUN","APPLY")][string]$Mode="DRYRUN")

$Root="C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software"
$Frontend=Join-Path $Root "frontend"
$Src=Join-Path $Frontend "src"
$ApiDir=Join-Path $Src "enterprise\api"
$CompDir=Join-Path $Src "enterprise\components"
$PageDir=Join-Path $Src "enterprise\pages"
$Phase=Join-Path $Root "_operations\phase-10S-frontend-dashboard-v2-fix"
$Reports=Join-Path $Phase "reports"
$Backups=Join-Path $Phase "backups"
$Logs=Join-Path $Phase "logs"
$Docs=Join-Path $Phase "docs"
$Validation=Join-Path $Phase "validation"

New-Item -ItemType Directory -Force -Path $ApiDir,$CompDir,$PageDir,$Reports,$Backups,$Logs,$Docs,$Validation | Out-Null

$Api=Join-Path $ApiDir "enterpriseApi.js"
$Card=Join-Path $CompDir "EnterpriseStatusCard.jsx"
$Page=Join-Path $PageDir "EnterpriseOperationsDashboard.jsx"

function Backup($Path){
  if(Test-Path -LiteralPath $Path){
    Copy-Item -LiteralPath $Path -Destination (Join-Path $Backups ((Split-Path $Path -Leaf)+"."+(Get-Date -Format "yyyyMMdd_HHmmss")+".bak")) -Force
  }
}

Clear-Host
Write-Host "============================================================"
Write-Host "L360 PHASE 10S FRONTEND DASHBOARD V2 FIX"
Write-Host "============================================================"
Write-Host "Mode: $Mode"
Write-Host ""

if(!(Test-Path -LiteralPath $Frontend)){
  Write-Host "ERROR: frontend folder not found." -ForegroundColor Red
  Read-Host "Press Enter"
  exit 1
}

if($Mode -eq "APPLY"){
  Backup $Api
  Backup $Card
  Backup $Page

@'
const API_BASE = "http://localhost:5000";

async function getJson(path) {
  try {
    const response = await fetch(`${API_BASE}${path}`);
    if (!response.ok) return { ok: false, status: response.status, error: `Request failed: ${response.status}`, path };
    return await response.json();
  } catch (err) {
    return { ok: false, status: "NETWORK_ERROR", error: err.message, path };
  }
}

export async function getEnterpriseHealthBundle() {
  const endpoints = {
    monitoring: "/api/enterprise/monitoring/health",
    monitoringDashboard: "/api/enterprise/monitoring/dashboard",
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
  for (const [key, path] of Object.entries(endpoints)) result[key] = await getJson(path);
  return { generatedAt: new Date().toISOString(), result };
}

export async function getEnterpriseDashboard() { return await getJson("/api/enterprise/monitoring/dashboard"); }
export async function getPerformanceBenchmark() { return await getJson("/api/enterprise/performance/benchmark"); }
export async function getDeploymentReadiness() { return await getJson("/api/enterprise/hardening/deployment/readiness"); }
'@ | Out-File -LiteralPath $Api -Encoding UTF8

@'
import React from "react";

export default function EnterpriseStatusCard({ title, status, value }) {
  const normalized = String(status || "UNKNOWN").toUpperCase();
  const background =
    normalized === "HEALTHY" || normalized === "READY" || normalized === "PASS"
      ? "#d1fae5"
      : normalized === "ATTENTION" || normalized === "WARNING"
      ? "#fef3c7"
      : "#fee2e2";

  return (
    <div style={{ border: "1px solid #ddd", borderRadius: 12, padding: 16, background, minHeight: 110 }}>
      <h3 style={{ margin: "0 0 8px 0" }}>{title}</h3>
      <div style={{ fontSize: 20, fontWeight: 700 }}>{status || "UNKNOWN"}</div>
      {value !== undefined && <div style={{ marginTop: 6 }}>{value}</div>}
    </div>
  );
}
'@ | Out-File -LiteralPath $Card -Encoding UTF8

@'
import React, { useEffect, useState } from "react";
import EnterpriseStatusCard from "../components/EnterpriseStatusCard";
import { getEnterpriseHealthBundle, getEnterpriseDashboard, getDeploymentReadiness, getPerformanceBenchmark } from "../api/enterpriseApi";

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
      <p>Live monitoring dashboard. Auto-refreshes every 15 seconds.</p>
      <button onClick={refresh} style={{ padding: "8px 14px", marginBottom: 16 }}>Refresh Now</button>
      {error && <div style={{ color: "red" }}>Error: {error}</div>}

      <div style={{ display: "grid", gridTemplateColumns: "repeat(auto-fit, minmax(240px, 1fr))", gap: 16 }}>
        <EnterpriseStatusCard title="Monitoring" status={result.monitoring?.status} value={`Score: ${result.monitoring?.healthScore ?? "N/A"}`} />
        <EnterpriseStatusCard title="Deployment Readiness" status={readiness?.status} value={`Ready: ${String(readiness?.deploymentReady ?? false)}`} />
        <EnterpriseStatusCard title="Performance" status={result.performance?.status} value={`Avg: ${result.performance?.avgMs ?? "N/A"} ms`} />
        <EnterpriseStatusCard title="Backup Recovery" status={result.backupRecovery?.status} value={`Snapshots: ${result.backupRecovery?.snapshotsCreated ?? "N/A"}`} />
        <EnterpriseStatusCard title="Governance" status={result.governance?.status} value={`Score: ${result.governance?.governanceScore ?? "N/A"}`} />
        <EnterpriseStatusCard title="Autonomous Ops" status={result.autonomous?.status} value={`Escalations: ${result.autonomous?.openEscalations ?? "N/A"}`} />
        <EnterpriseStatusCard title="Maps" status={result.maps?.status} value={`Courts: ${result.maps?.registeredCourts ?? "N/A"}`} />
        <EnterpriseStatusCard title="Navigation" status={result.navigation?.status} value={`Courts: ${result.navigation?.courtsRegistered ?? "N/A"}`} />
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
'@ | Out-File -LiteralPath $Page -Encoding UTF8

@"
# Phase 10S Frontend Dashboard V2 Fix

Files:
- $Api
- $Card
- $Page

Usage:
Import EnterpriseOperationsDashboard into frontend\src\App.jsx or your router.

import EnterpriseOperationsDashboard from "./enterprise/pages/EnterpriseOperationsDashboard";

Render:
<EnterpriseOperationsDashboard />
"@ | Out-File -LiteralPath (Join-Path $Docs "PHASE10S-FRONTEND-DASHBOARD-V2-FIX.md") -Encoding UTF8
}

$Validate=Join-Path $Validation "validate-phase10S-v2-fix.js"

@'
const fs = require("fs");
const path = require("path");

const api = process.env.L360_API_FILE;
const card = process.env.L360_CARD_FILE;
const page = process.env.L360_PAGE_FILE;
const reports = process.env.L360_REPORTS_DIR;

fs.mkdirSync(reports, { recursive: true });

function has(file, text) {
  return fs.existsSync(file) && fs.readFileSync(file, "utf8").includes(text);
}

const report = {
  phase: "10S-V2-FIX",
  timestamp: new Date().toISOString(),
  files: {
    apiExists: fs.existsSync(api),
    cardExists: fs.existsSync(card),
    pageExists: fs.existsSync(page)
  },
  content: {
    monitoringEndpoint: has(api, "/api/enterprise/monitoring/health"),
    performanceEndpoint: has(api, "/api/enterprise/performance/benchmark"),
    autoRefresh: has(page, "setInterval"),
    industrialCourt: has(page, "Industrial Court Kuala Lumpur"),
    perkeso: has(page, "PERKESO"),
    cardLogic: has(card, "normalized")
  }
};

report.status =
  report.files.apiExists &&
  report.files.cardExists &&
  report.files.pageExists &&
  report.content.monitoringEndpoint &&
  report.content.performanceEndpoint &&
  report.content.autoRefresh &&
  report.content.industrialCourt &&
  report.content.perkeso &&
  report.content.cardLogic
    ? "PASS"
    : "FAIL";

fs.writeFileSync(path.join(reports, "phase10S-v2-fix-report.json"), JSON.stringify(report, null, 2));

console.log([
  "LITIGATION 360 - PHASE 10S FRONTEND DASHBOARD V2 FIX REPORT",
  "==========================================================",
  "",
  "Timestamp: " + report.timestamp,
  "Status: " + report.status,
  "API File Exists: " + report.files.apiExists,
  "Card Component Exists: " + report.files.cardExists,
  "Dashboard Page Exists: " + report.files.pageExists,
  "Monitoring Endpoint Present: " + report.content.monitoringEndpoint,
  "Performance Endpoint Present: " + report.content.performanceEndpoint,
  "Auto Refresh Present: " + report.content.autoRefresh,
  "Industrial Court Present: " + report.content.industrialCourt,
  "PERKESO Present: " + report.content.perkeso,
  "Card Logic Present: " + report.content.cardLogic
].join("\n"));

if (report.status !== "PASS") process.exit(1);
'@ | Out-File -LiteralPath $Validate -Encoding UTF8

Write-Host ""
Write-Host "Running validation..."
$env:L360_API_FILE=$Api
$env:L360_CARD_FILE=$Card
$env:L360_PAGE_FILE=$Page
$env:L360_REPORTS_DIR=$Reports
node $Validate
$exit=$LASTEXITCODE

Write-Host ""
Write-Host "Created/Checked:"
Write-Host $Api
Write-Host $Card
Write-Host $Page
Write-Host ""
Write-Host "Reports:"
Write-Host $Reports
Write-Host ""

if($exit -eq 0){Write-Host "PHASE 10S FRONTEND DASHBOARD V2 FIX STATUS: PASS" -ForegroundColor Green}else{Write-Host "PHASE 10S FRONTEND DASHBOARD V2 FIX STATUS: FAIL" -ForegroundColor Yellow}
Read-Host "Press Enter to close"
exit $exit
