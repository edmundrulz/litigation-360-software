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
