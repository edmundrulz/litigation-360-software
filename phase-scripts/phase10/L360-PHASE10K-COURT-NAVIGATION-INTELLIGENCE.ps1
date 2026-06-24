param([ValidateSet("DRYRUN","APPLY")][string]$Mode="DRYRUN")

$ProjectRoot="C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software"
$Src=Join-Path $ProjectRoot "backend\src"
$Automation=Join-Path $Src "automation"
$Routes=Join-Path $Src "routes"
$IndexPath=Join-Path $Src "index.js"
$PhaseDir=Join-Path $ProjectRoot "_operations\phase-10K-court-navigation-intelligence"
$Reports=Join-Path $PhaseDir "reports"
$Logs=Join-Path $PhaseDir "logs"
$Backups=Join-Path $PhaseDir "backups"
$Docs=Join-Path $PhaseDir "docs"
$Validation=Join-Path $PhaseDir "validation"
New-Item -ItemType Directory -Force -Path $PhaseDir,$Reports,$Logs,$Backups,$Docs,$Validation,$Automation,$Routes | Out-Null
$LogFile=Join-Path $Logs "phase-10K-court-navigation-log.txt"

function Log($Text){Add-Content -LiteralPath $LogFile -Value "[$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')] $Text"}
function Backup-IfExists($Path){if(Test-Path -LiteralPath $Path){$n=Split-Path $Path -Leaf;$d=Join-Path $Backups ($n+"."+(Get-Date -Format "yyyyMMdd_HHmmss")+".bak");Copy-Item -LiteralPath $Path -Destination $d -Force;Log "Backup: $Path --> $d"}}

Clear-Host
Write-Host "============================================================"
Write-Host "LITIGATION 360 - PHASE 10K COURT NAVIGATION INTELLIGENCE"
Write-Host "============================================================"
Write-Host "Mode: $Mode"
Write-Host "Project root: $ProjectRoot"
Write-Host ""
Log "PHASE 10K START Mode=$Mode"

if(!(Test-Path -LiteralPath $IndexPath)){Write-Host "ERROR: backend\src\index.js not found" -ForegroundColor Red;Read-Host "Press Enter";exit 1}

foreach($r in @("courtOperationsEngine.js","documentLifecycleEngine.js","workflowEngine.js","notificationService.js","predictiveAnalyticsEngine.js")){
  if(!(Test-Path -LiteralPath (Join-Path $Automation $r))){
    Write-Host "ERROR: Required dependency missing: $r" -ForegroundColor Red
    Read-Host "Press Enter"
    exit 1
  }
}

$NavigationPath=Join-Path $Automation "courtNavigationEngine.js"
$NavigationRoutesPath=Join-Path $Routes "courtNavigationRoutes.js"

if($Mode -eq "APPLY"){
  Backup-IfExists $NavigationPath
  Backup-IfExists $NavigationRoutesPath
  Backup-IfExists $IndexPath

@'
const { getUpcomingCourtEvents, getCourtEvents } = require("./courtOperationsEngine");
const { getDocuments } = require("./documentLifecycleEngine");
const { getWorkflows } = require("./workflowEngine");
const { createNotification } = require("./notificationService");

const courtRegistry = new Map();

const navigationMetrics = {
  courtsRegistered: 0,
  travelPlansGenerated: 0,
  readinessChecksGenerated: 0,
  dashboardGenerated: 0,
  travelRiskAlerts: 0,
  missingCourtLocations: 0,
  lastGeneratedAt: null
};

function seedDefaultCourts() {
  registerCourt({
    courtName: "Shah Alam High Court",
    address: "Shah Alam, Selangor",
    latitude: 3.0738,
    longitude: 101.5183,
    parkingNotes: "Allow extra time for parking and security screening.",
    entryNotes: "Arrive early for registration and file check.",
    defaultTravelMinutes: 45,
    defaultBufferMinutes: 30
  });

  registerCourt({
    courtName: "Kuala Lumpur High Court",
    address: "Kuala Lumpur Court Complex, Jalan Duta, Kuala Lumpur",
    latitude: 3.1670,
    longitude: 101.6650,
    parkingNotes: "High congestion area. Prefer early arrival.",
    entryNotes: "Security screening queues may be long.",
    defaultTravelMinutes: 60,
    defaultBufferMinutes: 45
  });

  registerCourt({
    courtName: "Petaling Jaya Court",
    address: "Petaling Jaya, Selangor",
    latitude: 3.1073,
    longitude: 101.6067,
    parkingNotes: "Parking may be limited during morning sessions.",
    entryNotes: "Confirm courtroom before arrival.",
    defaultTravelMinutes: 30,
    defaultBufferMinutes: 25
  });
}

function registerCourt({
  courtName,
  address,
  latitude = null,
  longitude = null,
  parkingNotes = null,
  entryNotes = null,
  securityNotes = null,
  defaultTravelMinutes = 45,
  defaultBufferMinutes = 30
} = {}) {
  if (!courtName) throw new Error("courtName is required");

  const existing = courtRegistry.get(courtName);

  const court = {
    courtName,
    address: address || existing?.address || null,
    latitude: latitude ?? existing?.latitude ?? null,
    longitude: longitude ?? existing?.longitude ?? null,
    parkingNotes: parkingNotes || existing?.parkingNotes || null,
    entryNotes: entryNotes || existing?.entryNotes || null,
    securityNotes: securityNotes || existing?.securityNotes || null,
    defaultTravelMinutes: Number(defaultTravelMinutes || existing?.defaultTravelMinutes || 45),
    defaultBufferMinutes: Number(defaultBufferMinutes || existing?.defaultBufferMinutes || 30),
    updatedAt: new Date().toISOString(),
    createdAt: existing?.createdAt || new Date().toISOString()
  };

  courtRegistry.set(courtName, court);

  if (!existing) navigationMetrics.courtsRegistered += 1;
  return court;
}

function getCourt(courtName) {
  return courtRegistry.get(courtName) || null;
}

function listCourts() {
  return Array.from(courtRegistry.values()).sort((a, b) => a.courtName.localeCompare(b.courtName));
}

function parseCourtDateTime(courtEvent) {
  const base = new Date(courtEvent.eventDate);
  if (courtEvent.eventTime && /^\d{2}:\d{2}/.test(courtEvent.eventTime)) {
    const [h, m] = courtEvent.eventTime.split(":").map(Number);
    base.setHours(h, m, 0, 0);
  }
  return base;
}

function formatTime(date) {
  return date.toISOString();
}

function riskFromTravel(courtEvent, travelMinutes, bufferMinutes) {
  const day = parseCourtDateTime(courtEvent).getDay();
  const eventHour = parseCourtDateTime(courtEvent).getHours();

  let pressure = 0;
  if (eventHour >= 8 && eventHour <= 10) pressure += 25;
  if (day === 1 || day === 5) pressure += 15;
  if (travelMinutes >= 60) pressure += 20;
  if (bufferMinutes < 30) pressure += 20;

  if (pressure >= 55) return "HIGH";
  if (pressure >= 30) return "MEDIUM";
  return "LOW";
}

function createTravelPlanForCourtEvent(courtEventId, options = {}) {
  const allCourtEvents = getCourtEvents({ limit: 500 });
  const courtEvent = allCourtEvents.find(c => c.id === courtEventId);

  if (!courtEvent) {
    return { ok: false, error: "Court event not found" };
  }

  let court = getCourt(courtEvent.courtName);
  if (!court) {
    navigationMetrics.missingCourtLocations += 1;
    court = registerCourt({
      courtName: courtEvent.courtName,
      address: courtEvent.courtAddress || "Address not recorded",
      defaultTravelMinutes: options.travelMinutes || 45,
      defaultBufferMinutes: options.bufferMinutes || 30
    });
  }

  const travelMinutes = Number(options.travelMinutes || court.defaultTravelMinutes || 45);
  const bufferMinutes = Number(options.bufferMinutes || court.defaultBufferMinutes || 30);
  const arrivalBufferBeforeCourtMinutes = Number(options.arrivalBufferBeforeCourtMinutes || 30);

  const courtDateTime = parseCourtDateTime(courtEvent);
  const arrivalTarget = new Date(courtDateTime.getTime() - arrivalBufferBeforeCourtMinutes * 60000);
  const recommendedDeparture = new Date(arrivalTarget.getTime() - (travelMinutes + bufferMinutes) * 60000);

  const travelRisk = riskFromTravel(courtEvent, travelMinutes, bufferMinutes);

  if (travelRisk === "HIGH") {
    navigationMetrics.travelRiskAlerts += 1;
    createNotification({
      title: "High Court Travel Risk",
      message: `High travel risk detected for ${courtEvent.courtName}.`,
      level: "WARNING",
      source: "COURT_NAVIGATION",
      eventType: "COURT_TRAVEL_RISK",
      matterId: courtEvent.matterId,
      payload: { courtEventId: courtEvent.id, travelRisk }
    });
  }

  const plan = {
    id: `TRV-${Date.now()}-${Math.random().toString(16).slice(2)}`,
    courtEventId: courtEvent.id,
    matterId: courtEvent.matterId,
    courtName: courtEvent.courtName,
    courtAddress: court.address || courtEvent.courtAddress,
    courtDateTime: formatTime(courtDateTime),
    estimatedTravelMinutes: travelMinutes,
    bufferMinutes,
    arrivalTarget: formatTime(arrivalTarget),
    recommendedDeparture: formatTime(recommendedDeparture),
    travelRisk,
    parkingNotes: court.parkingNotes,
    entryNotes: court.entryNotes,
    securityNotes: court.securityNotes,
    generatedAt: new Date().toISOString()
  };

  navigationMetrics.travelPlansGenerated += 1;
  navigationMetrics.lastGeneratedAt = new Date().toISOString();

  return { ok: true, plan };
}

function checkCourtReadinessForMatter(matterId) {
  const courtEvents = getCourtEvents({ limit: 500, matterId });
  const documents = getDocuments({ limit: 500, matterId });
  const workflows = getWorkflows({ limit: 500 }).filter(w => w.payload?.matterId === matterId || w.context?.matterId === matterId);
  const courtTasks = [];
  const upcomingCourtEvents = getUpcomingCourtEvents(30).filter(c => c.matterId === matterId);

  const documentsReady = documents.length > 0 && documents.some(d => ["APPROVED", "FILED", "REVIEW"].includes(d.state));
  const courtBundleReady = documents.some(d => String(d.documentType || "").toUpperCase().includes("BUNDLE") || ["APPROVED", "FILED"].includes(d.state));
  const preparationWorkflowActive = workflows.some(w => w.workflowType === "COURT_DATE_PREPARATION" && ["ACTIVE", "COMPLETED"].includes(w.status));
  const travelPlanReady = upcomingCourtEvents.length > 0;
  const attendanceConfirmed = courtEvents.some(c => !!c.assignedTo);

  const missing = [];
  if (!documentsReady) missing.push("Documents not ready or not linked.");
  if (!courtBundleReady) missing.push("Court bundle/readiness document not confirmed.");
  if (!preparationWorkflowActive) missing.push("Court preparation workflow not active or completed.");
  if (!travelPlanReady) missing.push("No upcoming court travel plan basis found.");
  if (!attendanceConfirmed) missing.push("Court attendance not assigned.");

  const score = Math.max(0, 100 - missing.length * 20);
  const status = score >= 80 ? "READY" : score >= 50 ? "ATTENTION" : "NOT_READY";

  navigationMetrics.readinessChecksGenerated += 1;
  navigationMetrics.lastGeneratedAt = new Date().toISOString();

  if (status === "NOT_READY") {
    createNotification({
      title: `Court Readiness Not Ready: ${matterId}`,
      message: missing.join(" "),
      level: "WARNING",
      source: "COURT_NAVIGATION",
      eventType: "COURT_READINESS_NOT_READY",
      matterId,
      payload: { score, missing }
    });
  }

  return {
    matterId,
    status,
    score,
    checks: {
      documentsReady,
      courtBundleReady,
      preparationWorkflowActive,
      travelPlanReady,
      attendanceConfirmed
    },
    missing,
    upcomingCourtEvents: upcomingCourtEvents.length,
    generatedAt: new Date().toISOString()
  };
}

function generateNavigationDashboard() {
  const upcoming = getUpcomingCourtEvents(30);
  const travelPlans = [];
  const readiness = [];

  for (const event of upcoming.slice(0, 25)) {
    const plan = createTravelPlanForCourtEvent(event.id);
    if (plan.ok) travelPlans.push(plan.plan);

    if (event.matterId) readiness.push(checkCourtReadinessForMatter(event.matterId));
  }

  navigationMetrics.dashboardGenerated += 1;
  navigationMetrics.lastGeneratedAt = new Date().toISOString();

  const highRiskTravel = travelPlans.filter(p => p.travelRisk === "HIGH").length;
  const notReady = readiness.filter(r => r.status === "NOT_READY").length;

  return {
    module: "Court Navigation Intelligence",
    status: highRiskTravel > 0 || notReady > 0 ? "ATTENTION" : "HEALTHY",
    upcomingCourtEvents: upcoming.length,
    travelPlans,
    readiness,
    highRiskTravel,
    notReady,
    generatedAt: navigationMetrics.lastGeneratedAt
  };
}

function getNavigationHealth() {
  const dashboard = generateNavigationDashboard();
  return {
    module: "Court Navigation Intelligence",
    status: dashboard.status,
    courtsRegistered: courtRegistry.size,
    travelPlansGenerated: navigationMetrics.travelPlansGenerated,
    readinessChecksGenerated: navigationMetrics.readinessChecksGenerated,
    dashboardGenerated: navigationMetrics.dashboardGenerated,
    travelRiskAlerts: navigationMetrics.travelRiskAlerts,
    missingCourtLocations: navigationMetrics.missingCourtLocations,
    lastGeneratedAt: navigationMetrics.lastGeneratedAt,
    timestamp: new Date().toISOString()
  };
}

function getNavigationMetrics() {
  return { ...navigationMetrics, courtsRegistered: courtRegistry.size, timestamp: new Date().toISOString() };
}

function resetNavigationForTestOnly() {
  courtRegistry.clear();
  navigationMetrics.courtsRegistered = 0;
  navigationMetrics.travelPlansGenerated = 0;
  navigationMetrics.readinessChecksGenerated = 0;
  navigationMetrics.dashboardGenerated = 0;
  navigationMetrics.travelRiskAlerts = 0;
  navigationMetrics.missingCourtLocations = 0;
  navigationMetrics.lastGeneratedAt = null;
  seedDefaultCourts();
}

seedDefaultCourts();

module.exports = {
  registerCourt,
  getCourt,
  listCourts,
  createTravelPlanForCourtEvent,
  checkCourtReadinessForMatter,
  generateNavigationDashboard,
  getNavigationHealth,
  getNavigationMetrics,
  resetNavigationForTestOnly
};
'@ | Out-File -LiteralPath $NavigationPath -Encoding UTF8

@'
const express = require("express");
const router = express.Router();

const {
  registerCourt,
  getCourt,
  listCourts,
  createTravelPlanForCourtEvent,
  checkCourtReadinessForMatter,
  generateNavigationDashboard,
  getNavigationHealth,
  getNavigationMetrics
} = require("../automation/courtNavigationEngine");

router.get("/health", (req, res) => res.json(getNavigationHealth()));
router.get("/metrics", (req, res) => res.json(getNavigationMetrics()));
router.get("/dashboard", (req, res) => res.json(generateNavigationDashboard()));
router.get("/courts", (req, res) => res.json({ courts: listCourts(), timestamp: new Date().toISOString() }));
router.post("/courts", (req, res) => {
  try {
    res.status(201).json({ ok: true, court: registerCourt(req.body || {}) });
  } catch (err) {
    res.status(400).json({ ok: false, error: err.message });
  }
});
router.get("/courts/:courtName", (req, res) => {
  const court = getCourt(req.params.courtName);
  res.status(court ? 200 : 404).json(court ? { ok: true, court } : { ok: false, error: "Court not found" });
});
router.get("/travel-plan/:courtEventId", (req, res) => {
  const result = createTravelPlanForCourtEvent(req.params.courtEventId, {
    travelMinutes: req.query.travelMinutes,
    bufferMinutes: req.query.bufferMinutes
  });
  res.status(result.ok ? 200 : 404).json(result);
});
router.get("/readiness/:matterId", (req, res) => res.json({ ok: true, readiness: checkCourtReadinessForMatter(req.params.matterId) }));
router.get("/test/dashboard", (req, res) => res.json({ ok: true, dashboard: generateNavigationDashboard() }));
router.get("/test/readiness", (req, res) => res.json({ ok: true, readiness: checkCourtReadinessForMatter("MATTER-PHASE-10K-TEST") }));

module.exports = router;
'@ | Out-File -LiteralPath $NavigationRoutesPath -Encoding UTF8

  $indexText=Get-Content -LiteralPath $IndexPath -Raw
  $mount='app.use("/api/enterprise/navigation", require("./routes/courtNavigationRoutes"));'
  if($indexText -notlike '*courtNavigationRoutes*'){
    if($indexText -like '*predictiveAnalyticsRoutes*'){
      $indexText=$indexText -replace 'app\.use\("/api/enterprise/predictive",\s*require\("\./routes/predictiveAnalyticsRoutes"\)\);', ('$0'+"`r`n"+$mount)
    } else {
      $indexText=$indexText+"`r`n// Phase 10K Court Navigation Intelligence Route`r`n"+$mount+"`r`n"
    }
    Set-Content -LiteralPath $IndexPath -Value $indexText -Encoding UTF8
    Log "Mounted court navigation route"
  }
}

$ValidationJs=Join-Path $Validation "validate-phase10K-court-navigation.js"
@'
const fs = require("fs");
const path = require("path");

const projectRoot = path.resolve(__dirname, "..", "..", "..");
const srcRoot = path.join(projectRoot, "backend", "src");
const reportsDir = path.join(projectRoot, "_operations", "phase-10K-court-navigation-intelligence", "reports");
fs.mkdirSync(reportsDir, { recursive: true });

const enginePath = path.join(srcRoot, "automation", "courtNavigationEngine.js");
const routePath = path.join(srcRoot, "routes", "courtNavigationRoutes.js");
const indexPath = path.join(srcRoot, "index.js");

if (!fs.existsSync(enginePath)) {
  console.log("Court Navigation Engine missing. Run APPLY mode.");
  process.exit(1);
}

const engine = require(enginePath);
engine.resetNavigationForTestOnly();

const courts = engine.listCourts();
const readiness = engine.checkCourtReadinessForMatter("MATTER-VALIDATION-10K");
const dashboard = engine.generateNavigationDashboard();
const health = engine.getNavigationHealth();
const indexText = fs.readFileSync(indexPath, "utf8");

const report = {
  phase: "10K",
  module: "Court Navigation Intelligence",
  timestamp: new Date().toISOString(),
  files: {
    engineExists: fs.existsSync(enginePath),
    routeExists: fs.existsSync(routePath),
    routeMountedInIndex: indexText.includes("courtNavigationRoutes")
  },
  tests: {
    courtsSeeded: courts.length >= 3,
    readinessGenerated: !!readiness.status,
    dashboardGenerated: !!dashboard.status,
    healthGenerated: !!health.status
  },
  health,
  status: (
    fs.existsSync(enginePath) &&
    fs.existsSync(routePath) &&
    indexText.includes("courtNavigationRoutes") &&
    courts.length >= 3 &&
    !!readiness.status &&
    !!dashboard.status &&
    !!health.status
  ) ? "PASS" : "FAIL"
};

fs.writeFileSync(path.join(reportsDir, "phase10K-court-navigation-report.json"), JSON.stringify(report, null, 2));

const lines = [
  "LITIGATION 360 - PHASE 10K COURT NAVIGATION INTELLIGENCE REPORT",
  "==============================================================",
  "",
  "Timestamp: " + report.timestamp,
  "Status: " + report.status,
  "Engine Exists: " + report.files.engineExists,
  "Route Exists: " + report.files.routeExists,
  "Route Mounted In index.js: " + report.files.routeMountedInIndex,
  "Courts Seeded: " + report.tests.courtsSeeded,
  "Readiness Generated: " + report.tests.readinessGenerated,
  "Dashboard Generated: " + report.tests.dashboardGenerated,
  "Health Generated: " + report.tests.healthGenerated,
  "Health Status: " + health.status
];

fs.writeFileSync(path.join(reportsDir, "phase10K-court-navigation-report.txt"), lines.join("\n"));
console.log(lines.join("\n"));

if (report.status !== "PASS") process.exit(1);
'@ | Out-File -LiteralPath $ValidationJs -Encoding UTF8

@"
# LITIGATION 360 - PHASE 10K COURT NAVIGATION INTELLIGENCE

## Purpose
Create court navigation and logistics intelligence before live Google Maps/Waze integration.

## Created Files
- backend\src\automation\courtNavigationEngine.js
- backend\src\routes\courtNavigationRoutes.js
- backend\src\index.js route mount

## API Endpoints
- GET /api/enterprise/navigation/health
- GET /api/enterprise/navigation/metrics
- GET /api/enterprise/navigation/dashboard
- GET /api/enterprise/navigation/courts
- POST /api/enterprise/navigation/courts
- GET /api/enterprise/navigation/courts/:courtName
- GET /api/enterprise/navigation/travel-plan/:courtEventId
- GET /api/enterprise/navigation/readiness/:matterId
- GET /api/enterprise/navigation/test/dashboard
- GET /api/enterprise/navigation/test/readiness

## Runtime Tests
After backend restart:
- http://localhost:5000/api/enterprise/navigation/health
- http://localhost:5000/api/enterprise/navigation/courts
- http://localhost:5000/api/enterprise/navigation/test/dashboard

## Rule
This phase uses deterministic travel planning and readiness logic only. Live Google Maps/Waze API integration comes later.
"@ | Out-File -LiteralPath (Join-Path $Docs "PHASE10K-COURT-NAVIGATION-PROTOCOL.md") -Encoding UTF8

Write-Host ""
Write-Host "Running validation..."
node $ValidationJs
$exit=$LASTEXITCODE

Write-Host ""
Write-Host "Reports:"
Write-Host $Reports
Write-Host ""
Write-Host "Backups:"
Write-Host $Backups
Write-Host ""

if($exit -eq 0){Write-Host "PHASE 10K COURT NAVIGATION STATUS: PASS" -ForegroundColor Green;Log "PASS"}else{Write-Host "PHASE 10K COURT NAVIGATION STATUS: FAIL - CHECK REPORT" -ForegroundColor Yellow;Log "FAIL"}
Read-Host "Press Enter to close"
exit $exit
