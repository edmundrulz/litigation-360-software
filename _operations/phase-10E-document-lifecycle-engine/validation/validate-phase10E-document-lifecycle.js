const fs = require("fs");
const path = require("path");

const projectRoot = path.resolve(__dirname, "..", "..", "..");
const srcRoot = path.join(projectRoot, "backend", "src");
const reportsDir = path.join(projectRoot, "_operations", "phase-10E-document-lifecycle-engine", "reports");
fs.mkdirSync(reportsDir, { recursive: true });

const lifecyclePath = path.join(srcRoot, "automation", "documentLifecycleEngine.js");
const lifecycleRoutesPath = path.join(srcRoot, "routes", "documentLifecycleRoutes.js");
const indexPath = path.join(srcRoot, "index.js");

if (!fs.existsSync(lifecyclePath)) {
  console.log("Document Lifecycle Engine file missing. Run APPLY mode.");
  process.exit(1);
}

const engine = require(lifecyclePath);

async function run() {
  engine.resetDocumentLifecycleForTestOnly();

  const document = engine.createDocumentRecord({
    fileName: "phase-10E-validation-document.pdf",
    documentType: "PLEADING",
    uploadedBy: "phase10EValidation"
  });

  const classify = engine.classifyDocument(document.id, "PLEADING", "VALIDATION");
  const assign = engine.assignDocumentToMatter(document.id, "MATTER-VALIDATION-10E", "VALIDATION");
  const review = await engine.startDocumentReview(document.id, "VALIDATION");
  const metrics = engine.getDocumentLifecycleMetrics();
  const health = engine.getDocumentLifecycleHealth();
  const indexText = fs.readFileSync(indexPath, "utf8");

  const report = {
    phase: "10E",
    module: "Document Lifecycle Engine",
    timestamp: new Date().toISOString(),
    files: {
      documentLifecycleEngineExists: fs.existsSync(lifecyclePath),
      documentLifecycleRoutesExists: fs.existsSync(lifecycleRoutesPath),
      routeMountedInIndex: indexText.includes("documentLifecycleRoutes")
    },
    tests: {
      documentCreated: !!document.id,
      classified: classify.ok === true,
      assigned: assign.ok === true,
      reviewStarted: review.ok === true,
      finalState: engine.getDocumentById(document.id).state
    },
    metrics,
    health,
    status: (
      fs.existsSync(lifecyclePath) &&
      fs.existsSync(lifecycleRoutesPath) &&
      indexText.includes("documentLifecycleRoutes") &&
      !!document.id &&
      classify.ok === true &&
      assign.ok === true &&
      review.ok === true &&
      engine.getDocumentById(document.id).state === "REVIEW" &&
      metrics.created === 1 &&
      metrics.classified === 1 &&
      metrics.assigned === 1 &&
      metrics.review === 1 &&
      metrics.orphaned === 0
    ) ? "PASS" : "FAIL"
  };

  fs.writeFileSync(path.join(reportsDir, "phase10E-document-lifecycle-report.json"), JSON.stringify(report, null, 2));

  const lines = [
    "LITIGATION 360 - PHASE 10E DOCUMENT LIFECYCLE ENGINE REPORT",
    "===========================================================",
    "",
    "Timestamp: " + report.timestamp,
    "Status: " + report.status,
    "Document Lifecycle Engine Exists: " + report.files.documentLifecycleEngineExists,
    "Document Lifecycle Routes Exists: " + report.files.documentLifecycleRoutesExists,
    "Route Mounted In index.js: " + report.files.routeMountedInIndex,
    "Document Created: " + report.tests.documentCreated,
    "Classified: " + report.tests.classified,
    "Assigned To Matter: " + report.tests.assigned,
    "Review Started: " + report.tests.reviewStarted,
    "Final State: " + report.tests.finalState,
    "Metrics Created: " + metrics.created,
    "Metrics Classified: " + metrics.classified,
    "Metrics Assigned: " + metrics.assigned,
    "Metrics Review: " + metrics.review,
    "Metrics Orphaned: " + metrics.orphaned,
    "Invalid Transitions: " + metrics.invalidTransitions,
    "Health Status: " + health.status
  ];

  fs.writeFileSync(path.join(reportsDir, "phase10E-document-lifecycle-report.txt"), lines.join("\n"));
  console.log(lines.join("\n"));

  if (report.status !== "PASS") process.exit(1);
}

run().catch(err => {
  console.error(err);
  process.exit(1);
});
