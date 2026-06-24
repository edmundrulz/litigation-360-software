param([ValidateSet("DRYRUN","APPLY")][string]$Mode="DRYRUN")

$Root="C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software"
$Src=Join-Path $Root "backend\src"
$Auto=Join-Path $Src "automation"
$Routes=Join-Path $Src "routes"
$Index=Join-Path $Src "index.js"
$Phase=Join-Path $Root "_operations\phase-10L-maps-restore"
$Reports=Join-Path $Phase "reports"
$Backups=Join-Path $Phase "backups"
$Logs=Join-Path $Phase "logs"
New-Item -ItemType Directory -Force -Path $Reports,$Backups,$Logs,$Auto,$Routes | Out-Null
$Log=Join-Path $Logs "restore-log.txt"

function Write-Log($Text){Add-Content -LiteralPath $Log -Value "[$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')] $Text"}
function Backup($Path){if(Test-Path -LiteralPath $Path){$name=Split-Path $Path -Leaf;$dest=Join-Path $Backups ($name+"."+(Get-Date -Format "yyyyMMdd_HHmmss")+".bak");Copy-Item -LiteralPath $Path -Destination $dest -Force;Write-Log "Backup $Path --> $dest"}}

Clear-Host
Write-Host "============================================================"
Write-Host "L360 PHASE 10L MAPS RESTORE"
Write-Host "============================================================"
Write-Host "Mode: $Mode"
Write-Host ""

if(!(Test-Path -LiteralPath $Index)){Write-Host "ERROR: index.js not found";Read-Host "Press Enter";exit 1}
if(!(Test-Path -LiteralPath (Join-Path $Auto "courtNavigationEngine.js"))){Write-Host "ERROR: courtNavigationEngine.js missing";Read-Host "Press Enter";exit 1}
if(!(Test-Path -LiteralPath (Join-Path $Auto "courtOperationsEngine.js"))){Write-Host "ERROR: courtOperationsEngine.js missing";Read-Host "Press Enter";exit 1}

$Engine=Join-Path $Auto "mapsIntegrationLayer.js"
$Route=Join-Path $Routes "mapsIntegrationRoutes.js"

if($Mode -eq "APPLY"){
  Backup $Engine
  Backup $Route
  Backup $Index

@'
const { getCourt, listCourts, createTravelPlanForCourtEvent } = require("./courtNavigationEngine");
const { getCourtEvents } = require("./courtOperationsEngine");

const mapsMetrics = {
  googleLinksGenerated: 0,
  wazeLinksGenerated: 0,
  courtLinksGenerated: 0,
  handoffsGenerated: 0,
  missingCourtLocations: 0,
  lastGeneratedAt: null
};

function touch(metric) {
  mapsMetrics[metric] += 1;
  mapsMetrics.lastGeneratedAt = new Date().toISOString();
}

function enc(value) {
  return encodeURIComponent(String(value || ""));
}

function destinationForCourt(court) {
  if (!court) return "";
  if (court.latitude && court.longitude) return `${court.latitude},${court.longitude}`;
  return court.address || court.courtName;
}

function generateGoogleMapsLink({ destination, origin = "", travelMode = "driving" } = {}) {
  if (!destination) throw new Error("destination is required");
  touch("googleLinksGenerated");
  return `https://www.google.com/maps/dir/?api=1&destination=${enc(destination)}${origin ? `&origin=${enc(origin)}` : ""}&travelmode=${enc(travelMode)}`;
}

function generateWazeLink({ latitude = null, longitude = null, query = null } = {}) {
  touch("wazeLinksGenerated");
  if (latitude && longitude) return `https://waze.com/ul?ll=${enc(latitude + "," + longitude)}&navigate=yes`;
  if (query) return `https://waze.com/ul?q=${enc(query)}&navigate=yes`;
  throw new Error("latitude/longitude or query is required");
}

function generateCourtMapLinks(courtName, origin = "") {
  const court = getCourt(courtName);
  if (!court) {
    mapsMetrics.missingCourtLocations += 1;
    mapsMetrics.lastGeneratedAt = new Date().toISOString();
    return { ok: false, error: "Court not found in registry", courtName };
  }

  touch("courtLinksGenerated");
  const destination = destinationForCourt(court);

  return {
    ok: true,
    courtName,
    address: court.address,
    latitude: court.latitude,
    longitude: court.longitude,
    googleMaps: generateGoogleMapsLink({ destination, origin }),
    waze: generateWazeLink({
      latitude: court.latitude,
      longitude: court.longitude,
      query: court.address || court.courtName
    }),
    generatedAt: new Date().toISOString()
  };
}

function generateNavigationHandoffForCourtEvent(courtEventId, options = {}) {
  const courtEvent = getCourtEvents({ limit: 1000 }).find(e => e.id === courtEventId);
  if (!courtEvent) return { ok: false, error: "Court event not found" };

  const travelPlan = createTravelPlanForCourtEvent(courtEventId, options);
  if (!travelPlan.ok) return travelPlan;

  const mapLinks = generateCourtMapLinks(courtEvent.courtName, options.origin || "");
  touch("handoffsGenerated");

  return {
    ok: true,
    courtEventId,
    matterId: courtEvent.matterId,
    courtName: courtEvent.courtName,
    eventType: courtEvent.eventType,
    eventDate: courtEvent.eventDate,
    eventTime: courtEvent.eventTime,
    travelPlan: travelPlan.plan,
    mapLinks,
    checklist: {
      openGoogleMaps: !!mapLinks.googleMaps,
      openWaze: !!mapLinks.waze,
      departBy: travelPlan.plan.recommendedDeparture,
      arriveBy: travelPlan.plan.arrivalTarget,
      confirmParking: !!travelPlan.plan.parkingNotes,
      confirmCourtRoom: !!courtEvent.courtRoom
    },
    generatedAt: new Date().toISOString()
  };
}

function generateMapsDashboard() {
  const courts = listCourts();
  const now = new Date();
  const future = new Date();
  future.setDate(future.getDate() + 30);

  const upcoming = getCourtEvents({ limit: 1000 }).filter(e => {
    const d = new Date(e.eventDate);
    return d >= now && d <= future;
  });

  const handoffs = [];
  for (const event of upcoming.slice(0, 25)) {
    const handoff = generateNavigationHandoffForCourtEvent(event.id);
    if (handoff.ok) handoffs.push(handoff);
  }

  return {
    module: "Maps Integration Layer",
    status: mapsMetrics.missingCourtLocations > 0 ? "ATTENTION" : "HEALTHY",
    registeredCourts: courts.length,
    upcomingCourtEvents: upcoming.length,
    handoffsGenerated: handoffs.length,
    missingCourtLocations: mapsMetrics.missingCourtLocations,
    handoffs,
    generatedAt: new Date().toISOString()
  };
}

function getMapsHealth() {
  const dashboard = generateMapsDashboard();
  return {
    module: "Maps Integration Layer",
    status: dashboard.status,
    registeredCourts: dashboard.registeredCourts,
    upcomingCourtEvents: dashboard.upcomingCourtEvents,
    handoffsGenerated: mapsMetrics.handoffsGenerated,
    googleLinksGenerated: mapsMetrics.googleLinksGenerated,
    wazeLinksGenerated: mapsMetrics.wazeLinksGenerated,
    courtLinksGenerated: mapsMetrics.courtLinksGenerated,
    missingCourtLocations: mapsMetrics.missingCourtLocations,
    lastGeneratedAt: mapsMetrics.lastGeneratedAt,
    timestamp: new Date().toISOString()
  };
}

function getMapsMetrics() {
  return { ...mapsMetrics, timestamp: new Date().toISOString() };
}

function resetMapsForTestOnly() {
  mapsMetrics.googleLinksGenerated = 0;
  mapsMetrics.wazeLinksGenerated = 0;
  mapsMetrics.courtLinksGenerated = 0;
  mapsMetrics.handoffsGenerated = 0;
  mapsMetrics.missingCourtLocations = 0;
  mapsMetrics.lastGeneratedAt = null;
}

module.exports = {
  generateGoogleMapsLink,
  generateWazeLink,
  generateCourtMapLinks,
  generateNavigationHandoffForCourtEvent,
  generateMapsDashboard,
  getMapsHealth,
  getMapsMetrics,
  resetMapsForTestOnly
};
'@ | Out-File -LiteralPath $Engine -Encoding UTF8

@'
const express = require("express");
const router = express.Router();

const {
  generateGoogleMapsLink,
  generateWazeLink,
  generateCourtMapLinks,
  generateNavigationHandoffForCourtEvent,
  generateMapsDashboard,
  getMapsHealth,
  getMapsMetrics
} = require("../automation/mapsIntegrationLayer");

router.get("/health", (req, res) => res.json(getMapsHealth()));
router.get("/metrics", (req, res) => res.json(getMapsMetrics()));
router.get("/dashboard", (req, res) => res.json(generateMapsDashboard()));

router.get("/google", (req, res) => {
  try {
    res.json({
      ok: true,
      url: generateGoogleMapsLink({
        destination: req.query.destination,
        origin: req.query.origin || "",
        travelMode: req.query.travelMode || "driving"
      })
    });
  } catch (err) {
    res.status(400).json({ ok: false, error: err.message });
  }
});

router.get("/waze", (req, res) => {
  try {
    res.json({
      ok: true,
      url: generateWazeLink({
        latitude: req.query.latitude,
        longitude: req.query.longitude,
        query: req.query.query
      })
    });
  } catch (err) {
    res.status(400).json({ ok: false, error: err.message });
  }
});

router.get("/court/:courtName", (req, res) => {
  const result = generateCourtMapLinks(req.params.courtName, req.query.origin || "");
  res.status(result.ok ? 200 : 404).json(result);
});

router.get("/handoff/:courtEventId", (req, res) => {
  const result = generateNavigationHandoffForCourtEvent(req.params.courtEventId, {
    origin: req.query.origin || "",
    travelMinutes: req.query.travelMinutes,
    bufferMinutes: req.query.bufferMinutes
  });
  res.status(result.ok ? 200 : 404).json(result);
});

router.get("/test/google", (req, res) => {
  res.json({
    ok: true,
    url: generateGoogleMapsLink({
      destination: "Wisma PERKESO, 155 Jalan Tun Razak, Kuala Lumpur",
      origin: "Petaling Jaya",
      travelMode: "driving"
    })
  });
});

router.get("/test/court", (req, res) => {
  res.json(generateCourtMapLinks("Industrial Court Kuala Lumpur", "Petaling Jaya"));
});

module.exports = router;
'@ | Out-File -LiteralPath $Route -Encoding UTF8

  $txt=Get-Content -LiteralPath $Index -Raw
  $mount='app.use("/api/enterprise/maps", require("./routes/mapsIntegrationRoutes"));'
  if($txt -notlike '*mapsIntegrationRoutes*'){
    if($txt -like '*courtNavigationRoutes*'){
      $txt=$txt -replace 'app\.use\("/api/enterprise/navigation",\s*require\("\./routes/courtNavigationRoutes"\)\);', ('$0'+"`r`n"+$mount)
    } else {
      $txt=$txt+"`r`n// Phase 10L Maps Restore Route`r`n"+$mount+"`r`n"
    }
    Set-Content -LiteralPath $Index -Value $txt -Encoding UTF8
  }
}

$Validate=Join-Path $Phase "validate-10L-restore.js"
@'
const fs = require("fs");
const path = require("path");

const root = path.resolve(__dirname, "..", "..");
const src = path.join(root, "backend", "src");
const reports = path.join(root, "_operations", "phase-10L-maps-restore", "reports");
fs.mkdirSync(reports, { recursive: true });

const enginePath = path.join(src, "automation", "mapsIntegrationLayer.js");
const routePath = path.join(src, "routes", "mapsIntegrationRoutes.js");
const indexPath = path.join(src, "index.js");

if (!fs.existsSync(enginePath)) {
  console.log("Maps Integration Layer missing. Run APPLY mode.");
  process.exit(1);
}

const engine = require(enginePath);
engine.resetMapsForTestOnly();

const google = engine.generateGoogleMapsLink({ destination: "Wisma PERKESO, 155 Jalan Tun Razak, Kuala Lumpur", origin: "Petaling Jaya" });
const waze = engine.generateWazeLink({ query: "Wisma PERKESO, 155 Jalan Tun Razak, Kuala Lumpur" });
const court = engine.generateCourtMapLinks("Industrial Court Kuala Lumpur", "Petaling Jaya");
const dashboard = engine.generateMapsDashboard();
const health = engine.getMapsHealth();
const indexText = fs.readFileSync(indexPath, "utf8");

const report = {
  phase: "10L-RESTORE",
  timestamp: new Date().toISOString(),
  files: {
    engineExists: fs.existsSync(enginePath),
    routeExists: fs.existsSync(routePath),
    routeMountedInIndex: indexText.includes("mapsIntegrationRoutes")
  },
  tests: {
    googleLinkGenerated: google.includes("google.com/maps"),
    wazeLinkGenerated: waze.includes("waze.com"),
    courtMapGenerated: court.ok === true,
    dashboardGenerated: !!dashboard.status,
    healthGenerated: !!health.status
  },
  health,
  status: (
    fs.existsSync(enginePath) &&
    fs.existsSync(routePath) &&
    indexText.includes("mapsIntegrationRoutes") &&
    google.includes("google.com/maps") &&
    waze.includes("waze.com") &&
    court.ok === true &&
    !!dashboard.status &&
    !!health.status
  ) ? "PASS" : "FAIL"
};

fs.writeFileSync(path.join(reports, "phase10L-restore-report.json"), JSON.stringify(report, null, 2));

console.log([
  "LITIGATION 360 - PHASE 10L MAPS RESTORE REPORT",
  "================================================",
  "",
  "Timestamp: " + report.timestamp,
  "Status: " + report.status,
  "Engine Exists: " + report.files.engineExists,
  "Route Exists: " + report.files.routeExists,
  "Route Mounted In index.js: " + report.files.routeMountedInIndex,
  "Google Link Generated: " + report.tests.googleLinkGenerated,
  "Waze Link Generated: " + report.tests.wazeLinkGenerated,
  "Court Map Generated: " + report.tests.courtMapGenerated,
  "Health Status: " + health.status
].join("\n"));

if (report.status !== "PASS") process.exit(1);
'@ | Out-File -LiteralPath $Validate -Encoding UTF8

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

if($exit -eq 0){Write-Host "PHASE 10L MAPS RESTORE STATUS: PASS" -ForegroundColor Green}else{Write-Host "PHASE 10L MAPS RESTORE STATUS: FAIL" -ForegroundColor Yellow}
Read-Host "Press Enter to close"
exit $exit
