const fs = require("fs");
const path = require("path");

const OPERATIONS_ROOT = path.join(process.cwd(), "..", "_operations", "phase-10Z2-enterprise-operations-analytics-centre");

const ANALYTICS_CATEGORIES = [
  "SYSTEM", "DATABASE", "BACKEND", "FRONTEND", "WORKFLOW", "DOCUMENT",
  "COURT", "INDUSTRIAL_COURT", "PERKESO", "NAVIGATION", "DEPLOYMENT",
  "SECURITY", "PERFORMANCE", "BACKUP", "GATEKEEPER", "ALERTS", "ESCALATIONS"
];

const COURT_ANALYTICS_COVERAGE = [
  "Industrial Court Kuala Lumpur",
  "Industrial Court hearing analytics",
  "Industrial Court filing deadline analytics",
  "Industrial Court attendance reminder analytics",
  "Industrial Court navigation departure analytics",
  "PERKESO Kuala Lumpur / Jalan Tun Razak",
  "PERKESO Headquarters / Jalan Ampang",
  "PERKESO submission analytics",
  "PERKESO appointment analytics",
  "Google Maps readiness analytics",
  "Waze readiness analytics"
];

function nowIso() { return new Date().toISOString(); }

function ensureDir(target) {
  if (!fs.existsSync(target)) fs.mkdirSync(target, { recursive: true });
}

function score(value, max) {
  if (!max || max <= 0) return 100;
  return Math.max(0, Math.min(100, Math.round((value / max) * 100)));
}

function buildSnapshot(input = {}) {
  const openAlerts = Number(input.openAlerts || 0);
  const criticalAlerts = Number(input.criticalAlerts || 0);
  const highAlerts = Number(input.highAlerts || 0);
  const escalations = Number(input.escalations || 0);
  const workflows = Number(input.workflows || 0);
  const failedWorkflows = Number(input.failedWorkflows || 0);
  const backupFailures = Number(input.backupFailures || 0);
  const deploymentBlocks = Number(input.deploymentBlocks || 0);
  const performanceIncidents = Number(input.performanceIncidents || 0);

  const riskScore = Math.min(100, criticalAlerts * 20 + highAlerts * 10 + escalations * 8 + backupFailures * 15 + deploymentBlocks * 12 + performanceIncidents * 8);
  const stabilityScore = Math.max(0, 100 - riskScore);
  const workflowSuccessRate = workflows > 0 ? Math.max(0, Math.round(((workflows - failedWorkflows) / workflows) * 100)) : 100;

  return {
    analyticsId: `ANA-${Date.now()}`,
    generatedAt: nowIso(),
    categories: ANALYTICS_CATEGORIES,
    operationsHealth: stabilityScore >= 85 ? "HEALTHY" : stabilityScore >= 70 ? "WATCH" : stabilityScore >= 50 ? "DEGRADED" : "CRITICAL",
    stabilityScore,
    riskScore,
    workflowSuccessRate,
    alertLoadScore: score(openAlerts, 100),
    criticalAlertCount: criticalAlerts,
    highAlertCount: highAlerts,
    escalationCount: escalations,
    backupFailureCount: backupFailures,
    deploymentBlockCount: deploymentBlocks,
    performanceIncidentCount: performanceIncidents,
    courtCoverage: COURT_ANALYTICS_COVERAGE,
    recommendations: buildRecommendations({ criticalAlerts, highAlerts, escalations, backupFailures, deploymentBlocks, performanceIncidents, workflowSuccessRate })
  };
}

function buildRecommendations(data) {
  const items = [];
  if (data.criticalAlerts > 0) items.push("Resolve CRITICAL alerts before new deployment activity.");
  if (data.highAlerts > 0) items.push("Review HIGH alerts in operations dashboard and assign owner.");
  if (data.escalations > 0) items.push("Check active escalations and confirm manager or executive acknowledgement.");
  if (data.backupFailures > 0) items.push("Run backup verification before production changes.");
  if (data.deploymentBlocks > 0) items.push("Review deployment gatekeeper and release validator reports.");
  if (data.performanceIncidents > 0) items.push("Run performance optimization and backend metrics review.");
  if (data.workflowSuccessRate < 90) items.push("Audit workflow engine logs and failed workflow queue.");
  if (items.length === 0) items.push("Operations analytics are stable. Continue scheduled monitoring.");
  return items;
}

function writeSnapshot(snapshot) {
  const dir = path.join(OPERATIONS_ROOT, "snapshots");
  ensureDir(dir);
  const file = path.join(dir, `${snapshot.analyticsId}.json`);
  fs.writeFileSync(file, JSON.stringify(snapshot, null, 2));
  return file;
}

function buildDashboard(input = {}) {
  const snapshot = buildSnapshot(input);
  return {
    title: "Enterprise Operations Analytics Centre",
    phase: "10Z.2",
    generatedAt: nowIso(),
    snapshot,
    liveMonitoring: {
      refreshSeconds: 30,
      endpoints: [
        "/api/enterprise/operations-analytics/health",
        "/api/enterprise/operations-analytics/metrics",
        "/api/enterprise/operations-analytics/dashboard",
        "/api/enterprise/operations-analytics/performance",
        "/api/enterprise/operations-analytics/courts",
        "/api/enterprise/operations-analytics/deployment"
      ]
    },
    checksAndBalances: [
      "Health score must remain above 85 for normal operations.",
      "Critical alerts must be resolved or escalated before release activity.",
      "Industrial Court and PERKESO coverage must remain visible in dashboard.",
      "Backup and gatekeeper failures must block deployment readiness.",
      "Performance incidents must be reviewed before executive status is marked healthy."
    ]
  };
}

module.exports = {
  ANALYTICS_CATEGORIES,
  COURT_ANALYTICS_COVERAGE,
  buildSnapshot,
  writeSnapshot,
  buildDashboard
};
