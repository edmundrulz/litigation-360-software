const fs = require("fs");
const path = require("path");
const crypto = require("crypto");
const { getDeploymentReadiness } = require("./enterpriseHardeningEngine");

const PROJECT_ROOT = path.resolve(__dirname, "..", "..", "..");
const BACKEND_ROOT = path.join(PROJECT_ROOT, "backend");
const OPS_ROOT = path.join(PROJECT_ROOT, "_operations", "phase-10P-backup-recovery-disaster-readiness");
const SNAPSHOT_ROOT = path.join(OPS_ROOT, "runtime-snapshots");

const metrics = {
  snapshotsCreated: 0,
  restorePlansGenerated: 0,
  disasterChecksRun: 0,
  integrityChecksRun: 0,
  lastSnapshotAt: null,
  lastCheckAt: null
};

function ensureDir(dir) {
  fs.mkdirSync(dir, { recursive: true });
}

function hashFile(filePath) {
  if (!fs.existsSync(filePath)) return null;
  const data = fs.readFileSync(filePath);
  return crypto.createHash("sha256").update(data).digest("hex");
}

function safeStat(filePath) {
  if (!fs.existsSync(filePath)) return null;
  const stat = fs.statSync(filePath);
  return {
    size: stat.size,
    modifiedAt: stat.mtime.toISOString(),
    hash: hashFile(filePath)
  };
}

function createSnapshotManifest(label = "manual") {
  ensureDir(SNAPSHOT_ROOT);

  const timestamp = new Date().toISOString().replace(/[:.]/g, "-");
  const snapshotId = `SNP-${timestamp}`;
  const snapshotDir = path.join(SNAPSHOT_ROOT, snapshotId);
  ensureDir(snapshotDir);

  const trackedFiles = [
    path.join(BACKEND_ROOT, "litigation360.db"),
    path.join(BACKEND_ROOT, "package.json"),
    path.join(BACKEND_ROOT, "package-lock.json"),
    path.join(BACKEND_ROOT, ".env"),
    path.join(PROJECT_ROOT, "START-L360-CLEAN.bat"),
    path.join(PROJECT_ROOT, "STOP-L360.bat")
  ];

  const manifest = {
    snapshotId,
    label,
    createdAt: new Date().toISOString(),
    projectRoot: PROJECT_ROOT,
    backendRoot: BACKEND_ROOT,
    files: [],
    copiedFiles: [],
    notes: [
      "This snapshot manifest records important files and copies critical small files.",
      "node_modules is intentionally not copied.",
      "Large backups should be handled by external drive/cloud backup policy."
    ]
  };

  for (const file of trackedFiles) {
    const info = safeStat(file);
    manifest.files.push({
      path: file,
      exists: !!info,
      ...info
    });

    if (info && info.size < 50 * 1024 * 1024) {
      const dest = path.join(snapshotDir, path.basename(file));
      fs.copyFileSync(file, dest);
      manifest.copiedFiles.push({ source: file, destination: dest });
    }
  }

  fs.writeFileSync(path.join(snapshotDir, "snapshot-manifest.json"), JSON.stringify(manifest, null, 2));
  metrics.snapshotsCreated += 1;
  metrics.lastSnapshotAt = manifest.createdAt;

  return manifest;
}

function generateRestorePlan() {
  metrics.restorePlansGenerated += 1;

  return {
    module: "Backup Recovery Engine",
    restorePlan: [
      {
        step: 1,
        action: "Stop backend and frontend",
        command: 'STOP-L360.bat'
      },
      {
        step: 2,
        action: "Confirm no node.exe backend process is still running",
        command: 'tasklist | findstr node'
      },
      {
        step: 3,
        action: "Copy selected snapshot files back into project root/backend locations",
        command: "Manual copy from _operations\\phase-10P-backup-recovery-disaster-readiness\\runtime-snapshots"
      },
      {
        step: 4,
        action: "Run npm install only if package files changed",
        command: "cd backend && npm install"
      },
      {
        step: 5,
        action: "Restart clean launcher",
        command: "START-L360-CLEAN.bat"
      },
      {
        step: 6,
        action: "Run deployment readiness check",
        command: "http://localhost:5000/api/enterprise/hardening/deployment/readiness"
      }
    ],
    generatedAt: new Date().toISOString()
  };
}

function runBackupIntegrityCheck() {
  metrics.integrityChecksRun += 1;
  metrics.lastCheckAt = new Date().toISOString();

  const databasePath = path.join(BACKEND_ROOT, "litigation360.db");
  const packagePath = path.join(BACKEND_ROOT, "package.json");
  const indexPath = path.join(BACKEND_ROOT, "src", "index.js");
  const operationsPath = path.join(PROJECT_ROOT, "_operations");

  const checks = [
    {
      name: "Database exists and non-zero",
      pass: fs.existsSync(databasePath) && fs.statSync(databasePath).size > 0,
      path: databasePath,
      stat: safeStat(databasePath)
    },
    {
      name: "package.json exists",
      pass: fs.existsSync(packagePath),
      path: packagePath,
      stat: safeStat(packagePath)
    },
    {
      name: "backend src index.js exists",
      pass: fs.existsSync(indexPath),
      path: indexPath,
      stat: safeStat(indexPath)
    },
    {
      name: "_operations folder exists",
      pass: fs.existsSync(operationsPath),
      path: operationsPath
    }
  ];

  return {
    module: "Backup Integrity Check",
    status: checks.every(c => c.pass) ? "PASS" : "FAIL",
    checks,
    timestamp: metrics.lastCheckAt
  };
}

function runDisasterReadinessCheck() {
  metrics.disasterChecksRun += 1;

  const readiness = getDeploymentReadiness();
  const backupIntegrity = runBackupIntegrityCheck();
  const restorePlan = generateRestorePlan();

  const blockingIssues = [];

  if (readiness.status !== "READY") {
    blockingIssues.push("Deployment readiness is not READY.");
  }

  if (backupIntegrity.status !== "PASS") {
    blockingIssues.push("Backup integrity check failed.");
  }

  const status = blockingIssues.length === 0 ? "READY" : "ATTENTION";

  return {
    module: "Disaster Readiness Engine",
    status,
    deploymentReadiness: readiness,
    backupIntegrity,
    restorePlan,
    blockingIssues,
    generatedAt: new Date().toISOString()
  };
}

function getBackupRecoveryDashboard() {
  const integrity = runBackupIntegrityCheck();
  const disaster = runDisasterReadinessCheck();

  return {
    module: "Backup, Recovery & Disaster Readiness",
    status: disaster.status,
    integrityStatus: integrity.status,
    disasterStatus: disaster.status,
    snapshotsCreated: metrics.snapshotsCreated,
    lastSnapshotAt: metrics.lastSnapshotAt,
    lastCheckAt: metrics.lastCheckAt,
    metrics: getBackupRecoveryMetrics(),
    generatedAt: new Date().toISOString()
  };
}

function getBackupRecoveryHealth() {
  const integrity = runBackupIntegrityCheck();

  return {
    module: "Backup Recovery Engine",
    status: integrity.status === "PASS" ? "HEALTHY" : "ATTENTION",
    snapshotsCreated: metrics.snapshotsCreated,
    restorePlansGenerated: metrics.restorePlansGenerated,
    disasterChecksRun: metrics.disasterChecksRun,
    integrityChecksRun: metrics.integrityChecksRun,
    lastSnapshotAt: metrics.lastSnapshotAt,
    lastCheckAt: metrics.lastCheckAt,
    timestamp: new Date().toISOString()
  };
}

function getBackupRecoveryMetrics() {
  return {
    ...metrics,
    timestamp: new Date().toISOString()
  };
}

module.exports = {
  createSnapshotManifest,
  generateRestorePlan,
  runBackupIntegrityCheck,
  runDisasterReadinessCheck,
  getBackupRecoveryDashboard,
  getBackupRecoveryHealth,
  getBackupRecoveryMetrics
};
