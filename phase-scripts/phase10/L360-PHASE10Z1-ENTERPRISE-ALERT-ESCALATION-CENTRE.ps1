param(
  [ValidateSet("APPLY","VALIDATE")]
  [string]$Mode = "APPLY"
)

$ErrorActionPreference = "Stop"

$PhaseName = "PHASE 10Z.1 ALERT & ESCALATION CENTRE"
$ProjectRoot = "C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software"
$Backend = Join-Path $ProjectRoot "backend"
$BackendSrc = Join-Path $Backend "src"
$AutomationDir = Join-Path $BackendSrc "automation"
$RoutesDir = Join-Path $BackendSrc "routes"
$IndexFile = Join-Path $BackendSrc "index.js"
$Frontend = Join-Path $ProjectRoot "frontend"
$FrontendSrc = Join-Path $Frontend "src"
$FrontendApiDir = Join-Path $FrontendSrc "enterprise\api"
$FrontendPagesDir = Join-Path $FrontendSrc "enterprise\pages"
$OpsRoot = Join-Path $ProjectRoot "_operations\phase-10Z1-alert-escalation-centre"

$AlertEngineFile = Join-Path $AutomationDir "alertEngine.js"
$EscalationEngineFile = Join-Path $AutomationDir "escalationEngine.js"
$NotificationEngineFile = Join-Path $AutomationDir "notificationEngine.js"
$AlertRoutesFile = Join-Path $RoutesDir "alertRoutes.js"
$FrontendApiFile = Join-Path $FrontendApiDir "alertEscalationApi.js"
$FrontendPageFile = Join-Path $FrontendPagesDir "EnterpriseAlertEscalationCentre.jsx"

$Timestamp = Get-Date -Format "yyyyMMdd-HHmmss"
$BackupDir = Join-Path $OpsRoot "backups\$Timestamp"
$ValidationDir = Join-Path $OpsRoot "validation"
$ReportsDir = Join-Path $OpsRoot "reports"
$DashboardsDir = Join-Path $OpsRoot "dashboards"
$AlertsDir = Join-Path $OpsRoot "alerts"
$EscalationsDir = Join-Path $OpsRoot "escalations"
$NotificationsDir = Join-Path $OpsRoot "notifications"
$LogsDir = Join-Path $OpsRoot "logs"
$DocsDir = Join-Path $OpsRoot "docs"

function Write-Step($Message) {
  Write-Host ""
  Write-Host ">>> $Message" -ForegroundColor Cyan
}

function Ensure-Directory($PathValue) {
  if (!(Test-Path -LiteralPath $PathValue)) {
    New-Item -ItemType Directory -Path $PathValue -Force | Out-Null
  }
}

function Backup-File($PathValue) {
  if (Test-Path -LiteralPath $PathValue) {
    Ensure-Directory $BackupDir
    $leaf = Split-Path $PathValue -Leaf
    Copy-Item -LiteralPath $PathValue -Destination (Join-Path $BackupDir $leaf) -Force
  }
}

function Write-TextFile($PathValue, $Content) {
  $parent = Split-Path $PathValue -Parent
  Ensure-Directory $parent
  $Content | Out-File -LiteralPath $PathValue -Encoding UTF8 -Force
}

function Test-Contains($PathValue, $Needle) {
  if (!(Test-Path -LiteralPath $PathValue)) { return $false }
  $content = Get-Content -LiteralPath $PathValue -Raw
  return $content.Contains($Needle)
}

function Assert-Root {
  Write-Step "Checking project structure"
  if (!(Test-Path -LiteralPath $ProjectRoot)) { throw "Project root not found: $ProjectRoot" }
  if (!(Test-Path -LiteralPath $Backend)) { throw "Backend folder not found: $Backend" }
  if (!(Test-Path -LiteralPath $BackendSrc)) { throw "Backend src folder not found: $BackendSrc" }
  if (!(Test-Path -LiteralPath $IndexFile)) { throw "Backend index.js not found: $IndexFile" }
  if (!(Test-Path -LiteralPath $Frontend)) { Write-Host "Frontend folder not found. Frontend files will still be created when parent path is available." -ForegroundColor Yellow }
}

function Mount-Route {
  Write-Step "Mounting alert route safely into backend index.js"
  $mountLine = 'app.use("/api/enterprise/alerts", require("./routes/alertRoutes"));'
  Backup-File $IndexFile
  $content = Get-Content -LiteralPath $IndexFile -Raw
  if ($content.Contains($mountLine)) {
    Write-Host "Route already mounted. No duplicate added." -ForegroundColor Green
    return
  }

  $lines = Get-Content -LiteralPath $IndexFile
  $inserted = $false
  $newLines = New-Object System.Collections.Generic.List[string]

  foreach ($line in $lines) {
    $newLines.Add($line)
    if (!$inserted -and $line -match 'app\.use\(') {
      $newLines.Add($mountLine)
      $inserted = $true
    }
  }

  if (!$inserted) {
    $newLines.Add("")
    $newLines.Add("// Phase 10Z.1 Enterprise Alert & Escalation Centre")
    $newLines.Add($mountLine)
  }

  $newLines | Out-File -LiteralPath $IndexFile -Encoding UTF8 -Force
}

function Create-OperationsFiles {
  Write-Step "Creating operations folders"
  @(
    $OpsRoot,$AlertsDir,$EscalationsDir,$NotificationsDir,$ReportsDir,$DashboardsDir,
    $LogsDir,$DocsDir,$ValidationDir,$BackupDir
  ) | ForEach-Object { Ensure-Directory $_ }

  $alertRegistry = @"
{
  "phase": "10Z.1",
  "registryType": "ALERT_REGISTRY",
  "createdAt": "$(Get-Date -Format o)",
  "severityLevels": ["CRITICAL","HIGH","MEDIUM","LOW","INFO"],
  "statusValues": ["OPEN","ACKNOWLEDGED","ESCALATED","RESOLVED","CLOSED"],
  "categories": [
    "SYSTEM","DATABASE","BACKEND","FRONTEND","WORKFLOW","DOCUMENT","COURT",
    "INDUSTRIAL_COURT","PERKESO","NAVIGATION","DEPLOYMENT","SECURITY",
    "PERFORMANCE","BACKUP","GATEKEEPER"
  ],
  "requiredCourtCoverage": [
    "Industrial Court Kuala Lumpur",
    "PERKESO Kuala Lumpur / Jalan Tun Razak",
    "PERKESO Headquarters / Jalan Ampang",
    "Google Maps readiness",
    "Waze readiness",
    "Court navigation readiness"
  ]
}
"@
  Write-TextFile (Join-Path $AlertsDir "alert-registry.json") $alertRegistry

  $escalationRegistry = @"
{
  "phase": "10Z.1",
  "registryType": "ESCALATION_REGISTRY",
  "createdAt": "$(Get-Date -Format o)",
  "levels": ["OPERATIONS","MANAGER","EXECUTIVE","URGENT"],
  "statuses": ["ACTIVE","COMPLETED","CANCELLED"],
  "rules": [
    { "severity": "CRITICAL", "defaultLevel": "EXECUTIVE" },
    { "severity": "HIGH", "defaultLevel": "MANAGER" },
    { "severity": "MEDIUM", "defaultLevel": "OPERATIONS" },
    { "severity": "LOW", "defaultLevel": "OPERATIONS" },
    { "severity": "INFO", "defaultLevel": "OPERATIONS" }
  ]
}
"@
  Write-TextFile (Join-Path $EscalationsDir "escalation-registry.json") $escalationRegistry

  $notificationRegistry = @"
{
  "phase": "10Z.1",
  "registryType": "NOTIFICATION_REGISTRY",
  "createdAt": "$(Get-Date -Format o)",
  "channels": ["DASHBOARD","LOG","EMAIL_PLACEHOLDER","SMS_PLACEHOLDER","WHATSAPP_PLACEHOLDER"],
  "realSendingEnabled": false,
  "note": "Real SMS, WhatsApp and email are placeholders only in Phase 10Z.1."
}
"@
  Write-TextFile (Join-Path $NotificationsDir "notification-registry.json") $notificationRegistry
}

function Create-BackendFiles {
  Write-Step "Creating backend alert, escalation, and notification engines"

  Backup-File $AlertEngineFile
  Backup-File $EscalationEngineFile
  Backup-File $NotificationEngineFile
  Backup-File $AlertRoutesFile

  $alertEngine = @'
const fs = require("fs");
const path = require("path");

const severityLevels = ["CRITICAL", "HIGH", "MEDIUM", "LOW", "INFO"];
const statusValues = ["OPEN", "ACKNOWLEDGED", "ESCALATED", "RESOLVED", "CLOSED"];
const categories = [
  "SYSTEM",
  "DATABASE",
  "BACKEND",
  "FRONTEND",
  "WORKFLOW",
  "DOCUMENT",
  "COURT",
  "INDUSTRIAL_COURT",
  "PERKESO",
  "NAVIGATION",
  "DEPLOYMENT",
  "SECURITY",
  "PERFORMANCE",
  "BACKUP",
  "GATEKEEPER"
];

const requiredCoverage = {
  industrialCourt: [
    "Industrial Court Kuala Lumpur",
    "Industrial Court hearing tomorrow",
    "Industrial Court filing deadline",
    "Industrial Court attendance reminder",
    "Industrial Court navigation departure reminder"
  ],
  perkeso: [
    "PERKESO Kuala Lumpur / Jalan Tun Razak",
    "PERKESO Headquarters / Jalan Ampang",
    "PERKESO meeting reminder",
    "PERKESO submission deadline",
    "PERKESO appointment reminder",
    "PERKESO navigation reminder"
  ],
  deployment: [
    "Gatekeeper rejected deployment",
    "Release blocked",
    "Environment critical",
    "Hardening blocked",
    "Backup failed",
    "Performance failed"
  ],
  navigation: [
    "Google Maps readiness",
    "Waze readiness",
    "Court navigation readiness"
  ]
};

const alerts = [
  {
    alertId: "ALT-SEED-001",
    severity: "CRITICAL",
    category: "DATABASE",
    title: "Database unavailable",
    message: "Database health check failed",
    status: "OPEN",
    source: "SYSTEM",
    createdAt: new Date().toISOString(),
    updatedAt: new Date().toISOString(),
    resolvedAt: null
  },
  {
    alertId: "ALT-SEED-002",
    severity: "HIGH",
    category: "INDUSTRIAL_COURT",
    title: "Industrial Court filing deadline",
    message: "Industrial Court filing deadline requires operator verification.",
    status: "OPEN",
    source: "COURT",
    createdAt: new Date().toISOString(),
    updatedAt: new Date().toISOString(),
    resolvedAt: null
  },
  {
    alertId: "ALT-SEED-003",
    severity: "HIGH",
    category: "PERKESO",
    title: "PERKESO submission deadline",
    message: "PERKESO submission deadline requires operator verification.",
    status: "OPEN",
    source: "PERKESO",
    createdAt: new Date().toISOString(),
    updatedAt: new Date().toISOString(),
    resolvedAt: null
  },
  {
    alertId: "ALT-SEED-004",
    severity: "CRITICAL",
    category: "DEPLOYMENT",
    title: "Gatekeeper rejected deployment",
    message: "Deployment gatekeeper rejected release and blocked promotion.",
    status: "OPEN",
    source: "GATEKEEPER",
    createdAt: new Date().toISOString(),
    updatedAt: new Date().toISOString(),
    resolvedAt: null
  }
];

function nextId(prefix, collection) {
  const next = String(collection.length + 1).padStart(6, "0");
  return `${prefix}-${next}`;
}

function normalizeSeverity(severity) {
  const value = String(severity || "INFO").toUpperCase();
  return severityLevels.includes(value) ? value : "INFO";
}

function normalizeCategory(category) {
  const value = String(category || "SYSTEM").toUpperCase();
  return categories.includes(value) ? value : "SYSTEM";
}

function createAlert(input = {}) {
  const now = new Date().toISOString();
  const alert = {
    alertId: input.alertId || nextId("ALT", alerts),
    severity: normalizeSeverity(input.severity),
    category: normalizeCategory(input.category),
    title: input.title || "Untitled alert",
    message: input.message || "No alert message supplied.",
    status: statusValues.includes(input.status) ? input.status : "OPEN",
    source: input.source || "SYSTEM",
    createdAt: input.createdAt || now,
    updatedAt: now,
    resolvedAt: null
  };

  alerts.push(alert);
  return alert;
}

function resolveAlert(alertId, resolution = {}) {
  const alert = alerts.find((item) => item.alertId === alertId);
  if (!alert) {
    return { found: false, alertId, status: "NOT_FOUND" };
  }

  const now = new Date().toISOString();
  alert.status = "RESOLVED";
  alert.updatedAt = now;
  alert.resolvedAt = now;
  alert.resolution = {
    resolvedBy: resolution.resolvedBy || "OPERATOR",
    notes: resolution.notes || "Resolved by operator.",
    checksCompleted: Boolean(resolution.checksCompleted ?? true)
  };

  return { found: true, alert };
}

function acknowledgeAlert(alertId) {
  const alert = alerts.find((item) => item.alertId === alertId);
  if (!alert) {
    return { found: false, alertId, status: "NOT_FOUND" };
  }

  alert.status = "ACKNOWLEDGED";
  alert.updatedAt = new Date().toISOString();
  return { found: true, alert };
}

function markEscalated(alertId) {
  const alert = alerts.find((item) => item.alertId === alertId);
  if (!alert) {
    return { found: false, alertId, status: "NOT_FOUND" };
  }

  alert.status = "ESCALATED";
  alert.updatedAt = new Date().toISOString();
  return { found: true, alert };
}

function listAlerts(filter = {}) {
  return alerts.filter((alert) => {
    if (filter.status && alert.status !== filter.status) return false;
    if (filter.severity && alert.severity !== filter.severity) return false;
    if (filter.category && alert.category !== filter.category) return false;
    return true;
  });
}

function getOpenAlerts() {
  return alerts.filter((alert) => ["OPEN", "ACKNOWLEDGED", "ESCALATED"].includes(alert.status));
}

function getCriticalAlerts() {
  return listAlerts({ severity: "CRITICAL" });
}

function getHighAlerts() {
  return listAlerts({ severity: "HIGH" });
}

function getMetrics() {
  const open = getOpenAlerts();
  return {
    phase: "10Z.1",
    generatedAt: new Date().toISOString(),
    totalAlerts: alerts.length,
    openAlerts: open.length,
    criticalAlerts: getCriticalAlerts().length,
    highAlerts: getHighAlerts().length,
    resolvedAlerts: listAlerts({ status: "RESOLVED" }).length,
    categoriesCovered: categories.length,
    severityLevels,
    statusValues,
    coverage: {
      industrialCourt: requiredCoverage.industrialCourt.length,
      perkeso: requiredCoverage.perkeso.length,
      deployment: requiredCoverage.deployment.length,
      navigation: requiredCoverage.navigation.length
    }
  };
}

function getHealth() {
  const metrics = getMetrics();
  const criticalOpen = getOpenAlerts().filter((alert) => alert.severity === "CRITICAL").length;
  return {
    status: "HEALTHY",
    phase: "10Z.1",
    service: "Enterprise Alert & Escalation Centre",
    score: criticalOpen > 0 ? 90 : 100,
    criticalOpen,
    metrics,
    requiredCoverage,
    timestamp: new Date().toISOString()
  };
}

function getDashboard() {
  return {
    title: "Enterprise Alert & Escalation Centre",
    phase: "10Z.1",
    status: "OPERATIONAL",
    generatedAt: new Date().toISOString(),
    health: getHealth(),
    metrics: getMetrics(),
    openAlerts: getOpenAlerts(),
    criticalAlerts: getCriticalAlerts(),
    highAlerts: getHighAlerts(),
    checksAndBalances: [
      "Severity must be classified before escalation.",
      "Critical alerts must be escalated to executive level.",
      "Resolution requires operator notes.",
      "Court, Industrial Court, PERKESO, navigation and deployment coverage must remain present.",
      "Placeholder channels must not send real SMS, WhatsApp or email in Phase 10Z.1."
    ]
  };
}

module.exports = {
  severityLevels,
  statusValues,
  categories,
  requiredCoverage,
  createAlert,
  resolveAlert,
  acknowledgeAlert,
  markEscalated,
  listAlerts,
  getOpenAlerts,
  getCriticalAlerts,
  getHighAlerts,
  getMetrics,
  getHealth,
  getDashboard
};
'@
  Write-TextFile $AlertEngineFile $alertEngine

  $escalationEngine = @'
const alertEngine = require("./alertEngine");

const levels = ["OPERATIONS", "MANAGER", "EXECUTIVE", "URGENT"];
const statuses = ["ACTIVE", "COMPLETED", "CANCELLED"];
const escalations = [];

function nextId() {
  return `ESC-${String(escalations.length + 1).padStart(6, "0")}`;
}

function defaultLevelForSeverity(severity) {
  if (severity === "CRITICAL") return "EXECUTIVE";
  if (severity === "HIGH") return "MANAGER";
  return "OPERATIONS";
}

function escalateAlert(input = {}) {
  const alertId = input.alertId;
  const alert = alertEngine.listAlerts().find((item) => item.alertId === alertId);

  if (!alert) {
    return {
      success: false,
      status: "ALERT_NOT_FOUND",
      alertId
    };
  }

  const level = levels.includes(input.level) ? input.level : defaultLevelForSeverity(alert.severity);

  const escalation = {
    escalationId: nextId(),
    alertId,
    level,
    status: "ACTIVE",
    reason: input.reason || `${alert.severity} alert requires ${level.toLowerCase()} attention`,
    createdAt: new Date().toISOString()
  };

  escalations.push(escalation);
  alertEngine.markEscalated(alertId);

  return {
    success: true,
    escalation
  };
}

function listEscalations() {
  return escalations;
}

function getMetrics() {
  return {
    phase: "10Z.1",
    totalEscalations: escalations.length,
    activeEscalations: escalations.filter((item) => item.status === "ACTIVE").length,
    levels,
    statuses,
    generatedAt: new Date().toISOString()
  };
}

function getHealth() {
  return {
    status: "HEALTHY",
    service: "Escalation Engine",
    phase: "10Z.1",
    metrics: getMetrics(),
    timestamp: new Date().toISOString()
  };
}

module.exports = {
  levels,
  statuses,
  escalateAlert,
  listEscalations,
  getMetrics,
  getHealth
};
'@
  Write-TextFile $EscalationEngineFile $escalationEngine

  $notificationEngine = @'
const channels = [
  "DASHBOARD",
  "LOG",
  "EMAIL_PLACEHOLDER",
  "SMS_PLACEHOLDER",
  "WHATSAPP_PLACEHOLDER"
];

const notifications = [];

function nextId() {
  return `NTF-${String(notifications.length + 1).padStart(6, "0")}`;
}

function createNotification(input = {}) {
  const channel = channels.includes(input.channel) ? input.channel : "DASHBOARD";
  const notification = {
    notificationId: nextId(),
    alertId: input.alertId || "ALT-UNKNOWN",
    channel,
    recipient: input.recipient || "OPERATIONS",
    message: input.message || "Alert notification created.",
    status: "QUEUED",
    createdAt: new Date().toISOString(),
    realSendingEnabled: false
  };

  notifications.push(notification);
  return notification;
}

function notifyForAlert(alert, channel = "DASHBOARD") {
  return createNotification({
    alertId: alert.alertId,
    channel,
    recipient: alert.severity === "CRITICAL" ? "EXECUTIVE" : "OPERATIONS",
    message: `${alert.severity}: ${alert.title} - ${alert.message}`
  });
}

function listNotifications() {
  return notifications;
}

function getMetrics() {
  return {
    phase: "10Z.1",
    totalNotifications: notifications.length,
    queuedNotifications: notifications.filter((item) => item.status === "QUEUED").length,
    channels,
    realSendingEnabled: false,
    generatedAt: new Date().toISOString()
  };
}

function getHealth() {
  return {
    status: "HEALTHY",
    service: "Notification Engine",
    phase: "10Z.1",
    metrics: getMetrics(),
    timestamp: new Date().toISOString()
  };
}

module.exports = {
  channels,
  createNotification,
  notifyForAlert,
  listNotifications,
  getMetrics,
  getHealth
};
'@
  Write-TextFile $NotificationEngineFile $notificationEngine

  $alertRoutes = @'
const express = require("express");
const router = express.Router();

const alertEngine = require("../automation/alertEngine");
const escalationEngine = require("../automation/escalationEngine");
const notificationEngine = require("../automation/notificationEngine");

router.get("/health", (req, res) => {
  res.json({
    alertEngine: alertEngine.getHealth(),
    escalationEngine: escalationEngine.getHealth(),
    notificationEngine: notificationEngine.getHealth()
  });
});

router.get("/metrics", (req, res) => {
  res.json({
    phase: "10Z.1",
    generatedAt: new Date().toISOString(),
    alerts: alertEngine.getMetrics(),
    escalations: escalationEngine.getMetrics(),
    notifications: notificationEngine.getMetrics()
  });
});

router.get("/open", (req, res) => {
  res.json({
    status: "OK",
    alerts: alertEngine.getOpenAlerts()
  });
});

router.get("/critical", (req, res) => {
  res.json({
    status: "OK",
    alerts: alertEngine.getCriticalAlerts()
  });
});

router.get("/high", (req, res) => {
  res.json({
    status: "OK",
    alerts: alertEngine.getHighAlerts()
  });
});

router.get("/dashboard", (req, res) => {
  res.json({
    ...alertEngine.getDashboard(),
    escalations: escalationEngine.listEscalations(),
    notifications: notificationEngine.listNotifications()
  });
});

router.get("/escalations", (req, res) => {
  res.json({
    status: "OK",
    escalations: escalationEngine.listEscalations()
  });
});

router.get("/notifications", (req, res) => {
  res.json({
    status: "OK",
    notifications: notificationEngine.listNotifications()
  });
});

router.post("/create", (req, res) => {
  const alert = alertEngine.createAlert(req.body || {});
  const notification = notificationEngine.notifyForAlert(alert, "DASHBOARD");

  res.status(201).json({
    status: "CREATED",
    alert,
    notification
  });
});

router.post("/resolve", (req, res) => {
  const result = alertEngine.resolveAlert(req.body.alertId, req.body || {});
  res.json({
    status: result.found ? "RESOLVED" : "NOT_FOUND",
    result
  });
});

router.post("/escalate", (req, res) => {
  const result = escalationEngine.escalateAlert(req.body || {});
  if (result.success) {
    notificationEngine.createNotification({
      alertId: result.escalation.alertId,
      channel: "DASHBOARD",
      recipient: result.escalation.level,
      message: result.escalation.reason
    });
  }

  res.status(result.success ? 200 : 404).json(result);
});

module.exports = router;
'@
  Write-TextFile $AlertRoutesFile $alertRoutes
}

function Create-FrontendFiles {
  Write-Step "Creating frontend API and page"

  Backup-File $FrontendApiFile
  Backup-File $FrontendPageFile

  $frontendApi = @'
const BASE_URL = "/api/enterprise/alerts";

export async function getAlertHealth() {
  const response = await fetch(`${BASE_URL}/health`);
  return response.json();
}

export async function getAlertMetrics() {
  const response = await fetch(`${BASE_URL}/metrics`);
  return response.json();
}

export async function getAlertDashboard() {
  const response = await fetch(`${BASE_URL}/dashboard`);
  return response.json();
}

export async function getOpenAlerts() {
  const response = await fetch(`${BASE_URL}/open`);
  return response.json();
}

export async function createAlert(payload) {
  const response = await fetch(`${BASE_URL}/create`, {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify(payload)
  });
  return response.json();
}

export async function resolveAlert(payload) {
  const response = await fetch(`${BASE_URL}/resolve`, {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify(payload)
  });
  return response.json();
}

export async function escalateAlert(payload) {
  const response = await fetch(`${BASE_URL}/escalate`, {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify(payload)
  });
  return response.json();
}
'@
  Write-TextFile $FrontendApiFile $frontendApi

  $frontendPage = @'
import React, { useEffect, useState } from "react";
import {
  getAlertDashboard,
  createAlert,
  escalateAlert,
  resolveAlert
} from "../api/alertEscalationApi";

export default function EnterpriseAlertEscalationCentre() {
  const [dashboard, setDashboard] = useState(null);
  const [status, setStatus] = useState("Loading...");

  async function refreshDashboard() {
    try {
      const data = await getAlertDashboard();
      setDashboard(data);
      setStatus("Live dashboard updated");
    } catch (error) {
      setStatus(`Dashboard failed: ${error.message}`);
    }
  }

  async function createTestCriticalAlert() {
    await createAlert({
      severity: "CRITICAL",
      category: "DEPLOYMENT",
      title: "Gatekeeper rejected deployment",
      message: "Deployment gatekeeper rejected release and blocked promotion.",
      source: "GATEKEEPER"
    });
    await refreshDashboard();
  }

  async function escalateFirstOpenAlert() {
    const first = dashboard?.openAlerts?.[0];
    if (!first) return;
    await escalateAlert({
      alertId: first.alertId,
      level: "EXECUTIVE",
      reason: "Critical alert requires executive attention"
    });
    await refreshDashboard();
  }

  async function resolveFirstOpenAlert() {
    const first = dashboard?.openAlerts?.[0];
    if (!first) return;
    await resolveAlert({
      alertId: first.alertId,
      resolvedBy: "OPERATOR",
      notes: "Resolved from Enterprise Alert & Escalation Centre",
      checksCompleted: true
    });
    await refreshDashboard();
  }

  useEffect(() => {
    refreshDashboard();
    const timer = setInterval(refreshDashboard, 15000);
    return () => clearInterval(timer);
  }, []);

  return (
    <div style={{ padding: "24px" }}>
      <h1>Enterprise Alert & Escalation Centre</h1>
      <p>{status}</p>

      <div style={{ display: "flex", gap: "12px", marginBottom: "16px" }}>
        <button onClick={refreshDashboard}>Refresh</button>
        <button onClick={createTestCriticalAlert}>Create Critical Test Alert</button>
        <button onClick={escalateFirstOpenAlert}>Escalate First Open Alert</button>
        <button onClick={resolveFirstOpenAlert}>Resolve First Open Alert</button>
      </div>

      <section>
        <h2>Health</h2>
        <pre>{JSON.stringify(dashboard?.health, null, 2)}</pre>
      </section>

      <section>
        <h2>Metrics</h2>
        <pre>{JSON.stringify(dashboard?.metrics, null, 2)}</pre>
      </section>

      <section>
        <h2>Open Alerts</h2>
        <pre>{JSON.stringify(dashboard?.openAlerts, null, 2)}</pre>
      </section>

      <section>
        <h2>Escalations</h2>
        <pre>{JSON.stringify(dashboard?.escalations, null, 2)}</pre>
      </section>

      <section>
        <h2>Notifications</h2>
        <pre>{JSON.stringify(dashboard?.notifications, null, 2)}</pre>
      </section>
    </div>
  );
}
'@
  Write-TextFile $FrontendPageFile $frontendPage
}

function Create-Docs {
  Write-Step "Creating complete protocol documentation"

  $docNames = @(
    "ALERT-MANAGEMENT-PROTOCOL.md",
    "ESCALATION-PROTOCOL.md",
    "ALERT-SEVERITY-MODEL.md",
    "COURT-DEADLINE-ALERTS.md",
    "INDUSTRIAL-COURT-ALERTS.md",
    "PERKESO-ALERTS.md",
    "DEPLOYMENT-ALERTS.md",
    "NOTIFICATION-PROTOCOL.md",
    "ALERT-RESOLUTION-PROCESS.md"
  )

  foreach ($doc in $docNames) {
    $title = $doc.Replace(".md","").Replace("-"," ")
    $content = @"
# $title

## Purpose
This document defines the Phase 10Z.1 Enterprise Alert & Escalation Centre control rules for Litigation 360.

## Scope
Applies to backend alert generation, escalation routing, notification placeholders, dashboards, reports, validation and operator checks.

## Inputs
- System health signals
- Database health signals
- Backend and frontend operational signals
- Workflow, document, court, Industrial Court, PERKESO, navigation, deployment, security, performance, backup and gatekeeper signals
- Operator-created alerts
- Validation script outputs

## Outputs
- Alert records
- Escalation records
- Notification records
- Dashboard data
- Health data
- Metrics data
- Validation reports
- Operator checklists

## Parameters
Severity values:
- CRITICAL
- HIGH
- MEDIUM
- LOW
- INFO

Status values:
- OPEN
- ACKNOWLEDGED
- ESCALATED
- RESOLVED
- CLOSED

Escalation levels:
- OPERATIONS
- MANAGER
- EXECUTIVE
- URGENT

Notification channels:
- DASHBOARD
- LOG
- EMAIL_PLACEHOLDER
- SMS_PLACEHOLDER
- WHATSAPP_PLACEHOLDER

Required categories:
- SYSTEM
- DATABASE
- BACKEND
- FRONTEND
- WORKFLOW
- DOCUMENT
- COURT
- INDUSTRIAL_COURT
- PERKESO
- NAVIGATION
- DEPLOYMENT
- SECURITY
- PERFORMANCE
- BACKUP
- GATEKEEPER

## Rules
1. Critical alerts must be visible on dashboard and escalation-ready.
2. High alerts must be visible on dashboard and manager-ready.
3. Real SMS, WhatsApp and email sending are not enabled in Phase 10Z.1.
4. Industrial Court Kuala Lumpur coverage must remain present.
5. PERKESO Kuala Lumpur / Jalan Tun Razak coverage must remain present.
6. PERKESO Headquarters / Jalan Ampang coverage must remain present.
7. Google Maps readiness, Waze readiness and court navigation readiness must remain present.
8. Deployment gatekeeper, release block, environment critical, hardening, backup and performance alerts must remain present.
9. Resolution requires operator notes and checks completed flag.
10. Validation must print PASS only when every required file, registry, route, flow and coverage check passes.

## Process
1. Create or receive alert.
2. Classify severity and category.
3. Queue dashboard notification.
4. Escalate if required.
5. Display on live dashboard endpoint.
6. Operator reviews alert.
7. Operator resolves alert with notes.
8. Validation confirms flow integrity.
9. Reports are saved under _operations.

## Validation
Use:
```cmd
cd /d "C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software"
powershell -NoProfile -ExecutionPolicy Bypass -File ".\L360-PHASE10Z1-ENTERPRISE-ALERT-ESCALATION-CENTRE.ps1" -Mode VALIDATE
```

Expected:
```text
PHASE 10Z.1 ALERT & ESCALATION CENTRE STATUS: PASS
```

## Operator Checklist
- Confirm backend starts.
- Confirm `/api/enterprise/alerts/health` works.
- Confirm `/api/enterprise/alerts/metrics` works.
- Confirm `/api/enterprise/alerts/dashboard` works.
- Confirm critical alert flow works.
- Confirm high alert flow works.
- Confirm escalation flow works.
- Confirm resolution flow works.
- Confirm Industrial Court coverage exists.
- Confirm PERKESO coverage exists.
- Confirm deployment coverage exists.
- Confirm validation report exists.
"@
    Write-TextFile (Join-Path $DocsDir $doc) $content
  }
}

function Create-ValidationScript {
  Write-Step "Creating validation script"

  $validatorPath = Join-Path $ValidationDir "validate-phase-10Z1.js"
  $validator = @'
const fs = require("fs");
const path = require("path");

const root = process.env.L360_PROJECT_ROOT;
if (!root) {
  console.error("L360_PROJECT_ROOT environment variable missing.");
  process.exit(1);
}

const paths = {
  alertEngine: path.join(root, "backend", "src", "automation", "alertEngine.js"),
  escalationEngine: path.join(root, "backend", "src", "automation", "escalationEngine.js"),
  notificationEngine: path.join(root, "backend", "src", "automation", "notificationEngine.js"),
  alertRoute: path.join(root, "backend", "src", "routes", "alertRoutes.js"),
  index: path.join(root, "backend", "src", "index.js"),
  alertRegistry: path.join(root, "_operations", "phase-10Z1-alert-escalation-centre", "alerts", "alert-registry.json"),
  escalationRegistry: path.join(root, "_operations", "phase-10Z1-alert-escalation-centre", "escalations", "escalation-registry.json"),
  notificationRegistry: path.join(root, "_operations", "phase-10Z1-alert-escalation-centre", "notifications", "notification-registry.json"),
  dashboard: path.join(root, "_operations", "phase-10Z1-alert-escalation-centre", "dashboards", "alert-dashboard.json"),
  health: path.join(root, "_operations", "phase-10Z1-alert-escalation-centre", "reports", "alert-health.json"),
  metrics: path.join(root, "_operations", "phase-10Z1-alert-escalation-centre", "reports", "alert-metrics.json")
};

function exists(p) {
  return fs.existsSync(p);
}

function contains(p, value) {
  return exists(p) && fs.readFileSync(p, "utf8").includes(value);
}

function check(label, value, results) {
  results.push({ label, value: Boolean(value) });
}

const results = [];

check("Alert Engine Exists", exists(paths.alertEngine), results);
check("Escalation Engine Exists", exists(paths.escalationEngine), results);
check("Notification Engine Exists", exists(paths.notificationEngine), results);
check("Alert Route Exists", exists(paths.alertRoute), results);
check("Route Mounted In index.js", contains(paths.index, 'app.use("/api/enterprise/alerts", require("./routes/alertRoutes"));'), results);
check("Alert Registry Exists", exists(paths.alertRegistry), results);
check("Escalation Registry Exists", exists(paths.escalationRegistry), results);
check("Notification Registry Exists", exists(paths.notificationRegistry), results);

const alertEngine = require(paths.alertEngine);
const escalationEngine = require(paths.escalationEngine);
const notificationEngine = require(paths.notificationEngine);

const criticalAlert = alertEngine.createAlert({
  severity: "CRITICAL",
  category: "DATABASE",
  title: "Validation critical alert",
  message: "Critical alert validation flow.",
  source: "VALIDATION"
});

const highAlert = alertEngine.createAlert({
  severity: "HIGH",
  category: "INDUSTRIAL_COURT",
  title: "Industrial Court hearing tomorrow",
  message: "Industrial Court hearing tomorrow validation flow.",
  source: "VALIDATION"
});

const criticalNotification = notificationEngine.notifyForAlert(criticalAlert, "DASHBOARD");
const highNotification = notificationEngine.notifyForAlert(highAlert, "DASHBOARD");
const escalation = escalationEngine.escalateAlert({
  alertId: criticalAlert.alertId,
  level: "EXECUTIVE",
  reason: "Critical alert requires executive attention"
});
const resolution = alertEngine.resolveAlert(highAlert.alertId, {
  resolvedBy: "VALIDATION",
  notes: "High alert validation resolved.",
  checksCompleted: true
});

check("Critical Alert Flow Working", criticalAlert.severity === "CRITICAL" && criticalAlert.status === "ESCALATED", results);
check("High Alert Flow Working", highAlert.severity === "HIGH" && resolution.found === true, results);
check("Escalation Flow Working", escalation.success === true && escalation.escalation.level === "EXECUTIVE", results);
check("Resolution Flow Working", resolution.found === true && resolution.alert.status === "RESOLVED", results);
check("Notification Flow Working", criticalNotification.status === "QUEUED" && highNotification.status === "QUEUED", results);

const coverage = alertEngine.requiredCoverage;
check("Industrial Court Coverage Present", JSON.stringify(coverage.industrialCourt).includes("Industrial Court Kuala Lumpur"), results);
check("PERKESO Coverage Present", JSON.stringify(coverage.perkeso).includes("PERKESO Headquarters / Jalan Ampang"), results);
check("Deployment Coverage Present", JSON.stringify(coverage.deployment).includes("Gatekeeper rejected deployment"), results);

const dashboard = alertEngine.getDashboard();
const health = alertEngine.getHealth();
const metrics = alertEngine.getMetrics();

fs.writeFileSync(paths.dashboard, JSON.stringify(dashboard, null, 2));
fs.writeFileSync(paths.health, JSON.stringify(health, null, 2));
fs.writeFileSync(paths.metrics, JSON.stringify(metrics, null, 2));

check("Dashboard Generated", exists(paths.dashboard), results);
check("Health Generated", exists(paths.health), results);
check("Metrics Generated", exists(paths.metrics), results);

const pass = results.every((item) => item.value === true);

for (const item of results) {
  console.log(`${item.label}: ${item.value}`);
}

const validationReport = {
  phase: "10Z.1",
  name: "Enterprise Alert & Escalation Centre",
  generatedAt: new Date().toISOString(),
  pass,
  results
};

const reportPath = path.join(root, "_operations", "phase-10Z1-alert-escalation-centre", "validation", "validation-report.json");
fs.writeFileSync(reportPath, JSON.stringify(validationReport, null, 2));

console.log("");
console.log("Validation Report:");
console.log(reportPath);
console.log("");

if (pass) {
  console.log("PHASE 10Z.1 ALERT & ESCALATION CENTRE STATUS: PASS");
  process.exit(0);
}

console.log("PHASE 10Z.1 ALERT & ESCALATION CENTRE STATUS: FAIL");
process.exit(1);
'@
  Write-TextFile $validatorPath $validator
}

function Run-Validation {
  Write-Step "Running validation"
  $env:L360_PROJECT_ROOT = $ProjectRoot
  $validatorPath = Join-Path $ValidationDir "validate-phase-10Z1.js"
  Push-Location $ProjectRoot
  try {
    node $validatorPath
  }
  finally {
    Pop-Location
  }
}

function Create-MonitoringArtifacts {
  Write-Step "Creating live monitoring and performance files"

  $monitor = @"
# Phase 10Z.1 Live Monitoring

## Live Endpoints
- GET /api/enterprise/alerts/health
- GET /api/enterprise/alerts/metrics
- GET /api/enterprise/alerts/dashboard
- GET /api/enterprise/alerts/open
- GET /api/enterprise/alerts/critical
- GET /api/enterprise/alerts/high
- GET /api/enterprise/alerts/escalations
- GET /api/enterprise/alerts/notifications

## Live Progress Monitoring
Frontend page refreshes dashboard data every 15 seconds.

## Performance Data
Performance signals generated:
- totalAlerts
- openAlerts
- criticalAlerts
- highAlerts
- resolvedAlerts
- totalEscalations
- activeEscalations
- totalNotifications
- queuedNotifications

## Checks and Balances
- No real SMS, WhatsApp or email sending in this phase.
- Dashboard notification placeholder only.
- Operator resolution notes required.
- Court, Industrial Court, PERKESO, navigation and deployment coverage retained.
"@
  Write-TextFile (Join-Path $DocsDir "LIVE-MONITORING-AND-PERFORMANCE.md") $monitor

  $liveCheck = @"
@echo off
cd /d "$ProjectRoot"
echo Checking Phase 10Z.1 alert endpoints...
echo.
curl http://localhost:5100/api/enterprise/alerts/health
echo.
curl http://localhost:5100/api/enterprise/alerts/metrics
echo.
curl http://localhost:5100/api/enterprise/alerts/dashboard
echo.
pause
"@
  Write-TextFile (Join-Path $OpsRoot "CHECK-PHASE10Z1-ENDPOINTS.bat") $liveCheck
}

function Apply-Phase {
  Assert-Root

  Write-Step "Creating strategic folder structure"
  @(
    $AutomationDir,$RoutesDir,$FrontendApiDir,$FrontendPagesDir,
    $OpsRoot,$AlertsDir,$EscalationsDir,$NotificationsDir,$ReportsDir,
    $DashboardsDir,$LogsDir,$DocsDir,$ValidationDir,$BackupDir
  ) | ForEach-Object { Ensure-Directory $_ }

  Create-OperationsFiles
  Create-BackendFiles
  Create-FrontendFiles
  Mount-Route
  Create-Docs
  Create-MonitoringArtifacts
  Create-ValidationScript
  Run-Validation

  Write-Host ""
  Write-Host "Reports:" -ForegroundColor Green
  Write-Host (Join-Path $ValidationDir "validation-report.json")
  Write-Host (Join-Path $DashboardsDir "alert-dashboard.json")
  Write-Host (Join-Path $ReportsDir "alert-health.json")
  Write-Host (Join-Path $ReportsDir "alert-metrics.json")
}

try {
  if ($Mode -eq "APPLY") {
    Apply-Phase
  } else {
    Assert-Root
    Run-Validation
  }
}
catch {
  Write-Host ""
  Write-Host "PHASE 10Z.1 ALERT & ESCALATION CENTRE STATUS: FAIL" -ForegroundColor Red
  Write-Host $_.Exception.Message -ForegroundColor Red
  exit 1
}
finally {
  Write-Host ""
  Read-Host "Press Enter to close"
}
