function nowIso() { return new Date().toISOString(); }

const METRIC_REGISTRY = [
  { key: "operationsHealth", label: "Operations Health", type: "status" },
  { key: "stabilityScore", label: "Stability Score", type: "percentage" },
  { key: "riskScore", label: "Risk Score", type: "percentage" },
  { key: "workflowSuccessRate", label: "Workflow Success Rate", type: "percentage" },
  { key: "criticalAlertCount", label: "Critical Alerts", type: "count" },
  { key: "highAlertCount", label: "High Alerts", type: "count" },
  { key: "escalationCount", label: "Escalations", type: "count" },
  { key: "backupFailureCount", label: "Backup Failures", type: "count" },
  { key: "deploymentBlockCount", label: "Deployment Blocks", type: "count" },
  { key: "performanceIncidentCount", label: "Performance Incidents", type: "count" }
];

function buildMetrics(snapshot) {
  return {
    generatedAt: nowIso(),
    registry: METRIC_REGISTRY,
    values: METRIC_REGISTRY.map(metric => ({
      ...metric,
      value: snapshot[metric.key]
    })),
    thresholds: {
      stabilityScore: { pass: 85, watch: 70, fail: 50 },
      riskScore: { passBelow: 15, watchBelow: 30, failAtOrAbove: 50 },
      workflowSuccessRate: { pass: 95, watch: 90, failBelow: 80 },
      criticalAlertCount: { pass: 0, failAbove: 0 },
      backupFailureCount: { pass: 0, failAbove: 0 },
      deploymentBlockCount: { pass: 0, failAbove: 0 }
    }
  };
}

function evaluateMetrics(snapshot) {
  const metrics = buildMetrics(snapshot);
  const failures = [];
  if (snapshot.stabilityScore < 50) failures.push("Stability score below fail threshold.");
  if (snapshot.riskScore >= 50) failures.push("Risk score above fail threshold.");
  if (snapshot.workflowSuccessRate < 80) failures.push("Workflow success rate below fail threshold.");
  if (snapshot.criticalAlertCount > 0) failures.push("Critical alerts present.");
  if (snapshot.backupFailureCount > 0) failures.push("Backup failures present.");
  if (snapshot.deploymentBlockCount > 0) failures.push("Deployment blocks present.");
  return {
    generatedAt: nowIso(),
    status: failures.length === 0 ? "PASS" : "REVIEW_REQUIRED",
    failures,
    metrics
  };
}

module.exports = { METRIC_REGISTRY, buildMetrics, evaluateMetrics };
