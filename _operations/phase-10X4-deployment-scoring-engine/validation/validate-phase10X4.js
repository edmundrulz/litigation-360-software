const fs = require("fs");
const path = require("path");

const root = process.env.L360_ROOT;
const src = path.join(root, "backend", "src");
const reports = process.env.L360_REPORTS;
fs.mkdirSync(reports, { recursive: true });

const enginePath = path.join(src, "automation", "deploymentScoringEngine.js");
const routePath = path.join(src, "routes", "deploymentScoringRoutes.js");
const indexPath = path.join(src, "index.js");

if (!fs.existsSync(enginePath)) {
  console.log("Deployment Scoring Engine missing. Run APPLY mode.");
  process.exit(1);
}

const engine = require(enginePath);

const report = engine.generateScoringReport();
const dashboard = engine.getScoringDashboard();
const readiness = engine.getScoringReadiness();
const grade = engine.getEnterpriseGrade();
const trends = engine.getTrends();
const health = engine.getScoringHealth();
const indexText = fs.readFileSync(indexPath, "utf8");

const validation = {
  phase: "10X.4",
  module: "Deployment Scoring Engine",
  timestamp: new Date().toISOString(),
  files: {
    engineExists: fs.existsSync(enginePath),
    routeExists: fs.existsSync(routePath),
    routeMountedInIndex: indexText.includes("deploymentScoringRoutes")
  },
  tests: {
    reportGenerated: typeof report.overallScore === "number",
    dashboardGenerated: typeof dashboard.overallScore === "number",
    readinessGenerated: !!readiness.status,
    gradeGenerated: !!grade.grade,
    trendsGenerated: !!trends.direction,
    healthGenerated: !!health.status
  },
  health,
  readiness,
  grade,
  status: (
    fs.existsSync(enginePath) &&
    fs.existsSync(routePath) &&
    indexText.includes("deploymentScoringRoutes") &&
    typeof report.overallScore === "number" &&
    typeof dashboard.overallScore === "number" &&
    !!readiness.status &&
    !!grade.grade &&
    !!trends.direction &&
    !!health.status
  ) ? "PASS" : "FAIL"
};

fs.writeFileSync(path.join(reports, "phase10X4-deployment-scoring-report.json"), JSON.stringify(validation, null, 2));

console.log([
  "LITIGATION 360 - PHASE 10X.4 DEPLOYMENT SCORING ENGINE REPORT",
  "============================================================",
  "",
  "Timestamp: " + validation.timestamp,
  "Status: " + validation.status,
  "Engine Exists: " + validation.files.engineExists,
  "Route Exists: " + validation.files.routeExists,
  "Route Mounted In index.js: " + validation.files.routeMountedInIndex,
  "Report Generated: " + validation.tests.reportGenerated,
  "Dashboard Generated: " + validation.tests.dashboardGenerated,
  "Readiness Generated: " + validation.tests.readinessGenerated,
  "Grade Generated: " + validation.tests.gradeGenerated,
  "Trends Generated: " + validation.tests.trendsGenerated,
  "Health Generated: " + validation.tests.healthGenerated,
  "Overall Score: " + report.overallScore,
  "Enterprise Grade: " + report.enterpriseGrade,
  "Risk: " + report.risk,
  "Deployment Ready: " + report.deploymentReady,
  "Release Approved: " + report.releaseApproved,
  "Blockers: " + report.blockerCount,
  "Warnings: " + report.warningCount
].join("\n"));

if (validation.status !== "PASS") process.exit(1);
