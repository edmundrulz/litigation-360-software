const fs = require("fs");
const path = require("path");

const projectRoot = path.resolve(__dirname, "..", "..", "..");
const srcRoot = path.join(projectRoot, "backend", "src");
const reportsDir = path.join(projectRoot, "_operations", "phase-10G-matter-intelligence-engine", "reports");
fs.mkdirSync(reportsDir, { recursive: true });

const intelligencePath = path.join(srcRoot, "automation", "matterIntelligenceEngine.js");
const intelligenceRoutesPath = path.join(srcRoot, "routes", "matterIntelligenceRoutes.js");
const indexPath = path.join(srcRoot, "index.js");

if (!fs.existsSync(intelligencePath)) {
  console.log("Matter Intelligence Engine file missing. Run APPLY mode.");
  process.exit(1);
}

const engine = require(intelligencePath);

function run() {
  engine.resetMatterIntelligenceForTestOnly();

  const matterId = "MATTER-VALIDATION-10G";

  const profile = engine.createOrUpdateMatterProfile({
    matterId,
    matterTitle: "Phase 10G Validation Matter",
    matterType: "CIVIL_LITIGATION",
    assignedLawyer: "VALIDATION",
    clientName: "Validation Client",
    courtName: "Validation Court"
  });

  const intelligence = engine.getMatterIntelligence(matterId);
  const healthScore = engine.calculateMatterHealthScore(matterId);
  const riskFlags = engine.calculateMatterRiskFlags(matterId);
  const timeline = engine.buildMatterTimeline(matterId);
  const metrics = engine.getMatterIntelligenceMetrics();
  const health = engine.getMatterIntelligenceHealth();
  const indexText = fs.readFileSync(indexPath, "utf8");

  const report = {
    phase: "10G",
    module: "Matter Intelligence Engine",
    timestamp: new Date().toISOString(),
    files: {
      matterIntelligenceEngineExists: fs.existsSync(intelligencePath),
      matterIntelligenceRoutesExists: fs.existsSync(intelligenceRoutesPath),
      routeMountedInIndex: indexText.includes("matterIntelligenceRoutes")
    },
    tests: {
      profileCreated: !!profile.matterId,
      intelligenceGenerated: !!intelligence.matterProfile,
      healthScoreGenerated: typeof healthScore.score === "number",
      riskFlagsGenerated: Array.isArray(riskFlags),
      timelineGenerated: Array.isArray(timeline)
    },
    metrics,
    health,
    status: (
      fs.existsSync(intelligencePath) &&
      fs.existsSync(intelligenceRoutesPath) &&
      indexText.includes("matterIntelligenceRoutes") &&
      !!profile.matterId &&
      !!intelligence.matterProfile &&
      typeof healthScore.score === "number" &&
      Array.isArray(riskFlags) &&
      Array.isArray(timeline) &&
      metrics.profilesCreated === 1 &&
      metrics.assessmentsGenerated >= 1
    ) ? "PASS" : "FAIL"
  };

  fs.writeFileSync(path.join(reportsDir, "phase10G-matter-intelligence-report.json"), JSON.stringify(report, null, 2));

  const lines = [
    "LITIGATION 360 - PHASE 10G MATTER INTELLIGENCE ENGINE REPORT",
    "===========================================================",
    "",
    "Timestamp: " + report.timestamp,
    "Status: " + report.status,
    "Matter Intelligence Engine Exists: " + report.files.matterIntelligenceEngineExists,
    "Matter Intelligence Routes Exists: " + report.files.matterIntelligenceRoutesExists,
    "Route Mounted In index.js: " + report.files.routeMountedInIndex,
    "Profile Created: " + report.tests.profileCreated,
    "Intelligence Generated: " + report.tests.intelligenceGenerated,
    "Health Score Generated: " + report.tests.healthScoreGenerated,
    "Risk Flags Generated: " + report.tests.riskFlagsGenerated,
    "Timeline Generated: " + report.tests.timelineGenerated,
    "Health Score: " + healthScore.score,
    "Health Status: " + healthScore.status,
    "Risk Flags Count: " + riskFlags.length,
    "Timeline Items: " + timeline.length,
    "Assessments Generated: " + metrics.assessmentsGenerated,
    "Engine Health Status: " + health.status
  ];

  fs.writeFileSync(path.join(reportsDir, "phase10G-matter-intelligence-report.txt"), lines.join("\n"));
  console.log(lines.join("\n"));

  if (report.status !== "PASS") process.exit(1);
}

run();
