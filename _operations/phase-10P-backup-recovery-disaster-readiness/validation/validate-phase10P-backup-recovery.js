const fs = require("fs");
const path = require("path");

const root = path.resolve(__dirname, "..", "..", "..");
const src = path.join(root, "backend", "src");
const reports = path.join(root, "_operations", "phase-10P-backup-recovery-disaster-readiness", "reports");
fs.mkdirSync(reports, { recursive: true });

const enginePath = path.join(src, "automation", "backupRecoveryEngine.js");
const routePath = path.join(src, "routes", "backupRecoveryRoutes.js");
const indexPath = path.join(src, "index.js");

if (!fs.existsSync(enginePath)) {
  console.log("Backup Recovery Engine missing. Run APPLY mode.");
  process.exit(1);
}

const engine = require(enginePath);

const integrity = engine.runBackupIntegrityCheck();
const restorePlan = engine.generateRestorePlan();
const snapshot = engine.createSnapshotManifest("phase-10P-validation");
const disaster = engine.runDisasterReadinessCheck();
const health = engine.getBackupRecoveryHealth();
const indexText = fs.readFileSync(indexPath, "utf8");

const report = {
  phase: "10P",
  module: "Backup Recovery Disaster Readiness",
  timestamp: new Date().toISOString(),
  files: {
    engineExists: fs.existsSync(enginePath),
    routeExists: fs.existsSync(routePath),
    routeMountedInIndex: indexText.includes("backupRecoveryRoutes")
  },
  tests: {
    integrityPassed: integrity.status === "PASS",
    restorePlanGenerated: restorePlan.restorePlan.length >= 6,
    snapshotCreated: !!snapshot.snapshotId,
    disasterCheckGenerated: !!disaster.status,
    healthGenerated: !!health.status
  },
  health,
  disaster,
  status: (
    fs.existsSync(enginePath) &&
    fs.existsSync(routePath) &&
    indexText.includes("backupRecoveryRoutes") &&
    integrity.status === "PASS" &&
    restorePlan.restorePlan.length >= 6 &&
    !!snapshot.snapshotId &&
    !!disaster.status &&
    !!health.status
  ) ? "PASS" : "FAIL"
};

fs.writeFileSync(path.join(reports, "phase10P-backup-recovery-report.json"), JSON.stringify(report, null, 2));

const lines = [
  "LITIGATION 360 - PHASE 10P BACKUP RECOVERY DISASTER READINESS REPORT",
  "===================================================================",
  "",
  "Timestamp: " + report.timestamp,
  "Status: " + report.status,
  "Engine Exists: " + report.files.engineExists,
  "Route Exists: " + report.files.routeExists,
  "Route Mounted In index.js: " + report.files.routeMountedInIndex,
  "Integrity Passed: " + report.tests.integrityPassed,
  "Restore Plan Generated: " + report.tests.restorePlanGenerated,
  "Snapshot Created: " + report.tests.snapshotCreated,
  "Disaster Check Generated: " + report.tests.disasterCheckGenerated,
  "Health Status: " + health.status
];

fs.writeFileSync(path.join(reports, "phase10P-backup-recovery-report.txt"), lines.join("\n"));
console.log(lines.join("\n"));

if (report.status !== "PASS") process.exit(1);
