const fs = require("fs");
const path = require("path");

const root = process.env.L360_ROOT;
const src = path.join(root, "backend", "src");
const reports = process.env.L360_REPORTS;
fs.mkdirSync(reports, { recursive: true });

const enginePath = path.join(src, "automation", "releaseValidatorEngine.js");
const routePath = path.join(src, "routes", "releaseValidatorRoutes.js");
const indexPath = path.join(src, "index.js");

if (!fs.existsSync(enginePath)) {
  console.log("Release Validator Engine missing. Run APPLY mode.");
  process.exit(1);
}

const engine = require(enginePath);

const validation = engine.validateRelease();
const summary = engine.getReleaseSummary();
const health = engine.getReleaseHealth();
const candidate = engine.generateReleaseCandidate("validation");
const indexText = fs.readFileSync(indexPath, "utf8");

const report = {
  phase: "10X.3",
  module: "Release Validator",
  timestamp: new Date().toISOString(),
  files: {
    engineExists: fs.existsSync(enginePath),
    routeExists: fs.existsSync(routePath),
    routeMountedInIndex: indexText.includes("releaseValidatorRoutes")
  },
  tests: {
    validationGenerated: typeof validation.releaseScore === "number",
    summaryGenerated: !!summary.plainEnglish,
    healthGenerated: !!health.status,
    candidateGenerated: !!candidate.releaseCandidateId,
    candidateHasValidation: !!candidate.validation
  },
  health,
  validation,
  status: (
    fs.existsSync(enginePath) &&
    fs.existsSync(routePath) &&
    indexText.includes("releaseValidatorRoutes") &&
    typeof validation.releaseScore === "number" &&
    !!summary.plainEnglish &&
    !!health.status &&
    !!candidate.releaseCandidateId &&
    !!candidate.validation
  ) ? "PASS" : "FAIL"
};

fs.writeFileSync(path.join(reports, "phase10X3-release-validator-report.json"), JSON.stringify(report, null, 2));

console.log([
  "LITIGATION 360 - PHASE 10X.3 RELEASE VALIDATOR REPORT",
  "====================================================",
  "",
  "Timestamp: " + report.timestamp,
  "Status: " + report.status,
  "Engine Exists: " + report.files.engineExists,
  "Route Exists: " + report.files.routeExists,
  "Route Mounted In index.js: " + report.files.routeMountedInIndex,
  "Validation Generated: " + report.tests.validationGenerated,
  "Summary Generated: " + report.tests.summaryGenerated,
  "Health Generated: " + report.tests.healthGenerated,
  "Candidate Generated: " + report.tests.candidateGenerated,
  "Release Status: " + validation.status,
  "Release Ready: " + validation.releaseReady,
  "Release Score: " + validation.releaseScore,
  "Risk: " + validation.risk,
  "Blockers: " + validation.blockerCount,
  "Warnings: " + validation.warningCount
].join("\n"));

if (report.status !== "PASS") process.exit(1);
