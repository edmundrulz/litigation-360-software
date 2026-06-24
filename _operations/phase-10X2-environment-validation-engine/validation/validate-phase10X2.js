const fs = require("fs");
const path = require("path");

const root = process.env.L360_ROOT;
const src = path.join(root, "backend", "src");
const reports = process.env.L360_REPORTS;
fs.mkdirSync(reports, { recursive: true });

const enginePath = path.join(src, "automation", "environmentValidationEngine.js");
const routePath = path.join(src, "routes", "environmentValidationRoutes.js");
const indexPath = path.join(src, "index.js");

if (!fs.existsSync(enginePath)) {
  console.log("Environment Validation Engine missing. Run APPLY mode.");
  process.exit(1);
}

const engine = require(enginePath);

const report = engine.generateEnvironmentReport();
const summary = engine.getEnvironmentSummary();
const readiness = engine.getEnvironmentReadiness();
const health = engine.getEnvironmentHealth();
const indexText = fs.readFileSync(indexPath, "utf8");

const validation = {
  phase: "10X.2",
  module: "Environment Validation Engine",
  timestamp: new Date().toISOString(),
  files: {
    engineExists: fs.existsSync(enginePath),
    routeExists: fs.existsSync(routePath),
    routeMountedInIndex: indexText.includes("environmentValidationRoutes")
  },
  tests: {
    reportGenerated: typeof report.environmentScore === "number",
    summaryGenerated: !!summary.plainEnglish,
    readinessGenerated: typeof readiness.environmentScore === "number",
    healthGenerated: !!health.status,
    sectionsGenerated: Array.isArray(report.sections) && report.sections.length >= 8
  },
  health,
  readiness,
  status: (
    fs.existsSync(enginePath) &&
    fs.existsSync(routePath) &&
    indexText.includes("environmentValidationRoutes") &&
    typeof report.environmentScore === "number" &&
    !!summary.plainEnglish &&
    typeof readiness.environmentScore === "number" &&
    !!health.status &&
    Array.isArray(report.sections) &&
    report.sections.length >= 8
  ) ? "PASS" : "FAIL"
};

fs.writeFileSync(path.join(reports, "phase10X2-environment-validation-report.json"), JSON.stringify(validation, null, 2));

console.log([
  "LITIGATION 360 - PHASE 10X.2 ENVIRONMENT VALIDATION REPORT",
  "=========================================================",
  "",
  "Timestamp: " + validation.timestamp,
  "Status: " + validation.status,
  "Engine Exists: " + validation.files.engineExists,
  "Route Exists: " + validation.files.routeExists,
  "Route Mounted In index.js: " + validation.files.routeMountedInIndex,
  "Report Generated: " + validation.tests.reportGenerated,
  "Summary Generated: " + validation.tests.summaryGenerated,
  "Readiness Generated: " + validation.tests.readinessGenerated,
  "Health Generated: " + validation.tests.healthGenerated,
  "Sections Generated: " + validation.tests.sectionsGenerated,
  "Environment Status: " + readiness.status,
  "Deployment Ready: " + readiness.deploymentReady,
  "Environment Score: " + readiness.environmentScore,
  "Risk: " + readiness.risk,
  "Blocking Issues: " + readiness.blockingIssuesCount
].join("\n"));

if (validation.status !== "PASS") process.exit(1);
