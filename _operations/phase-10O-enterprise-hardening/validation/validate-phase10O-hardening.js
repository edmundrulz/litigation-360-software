const fs = require("fs");
const path = require("path");

const root = path.resolve(__dirname, "..", "..", "..");
const src = path.join(root, "backend", "src");
const reports = path.join(root, "_operations", "phase-10O-enterprise-hardening", "reports");
fs.mkdirSync(reports, { recursive: true });

const enginePath = path.join(src, "automation", "enterpriseHardeningEngine.js");
const routePath = path.join(src, "routes", "enterpriseHardeningRoutes.js");
const indexPath = path.join(src, "index.js");

if (!fs.existsSync(enginePath)) {
  console.log("Enterprise Hardening Engine missing. Run APPLY mode.");
  process.exit(1);
}

const engine = require(enginePath);

const validation = engine.runFullValidation();
const readiness = engine.getDeploymentReadiness();
const healthScore = engine.getEnterpriseHealthScore();
const health = engine.getHardeningHealth();
const indexText = fs.readFileSync(indexPath, "utf8");

const report = {
  phase: "10O",
  module: "Enterprise Hardening",
  timestamp: new Date().toISOString(),
  files: {
    engineExists: fs.existsSync(enginePath),
    routeExists: fs.existsSync(routePath),
    routeMountedInIndex: indexText.includes("enterpriseHardeningRoutes")
  },
  validation,
  readiness,
  healthScore,
  health,
  status: (
    fs.existsSync(enginePath) &&
    fs.existsSync(routePath) &&
    indexText.includes("enterpriseHardeningRoutes") &&
    typeof readiness.healthScore === "number" &&
    typeof healthScore.healthScore === "number" &&
    !!health.status
  ) ? "PASS" : "FAIL"
};

fs.writeFileSync(path.join(reports, "phase10O-hardening-report.json"), JSON.stringify(report, null, 2));

const lines = [
  "LITIGATION 360 - PHASE 10O ENTERPRISE HARDENING REPORT",
  "======================================================",
  "",
  "Timestamp: " + report.timestamp,
  "Status: " + report.status,
  "Engine Exists: " + report.files.engineExists,
  "Route Exists: " + report.files.routeExists,
  "Route Mounted In index.js: " + report.files.routeMountedInIndex,
  "Deployment Status: " + readiness.status,
  "Deployment Ready: " + readiness.deploymentReady,
  "Health Score: " + readiness.healthScore,
  "Blocking Issues: " + readiness.blockingIssuesCount,
  "Hardening Health: " + health.status
];

fs.writeFileSync(path.join(reports, "phase10O-hardening-report.txt"), lines.join("\n"));
console.log(lines.join("\n"));

if (report.status !== "PASS") process.exit(1);
