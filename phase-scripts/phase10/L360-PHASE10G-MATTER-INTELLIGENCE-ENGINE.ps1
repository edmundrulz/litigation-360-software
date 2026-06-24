param(
    [ValidateSet("DRYRUN","APPLY")]
    [string]$Mode = "DRYRUN"
)

$ProjectRoot = "C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software"
$Src = Join-Path $ProjectRoot "backend\src"
$Automation = Join-Path $Src "automation"
$Routes = Join-Path $Src "routes"
$IndexPath = Join-Path $Src "index.js"

$PhaseDir = Join-Path $ProjectRoot "_operations\phase-10G-matter-intelligence-engine"
$Reports = Join-Path $PhaseDir "reports"
$Logs = Join-Path $PhaseDir "logs"
$Backups = Join-Path $PhaseDir "backups"
$Docs = Join-Path $PhaseDir "docs"
$Validation = Join-Path $PhaseDir "validation"

New-Item -ItemType Directory -Force -Path $PhaseDir,$Reports,$Logs,$Backups,$Docs,$Validation,$Automation,$Routes | Out-Null
$LogFile = Join-Path $Logs "phase-10G-matter-intelligence-log.txt"

function Log($Text) {
    $stamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    Add-Content -LiteralPath $LogFile -Value "[$stamp] $Text"
}

function Backup-IfExists($Path) {
    if (Test-Path -LiteralPath $Path) {
        $name = Split-Path $Path -Leaf
        $dest = Join-Path $Backups ($name + "." + (Get-Date -Format "yyyyMMdd_HHmmss") + ".bak")
        Copy-Item -LiteralPath $Path -Destination $dest -Force
        Log "Backup created: $Path --> $dest"
    }
}

Clear-Host
Write-Host "============================================================"
Write-Host "LITIGATION 360 - PHASE 10G MATTER INTELLIGENCE ENGINE"
Write-Host "============================================================"
Write-Host "Mode: $Mode"
Write-Host "Project root: $ProjectRoot"
Write-Host ""

Log "============================================================"
Log "PHASE 10G MATTER INTELLIGENCE ENGINE START"
Log "Mode: $Mode"

if (!(Test-Path -LiteralPath $IndexPath)) {
    Write-Host "ERROR: backend\src\index.js not found." -ForegroundColor Red
    Read-Host "Press Enter to close"
    exit 1
}

foreach ($required in @("eventBus.js","notificationService.js","workflowEngine.js","documentLifecycleEngine.js","courtOperationsEngine.js")) {
    if (!(Test-Path -LiteralPath (Join-Path $Automation $required))) {
        Write-Host "ERROR: Required dependency missing: $required" -ForegroundColor Red
        Read-Host "Press Enter to close"
        exit 1
    }
}

$MatterIntelligencePath = Join-Path $Automation "matterIntelligenceEngine.js"
$MatterIntelligenceRoutesPath = Join-Path $Routes "matterIntelligenceRoutes.js"

if ($Mode -eq "APPLY") {
    Backup-IfExists $MatterIntelligencePath
    Backup-IfExists $MatterIntelligenceRoutesPath
    Backup-IfExists $IndexPath

@'
const { createNotification } = require("./notificationService");
const { getDocuments } = require("./documentLifecycleEngine");
const {
  getCourtEvents,
  getCourtTasks,
  getOverdueCourtDeadlines,
  getUpcomingCourtEvents
} = require("./courtOperationsEngine");
const { getWorkflows } = require("./workflowEngine");

const matterProfiles = new Map();

const matterIntelligenceMetrics = {
  profilesCreated: 0,
  profilesUpdated: 0,
  assessmentsGenerated: 0,
  highRiskMatters: 0,
  mediumRiskMatters: 0,
  healthyMatters: 0
};

function createOrUpdateMatterProfile({
  matterId,
  matterTitle = null,
  matterType = "GENERAL_LITIGATION",
  status = "ACTIVE",
  assignedLawyer = null,
  clientName = null,
  courtName = null,
  payload = {}
} = {}) {
  if (!matterId) {
    throw new Error("matterId is required");
  }

  const existing = matterProfiles.get(matterId);

  const profile = {
    matterId,
    matterTitle: matterTitle || existing?.matterTitle || matterId,
    matterType: matterType || existing?.matterType || "GENERAL_LITIGATION",
    status: status || existing?.status || "ACTIVE",
    assignedLawyer: assignedLawyer || existing?.assignedLawyer || null,
    clientName: clientName || existing?.clientName || null,
    courtName: courtName || existing?.courtName || null,
    payload: {
      ...(existing?.payload || {}),
      ...payload
    },
    createdAt: existing?.createdAt || new Date().toISOString(),
    updatedAt: new Date().toISOString(),
    history: [
      ...(existing?.history || []),
      {
        action: existing ? "UPDATED" : "CREATED",
        timestamp: new Date().toISOString(),
        note: existing ? "Matter profile updated" : "Matter profile created"
      }
    ]
  };

  matterProfiles.set(matterId, profile);

  if (existing) {
    matterIntelligenceMetrics.profilesUpdated += 1;
  } else {
    matterIntelligenceMetrics.profilesCreated += 1;
  }

  return profile;
}

function getMatterProfile(matterId) {
  return matterProfiles.get(matterId) || createOrUpdateMatterProfile({ matterId });
}

function buildMatterTimeline(matterId) {
  const profile = getMatterProfile(matterId);
  const documents = getDocuments({ limit: 100, matterId });
  const courtEvents = getCourtEvents({ limit: 100, matterId });
  const workflows = getWorkflows({ limit: 100 });
  const courtTasks = getCourtTasks({ limit: 100, matterId });

  const timeline = [];

  timeline.push({
    type: "MATTER_PROFILE",
    title: "Matter profile available",
    timestamp: profile.createdAt,
    source: "MATTER_INTELLIGENCE"
  });

  for (const doc of documents) {
    timeline.push({
      type: "DOCUMENT",
      title: `Document ${doc.fileName} is ${doc.state}`,
      timestamp: doc.updatedAt || doc.createdAt,
      source: "DOCUMENT_LIFECYCLE",
      refId: doc.id
    });
  }

  for (const courtEvent of courtEvents) {
    timeline.push({
      type: "COURT_EVENT",
      title: `${courtEvent.eventType} at ${courtEvent.courtName}`,
      timestamp: courtEvent.eventDate,
      source: "COURT_OPERATIONS",
      refId: courtEvent.id
    });
  }

  for (const workflow of workflows) {
    if (workflow.payload?.matterId === matterId || workflow.context?.matterId === matterId) {
      timeline.push({
        type: "WORKFLOW",
        title: `${workflow.workflowType} workflow ${workflow.status}`,
        timestamp: workflow.updatedAt || workflow.createdAt,
        source: "WORKFLOW_ENGINE",
        refId: workflow.id
      });
    }
  }

  for (const task of courtTasks) {
    timeline.push({
      type: "COURT_TASK",
      title: `${task.name} - ${task.status}`,
      timestamp: task.createdAt,
      source: "COURT_OPERATIONS",
      refId: task.id
    });
  }

  return timeline
    .filter(item => item.timestamp)
    .sort((a, b) => new Date(a.timestamp) - new Date(b.timestamp));
}

function calculateMatterRiskFlags(matterId) {
  const documents = getDocuments({ limit: 100, matterId });
  const orphanedDocuments = getDocuments({ limit: 100, orphanedOnly: true }).filter(d => d.matterId === matterId);
  const courtEvents = getCourtEvents({ limit: 100, matterId });
  const courtTasks = getCourtTasks({ limit: 100, matterId });
  const overdueDeadlines = getOverdueCourtDeadlines().filter(d => d.matterId === matterId);
  const upcomingCourtEvents = getUpcomingCourtEvents(14).filter(c => c.matterId === matterId);

  const flags = [];

  if (documents.length === 0) {
    flags.push({
      code: "NO_DOCUMENTS",
      severity: "MEDIUM",
      message: "Matter has no linked documents."
    });
  }

  if (orphanedDocuments.length > 0) {
    flags.push({
      code: "ORPHANED_DOCUMENTS",
      severity: "HIGH",
      message: "Matter has orphaned documents requiring linkage or archive."
    });
  }

  if (courtEvents.length === 0) {
    flags.push({
      code: "NO_COURT_EVENTS",
      severity: "LOW",
      message: "Matter has no court events recorded."
    });
  }

  if (upcomingCourtEvents.length > 0) {
    flags.push({
      code: "UPCOMING_COURT_EVENT",
      severity: "MEDIUM",
      message: "Matter has a court event within 14 days."
    });
  }

  if (overdueDeadlines.length > 0) {
    flags.push({
      code: "OVERDUE_COURT_DEADLINES",
      severity: "HIGH",
      message: "Matter has overdue court deadlines."
    });
  }

  const openTasks = courtTasks.filter(t => t.status === "OPEN");
  if (openTasks.length > 0) {
    flags.push({
      code: "OPEN_COURT_TASKS",
      severity: "MEDIUM",
      message: `Matter has ${openTasks.length} open court tasks.`
    });
  }

  const reviewDocs = documents.filter(d => d.state === "REVIEW");
  if (reviewDocs.length > 0) {
    flags.push({
      code: "DOCUMENTS_UNDER_REVIEW",
      severity: "LOW",
      message: `Matter has ${reviewDocs.length} documents under review.`
    });
  }

  return flags;
}

function calculateMatterHealthScore(matterId) {
  const flags = calculateMatterRiskFlags(matterId);

  let score = 100;

  for (const flag of flags) {
    if (flag.severity === "HIGH") score -= 30;
    if (flag.severity === "MEDIUM") score -= 15;
    if (flag.severity === "LOW") score -= 5;
  }

  score = Math.max(0, score);

  let status = "HEALTHY";
  if (score < 80) status = "ATTENTION";
  if (score < 50) status = "HIGH_RISK";

  return {
    score,
    status,
    flagsCount: flags.length,
    highRiskFlags: flags.filter(f => f.severity === "HIGH").length,
    mediumRiskFlags: flags.filter(f => f.severity === "MEDIUM").length,
    lowRiskFlags: flags.filter(f => f.severity === "LOW").length
  };
}

function getMatterIntelligence(matterId) {
  const profile = getMatterProfile(matterId);
  const documents = getDocuments({ limit: 100, matterId });
  const courtEvents = getCourtEvents({ limit: 100, matterId });
  const courtTasks = getCourtTasks({ limit: 100, matterId });
  const workflows = getWorkflows({ limit: 100 }).filter(w => w.payload?.matterId === matterId || w.context?.matterId === matterId);
  const riskFlags = calculateMatterRiskFlags(matterId);
  const health = calculateMatterHealthScore(matterId);
  const timeline = buildMatterTimeline(matterId);

  matterIntelligenceMetrics.assessmentsGenerated += 1;

  if (health.status === "HIGH_RISK") {
    matterIntelligenceMetrics.highRiskMatters += 1;
    createNotification({
      title: `High Risk Matter: ${matterId}`,
      message: `Matter health score is ${health.score}. Immediate review recommended.`,
      level: "CRITICAL",
      source: "MATTER_INTELLIGENCE",
      eventType: "MATTER_HIGH_RISK",
      matterId,
      payload: {
        health,
        riskFlags
      }
    });
  } else if (health.status === "ATTENTION") {
    matterIntelligenceMetrics.mediumRiskMatters += 1;
  } else {
    matterIntelligenceMetrics.healthyMatters += 1;
  }

  return {
    matterProfile: profile,
    health,
    riskFlags,
    documents,
    courtEvents,
    courtTasks,
    workflows,
    timeline,
    generatedAt: new Date().toISOString()
  };
}

function getMatterIntelligenceSummary() {
  const profiles = Array.from(matterProfiles.values());

  return {
    totalProfiles: profiles.length,
    profiles,
    metrics: getMatterIntelligenceMetrics(),
    timestamp: new Date().toISOString()
  };
}

function getMatterIntelligenceMetrics() {
  return {
    ...matterIntelligenceMetrics,
    storedProfiles: matterProfiles.size,
    status: matterIntelligenceMetrics.highRiskMatters > 0 ? "ATTENTION" : "HEALTHY",
    timestamp: new Date().toISOString()
  };
}

function getMatterIntelligenceHealth() {
  const metrics = getMatterIntelligenceMetrics();

  return {
    module: "Matter Intelligence Engine",
    status: metrics.status,
    profilesCreated: metrics.profilesCreated,
    profilesUpdated: metrics.profilesUpdated,
    assessmentsGenerated: metrics.assessmentsGenerated,
    highRiskMatters: metrics.highRiskMatters,
    mediumRiskMatters: metrics.mediumRiskMatters,
    healthyMatters: metrics.healthyMatters,
    storedProfiles: metrics.storedProfiles,
    timestamp: metrics.timestamp
  };
}

function resetMatterIntelligenceForTestOnly() {
  matterProfiles.clear();
  matterIntelligenceMetrics.profilesCreated = 0;
  matterIntelligenceMetrics.profilesUpdated = 0;
  matterIntelligenceMetrics.assessmentsGenerated = 0;
  matterIntelligenceMetrics.highRiskMatters = 0;
  matterIntelligenceMetrics.mediumRiskMatters = 0;
  matterIntelligenceMetrics.healthyMatters = 0;
}

module.exports = {
  createOrUpdateMatterProfile,
  getMatterProfile,
  getMatterIntelligence,
  getMatterIntelligenceSummary,
  calculateMatterRiskFlags,
  calculateMatterHealthScore,
  buildMatterTimeline,
  getMatterIntelligenceMetrics,
  getMatterIntelligenceHealth,
  resetMatterIntelligenceForTestOnly
};
'@ | Out-File -LiteralPath $MatterIntelligencePath -Encoding UTF8

@'
const express = require("express");
const router = express.Router();

const {
  createOrUpdateMatterProfile,
  getMatterProfile,
  getMatterIntelligence,
  getMatterIntelligenceSummary,
  calculateMatterRiskFlags,
  calculateMatterHealthScore,
  buildMatterTimeline,
  getMatterIntelligenceMetrics,
  getMatterIntelligenceHealth
} = require("../automation/matterIntelligenceEngine");

router.get("/health", (req, res) => {
  res.json(getMatterIntelligenceHealth());
});

router.get("/metrics", (req, res) => {
  res.json(getMatterIntelligenceMetrics());
});

router.get("/summary", (req, res) => {
  res.json(getMatterIntelligenceSummary());
});

router.post("/profile", (req, res) => {
  try {
    const profile = createOrUpdateMatterProfile(req.body || {});
    res.status(201).json({
      ok: true,
      profile
    });
  } catch (err) {
    res.status(400).json({
      ok: false,
      error: err.message
    });
  }
});

router.get("/:matterId/profile", (req, res) => {
  res.json({
    ok: true,
    profile: getMatterProfile(req.params.matterId)
  });
});

router.get("/:matterId", (req, res) => {
  res.json({
    ok: true,
    intelligence: getMatterIntelligence(req.params.matterId)
  });
});

router.get("/:matterId/health-score", (req, res) => {
  res.json({
    ok: true,
    matterId: req.params.matterId,
    health: calculateMatterHealthScore(req.params.matterId),
    timestamp: new Date().toISOString()
  });
});

router.get("/:matterId/risk-flags", (req, res) => {
  res.json({
    ok: true,
    matterId: req.params.matterId,
    riskFlags: calculateMatterRiskFlags(req.params.matterId),
    timestamp: new Date().toISOString()
  });
});

router.get("/:matterId/timeline", (req, res) => {
  res.json({
    ok: true,
    matterId: req.params.matterId,
    timeline: buildMatterTimeline(req.params.matterId),
    timestamp: new Date().toISOString()
  });
});

router.get("/test/matter-brain", (req, res) => {
  const matterId = "MATTER-PHASE-10G-TEST";

  createOrUpdateMatterProfile({
    matterId,
    matterTitle: "Phase 10G Test Matter",
    matterType: "CIVIL_LITIGATION",
    status: "ACTIVE",
    assignedLawyer: "PHASE_10G_TEST",
    clientName: "Phase 10G Test Client",
    courtName: "Shah Alam High Court"
  });

  res.json({
    ok: true,
    intelligence: getMatterIntelligence(matterId)
  });
});

module.exports = router;
'@ | Out-File -LiteralPath $MatterIntelligenceRoutesPath -Encoding UTF8

    $indexText = Get-Content -LiteralPath $IndexPath -Raw
    $mountLine = 'app.use("/api/enterprise/matters/intelligence", require("./routes/matterIntelligenceRoutes"));'

    if ($indexText -notlike '*matterIntelligenceRoutes*') {
        if ($indexText -like '*courtOperationsRoutes*') {
            $indexText = $indexText -replace 'app\.use\("/api/enterprise/court-operations",\s*require\("\./routes/courtOperationsRoutes"\)\);', ('$0' + "`r`n" + $mountLine)
        } else {
            $indexText = $indexText + "`r`n" + "// Phase 10G Matter Intelligence Engine Route`r`n" + $mountLine + "`r`n"
        }

        Set-Content -LiteralPath $IndexPath -Value $indexText -Encoding UTF8
        Log "Mounted Matter Intelligence route in index.js"
    } else {
        Log "matterIntelligenceRoutes already mounted in index.js"
    }
}

$ValidationJs = Join-Path $Validation "validate-phase10G-matter-intelligence.js"

@'
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
'@ | Out-File -LiteralPath $ValidationJs -Encoding UTF8

@"
# LITIGATION 360 - PHASE 10G MATTER INTELLIGENCE ENGINE PROTOCOL

## Purpose
Create a Matter Intelligence layer that gives every matter a health score, risk flags, timeline, matter profile, and operational intelligence summary.

## Why
Previous phases created operational systems. Phase 10G gives the system matter-level understanding.

## Created Files
- backend\src\automation\matterIntelligenceEngine.js
- backend\src\routes\matterIntelligenceRoutes.js
- backend\src\index.js route mount

## API Endpoints
- GET /api/enterprise/matters/intelligence/health
- GET /api/enterprise/matters/intelligence/metrics
- GET /api/enterprise/matters/intelligence/summary
- POST /api/enterprise/matters/intelligence/profile
- GET /api/enterprise/matters/intelligence/:matterId
- GET /api/enterprise/matters/intelligence/:matterId/profile
- GET /api/enterprise/matters/intelligence/:matterId/health-score
- GET /api/enterprise/matters/intelligence/:matterId/risk-flags
- GET /api/enterprise/matters/intelligence/:matterId/timeline
- GET /api/enterprise/matters/intelligence/test/matter-brain

## Runtime Tests
After backend restart:
- http://localhost:5000/api/enterprise/matters/intelligence/health
- http://localhost:5000/api/enterprise/matters/intelligence/test/matter-brain
- http://localhost:5000/api/enterprise/matters/intelligence/MATTER-PHASE-10G-TEST

## Rules
- No deletion.
- Backup before modification.
- Every matter must have a profile.
- Every matter intelligence response must include health, riskFlags, documents, courtEvents, courtTasks, workflows, and timeline.
- High-risk matters must create critical notifications.
"@ | Out-File -LiteralPath (Join-Path $Docs "PHASE10G-MATTER-INTELLIGENCE-PROTOCOL.md") -Encoding UTF8

Write-Host ""
Write-Host "Running validation..."
node $ValidationJs
$exit = $LASTEXITCODE

Write-Host ""
Write-Host "Reports:"
Write-Host $Reports
Write-Host ""
Write-Host "Backups:"
Write-Host $Backups
Write-Host ""

if ($exit -eq 0) {
    Write-Host "PHASE 10G MATTER INTELLIGENCE ENGINE STATUS: PASS" -ForegroundColor Green
    Log "PHASE 10G MATTER INTELLIGENCE ENGINE PASS"
} else {
    Write-Host "PHASE 10G MATTER INTELLIGENCE ENGINE STATUS: FAIL - CHECK REPORT" -ForegroundColor Yellow
    Log "PHASE 10G MATTER INTELLIGENCE ENGINE FAIL"
}

Read-Host "Press Enter to close"
exit $exit
