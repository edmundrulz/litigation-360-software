const fs = require("fs");
const path = require("path");

const root = path.resolve(__dirname, "..", "..");
const src = path.join(root, "backend", "src");
const reports = path.join(root, "_operations", "phase-10O-hardening-path-fix", "reports");
fs.mkdirSync(reports, { recursive: true });

const enginePath = path.join(src, "automation", "enterpriseHardeningEngine.js");

delete require.cache[require.resolve(enginePath)];
const engine = require(enginePath);

const readiness = engine.getDeploymentReadiness();
const dashboard = engine.getEnterpriseHardeningDashboard();
const health = engine.getHardeningHealth();

const report = {
  phase: "10O-PATH-FIX",
  timestamp: new Date().toISOString(),
  engineExists: fs.existsSync(enginePath),
  deploymentStatus: readiness.status,
  deploymentReady: readiness.deploymentReady,
  healthScore: readiness.healthScore,
  blockingIssuesCount: readiness.blockingIssuesCount,
  blockingIssues: readiness.blockingIssues,
  dashboardStatus: dashboard.status,
  hardeningHealth: health.status,
  status: (
    fs.existsSync(enginePath) &&
    typeof readiness.healthScore === "number" &&
    readiness.healthScore > 0 &&
    readiness.blockingIssuesCount < 67
  ) ? "PASS" : "FAIL"
};

fs.writeFileSync(path.join(reports, "phase10O-path-fix-report.json"), JSON.stringify(report, null, 2));

console.log([
  "LITIGATION 360 - PHASE 10O HARDENING PATH FIX REPORT",
  "====================================================",
  "",
  "Timestamp: " + report.timestamp,
  "Status: " + report.status,
  "Engine Exists: " + report.engineExists,
  "Deployment Status: " + report.deploymentStatus,
  "Deployment Ready: " + report.deploymentReady,
  "Health Score: " + report.healthScore,
  "Blocking Issues: " + report.blockingIssuesCount,
  "Hardening Health: " + report.hardeningHealth
].join("\n"));

if(report.status !== "PASS") process.exit(1);
