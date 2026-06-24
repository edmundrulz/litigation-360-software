param([ValidateSet("DRYRUN","APPLY")][string]$Mode="DRYRUN")

$Root="C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software"
$Src=Join-Path $Root "backend\src"
$Auto=Join-Path $Src "automation"
$Routes=Join-Path $Src "routes"
$Index=Join-Path $Src "index.js"
$Phase=Join-Path $Root "_operations\phase-10P-backup-recovery-disaster-readiness"
$Reports=Join-Path $Phase "reports"
$Backups=Join-Path $Phase "backups"
$Logs=Join-Path $Phase "logs"
$Docs=Join-Path $Phase "docs"
$Validation=Join-Path $Phase "validation"
$Snapshots=Join-Path $Phase "snapshots"
New-Item -ItemType Directory -Force -Path $Reports,$Backups,$Logs,$Docs,$Validation,$Snapshots,$Auto,$Routes | Out-Null
$Log=Join-Path $Logs "phase-10P-backup-recovery-log.txt"

function Log($Text){Add-Content -LiteralPath $Log -Value "[$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')] $Text"}
function Backup($Path){
  if(Test-Path -LiteralPath $Path){
    $name=Split-Path $Path -Leaf
    $dest=Join-Path $Backups ($name+"."+(Get-Date -Format "yyyyMMdd_HHmmss")+".bak")
    Copy-Item -LiteralPath $Path -Destination $dest -Force
    Log "Backup $Path --> $dest"
  }
}

Clear-Host
Write-Host "============================================================"
Write-Host "L360 PHASE 10P BACKUP RECOVERY DISASTER READINESS"
Write-Host "============================================================"
Write-Host "Mode: $Mode"
Write-Host ""

if(!(Test-Path -LiteralPath $Index)){Write-Host "ERROR: index.js not found";Read-Host "Press Enter";exit 1}
if(!(Test-Path -LiteralPath (Join-Path $Auto "enterpriseHardeningEngine.js"))){Write-Host "ERROR: enterpriseHardeningEngine.js missing";Read-Host "Press Enter";exit 1}

$Engine=Join-Path $Auto "backupRecoveryEngine.js"
$Route=Join-Path $Routes "backupRecoveryRoutes.js"

if($Mode -eq "APPLY"){
  Backup $Engine
  Backup $Route
  Backup $Index

@'
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
'@ | Out-File -LiteralPath $Engine -Encoding UTF8

@'
const express = require("express");
const router = express.Router();

const {
  createSnapshotManifest,
  generateRestorePlan,
  runBackupIntegrityCheck,
  runDisasterReadinessCheck,
  getBackupRecoveryDashboard,
  getBackupRecoveryHealth,
  getBackupRecoveryMetrics
} = require("../automation/backupRecoveryEngine");

router.get("/health", (req, res) => res.json(getBackupRecoveryHealth()));
router.get("/metrics", (req, res) => res.json(getBackupRecoveryMetrics()));
router.get("/dashboard", (req, res) => res.json(getBackupRecoveryDashboard()));
router.get("/integrity", (req, res) => res.json(runBackupIntegrityCheck()));
router.get("/disaster-readiness", (req, res) => res.json(runDisasterReadinessCheck()));
router.get("/restore-plan", (req, res) => res.json(generateRestorePlan()));
router.post("/snapshot", (req, res) => {
  try {
    res.status(201).json({ ok: true, snapshot: createSnapshotManifest(req.body?.label || "api") });
  } catch (err) {
    res.status(500).json({ ok: false, error: err.message });
  }
});
router.get("/test/snapshot", (req, res) => {
  try {
    res.json({ ok: true, snapshot: createSnapshotManifest("phase-10P-test") });
  } catch (err) {
    res.status(500).json({ ok: false, error: err.message });
  }
});

module.exports = router;
'@ | Out-File -LiteralPath $Route -Encoding UTF8

  $txt=Get-Content -LiteralPath $Index -Raw
  $mount='app.use("/api/enterprise/backup-recovery", require("./routes/backupRecoveryRoutes"));'
  if($txt -notlike '*backupRecoveryRoutes*'){
    if($txt -like '*enterpriseHardeningRoutes*'){
      $txt=$txt -replace 'app\.use\("/api/enterprise/hardening",\s*require\("\./routes/enterpriseHardeningRoutes"\)\);', ('$0'+"`r`n"+$mount)
    } else {
      $txt=$txt+"`r`n// Phase 10P Backup Recovery Route`r`n"+$mount+"`r`n"
    }
    Set-Content -LiteralPath $Index -Value $txt -Encoding UTF8
  }
}

$Validate=Join-Path $Validation "validate-phase10P-backup-recovery.js"
@'
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
'@ | Out-File -LiteralPath $Validate -Encoding UTF8

@"
# LITIGATION 360 - PHASE 10P BACKUP, RECOVERY & DISASTER READINESS

## Purpose
Create backup integrity checks, snapshot manifests, restore plan, and disaster readiness endpoint.

## Created Files
- backend\src\automation\backupRecoveryEngine.js
- backend\src\routes\backupRecoveryRoutes.js
- backend\src\index.js route mount

## API Endpoints
- GET /api/enterprise/backup-recovery/health
- GET /api/enterprise/backup-recovery/metrics
- GET /api/enterprise/backup-recovery/dashboard
- GET /api/enterprise/backup-recovery/integrity
- GET /api/enterprise/backup-recovery/disaster-readiness
- GET /api/enterprise/backup-recovery/restore-plan
- POST /api/enterprise/backup-recovery/snapshot
- GET /api/enterprise/backup-recovery/test/snapshot
"@ | Out-File -LiteralPath (Join-Path $Docs "PHASE10P-BACKUP-RECOVERY-PROTOCOL.md") -Encoding UTF8

Write-Host ""
Write-Host "Running validation..."
node $Validate
$exit=$LASTEXITCODE

Write-Host ""
Write-Host "Reports:"
Write-Host $Reports
Write-Host ""
Write-Host "Backups:"
Write-Host $Backups
Write-Host ""
Write-Host "Snapshots:"
Write-Host $Snapshots
Write-Host ""

if($exit -eq 0){Write-Host "PHASE 10P BACKUP RECOVERY STATUS: PASS" -ForegroundColor Green}else{Write-Host "PHASE 10P BACKUP RECOVERY STATUS: FAIL" -ForegroundColor Yellow}
Read-Host "Press Enter to close"
exit $exit
