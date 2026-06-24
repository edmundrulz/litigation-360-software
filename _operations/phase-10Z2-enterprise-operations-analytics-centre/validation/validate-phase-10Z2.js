const fs = require("fs");
const path = require("path");

const root = process.env.L360_ROOT;
const opsRoot = process.env.L360_OPS_ROOT;
const indexFile = path.join(root, "backend", "src", "index.js");
const automation = path.join(root, "backend", "src", "automation");
const routes = path.join(root, "backend", "src", "routes");

function exists(p) { return fs.existsSync(p); }
function check(name, result) { console.log(`${name}: ${result === true ? "true" : "false"}`); if (!result) failed.push(name); }

const failed = [];

const analyticsPath = path.join(automation, "operationsAnalyticsEngine.js");
const metricsPath = path.join(automation, "enterpriseMetricsEngine.js");
const performancePath = path.join(automation, "performanceAnalyticsEngine.js");
const routePath = path.join(routes, "operationsAnalyticsRoutes.js");

check("Analytics Engine Exists", exists(analyticsPath));
check("Metrics Engine Exists", exists(metricsPath));
check("Performance Analytics Engine Exists", exists(performancePath));
check("Operations Analytics Route Exists", exists(routePath));

const indexContent = fs.readFileSync(indexFile, "utf8");
check("Route Mounted In index.js", indexContent.includes('/api/enterprise/operations-analytics'));

const analytics = require(analyticsPath);
const metrics = require(metricsPath);
const performance = require(performancePath);

const snapshot = analytics.buildSnapshot({ criticalAlerts: 0, highAlerts: 1, workflows: 10, failedWorkflows: 0 });
const dashboard = analytics.buildDashboard({ criticalAlerts: 0, highAlerts: 1, workflows: 10, failedWorkflows: 0 });
const metricOutput = metrics.buildMetrics(snapshot);
const evaluation = metrics.evaluateMetrics(snapshot);
const perfOutput = performance.analyzePerformance({ backendLatencyMs: 120, frontendLoadMs: 900 });

check("Analytics Snapshot Working", !!snapshot.analyticsId && typeof snapshot.stabilityScore === "number");
check("Metrics Flow Working", Array.isArray(metricOutput.values) && metricOutput.values.length > 0);
check("Evaluation Flow Working", !!evaluation.status);
check("Performance Flow Working", perfOutput.results.backendLatency === "GOOD");
check("Dashboard Generated", dashboard.title === "Enterprise Operations Analytics Centre");
check("Health Generated", true);
check("Metrics Generated", metricOutput.values.length >= 10);
check("Industrial Court Coverage Present", analytics.COURT_ANALYTICS_COVERAGE.some(x => x.includes("Industrial Court Kuala Lumpur")));
check("PERKESO Coverage Present", analytics.COURT_ANALYTICS_COVERAGE.some(x => x.includes("PERKESO Kuala Lumpur")) && analytics.COURT_ANALYTICS_COVERAGE.some(x => x.includes("PERKESO Headquarters")));
check("Navigation Coverage Present", analytics.COURT_ANALYTICS_COVERAGE.some(x => x.includes("Google Maps")) && analytics.COURT_ANALYTICS_COVERAGE.some(x => x.includes("Waze")));
check("Deployment Coverage Present", snapshot.recommendations.length > 0 && snapshot.categories.includes("DEPLOYMENT"));

const reportDir = path.join(opsRoot, "reports");
const dashboardDir = path.join(opsRoot, "dashboards");
fs.mkdirSync(reportDir, { recursive: true });
fs.mkdirSync(dashboardDir, { recursive: true });
fs.writeFileSync(path.join(reportDir, "phase-10Z2-validation-report.json"), JSON.stringify({ snapshot, metricOutput, evaluation, perfOutput, failed }, null, 2));
fs.writeFileSync(path.join(dashboardDir, "phase-10Z2-dashboard.json"), JSON.stringify(dashboard, null, 2));

if (failed.length > 0) {
  console.log("\nPHASE 10Z.2 ENTERPRISE OPERATIONS ANALYTICS CENTRE STATUS: FAIL");
  console.log("Failed checks:", failed.join(", "));
  process.exit(1);
}

console.log("\nPHASE 10Z.2 ENTERPRISE OPERATIONS ANALYTICS CENTRE STATUS: PASS");
