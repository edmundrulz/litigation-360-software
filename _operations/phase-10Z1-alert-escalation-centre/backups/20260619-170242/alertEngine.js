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
