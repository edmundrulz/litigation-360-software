param([ValidateSet("DRYRUN","APPLY")][string]$Mode="DRYRUN")

$Root="C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software"
$Auto=Join-Path $Root "backend\src\automation"
$CourtEngine=Join-Path $Auto "courtNavigationEngine.js"
$MapsEngine=Join-Path $Auto "mapsIntegrationLayer.js"
$Phase=Join-Path $Root "_operations\phase-10L-maps-court-registry-fix"
$Reports=Join-Path $Phase "reports"
$Backups=Join-Path $Phase "backups"
$Logs=Join-Path $Phase "logs"

New-Item -ItemType Directory -Force -Path $Reports,$Backups,$Logs | Out-Null
$Log=Join-Path $Logs "court-registry-fix-log.txt"

function Write-Log($Text){Add-Content -LiteralPath $Log -Value "[$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')] $Text"}
function Backup($Path){
  if(Test-Path -LiteralPath $Path){
    $name=Split-Path $Path -Leaf
    $dest=Join-Path $Backups ($name+"."+(Get-Date -Format "yyyyMMdd_HHmmss")+".bak")
    Copy-Item -LiteralPath $Path -Destination $dest -Force
    Write-Log "Backup $Path --> $dest"
  }
}

Clear-Host
Write-Host "============================================================"
Write-Host "L360 PHASE 10L MAPS COURT REGISTRY FIX"
Write-Host "============================================================"
Write-Host "Mode: $Mode"
Write-Host ""

if(!(Test-Path -LiteralPath $CourtEngine)){
  Write-Host "ERROR: courtNavigationEngine.js not found."
  Read-Host "Press Enter"
  exit 1
}

if(!(Test-Path -LiteralPath $MapsEngine)){
  Write-Host "ERROR: mapsIntegrationLayer.js not found."
  Read-Host "Press Enter"
  exit 1
}

if($Mode -eq "APPLY"){
  Backup $CourtEngine

  $txt=Get-Content -LiteralPath $CourtEngine -Raw

  if($txt -notlike "*Industrial Court Kuala Lumpur*"){
    $insert=@'

function registerMalaysiaCourtAndAgencyLocations() {
  registerCourt({
    courtName: "Industrial Court Kuala Lumpur",
    address: "Level 14, Wisma PERKESO, No.155 Jalan Tun Razak, Kuala Lumpur",
    latitude: 3.1652,
    longitude: 101.7183,
    parkingNotes: "Allow extra time for Jalan Tun Razak congestion, parking, lift access, and security screening.",
    entryNotes: "Proceed to Wisma PERKESO. Industrial Court Kuala Lumpur is listed at Level 14.",
    securityNotes: "Bring identification and court-related documents.",
    defaultTravelMinutes: 60,
    defaultBufferMinutes: 45
  });

  registerCourt({
    courtName: "PERKESO Kuala Lumpur",
    address: "Wisma PERKESO, No.155 Jalan Tun Razak, Kuala Lumpur",
    latitude: 3.1652,
    longitude: 101.7183,
    parkingNotes: "Jalan Tun Razak traffic can be heavy during peak hours.",
    entryNotes: "Confirm department/counter before arrival.",
    securityNotes: "Bring identification and appointment/reference details.",
    defaultTravelMinutes: 60,
    defaultBufferMinutes: 45
  });

  registerCourt({
    courtName: "PERKESO Headquarters",
    address: "Menara PERKESO, 281 Jalan Ampang, Kuala Lumpur",
    latitude: 3.1606,
    longitude: 101.7467,
    parkingNotes: "Allow additional time for Jalan Ampang traffic and parking.",
    entryNotes: "Confirm floor, department, and appointment before arrival.",
    securityNotes: "Bring identification and appointment/reference details.",
    defaultTravelMinutes: 60,
    defaultBufferMinutes: 45
  });

  registerCourt({
    courtName: "Menara PERKESO Jalan Ampang",
    address: "Menara PERKESO, 281 Jalan Ampang, Kuala Lumpur",
    latitude: 3.1606,
    longitude: 101.7467,
    parkingNotes: "Allow additional time for Jalan Ampang traffic and parking.",
    entryNotes: "Confirm floor, department, and appointment before arrival.",
    securityNotes: "Bring identification and appointment/reference details.",
    defaultTravelMinutes: 60,
    defaultBufferMinutes: 45
  });
}
'@

    if($txt -like "*seedDefaultCourts();*"){
      $txt=$txt -replace "seedDefaultCourts\(\);", ($insert+"`r`nseedDefaultCourts();`r`nregisterMalaysiaCourtAndAgencyLocations();")
    } else {
      $txt=$txt+"`r`n"+$insert+"`r`nregisterMalaysiaCourtAndAgencyLocations();`r`n"
    }

    Set-Content -LiteralPath $CourtEngine -Value $txt -Encoding UTF8
    Write-Log "Inserted Malaysia court and PERKESO registry locations."
  } else {
    Write-Log "Industrial Court Kuala Lumpur already exists. No registry insert needed."
  }
}

$Validate=Join-Path $Phase "validate-10L-court-registry-fix.js"

@'
const fs = require("fs");
const path = require("path");

const root = path.resolve(__dirname, "..", "..");
const src = path.join(root, "backend", "src");
const reports = path.join(root, "_operations", "phase-10L-maps-court-registry-fix", "reports");
fs.mkdirSync(reports, { recursive: true });

const navPath = path.join(src, "automation", "courtNavigationEngine.js");
const mapsPath = path.join(src, "automation", "mapsIntegrationLayer.js");

delete require.cache[require.resolve(navPath)];
delete require.cache[require.resolve(mapsPath)];

const nav = require(navPath);
const maps = require(mapsPath);

const courts = nav.listCourts();
const industrial = nav.getCourt("Industrial Court Kuala Lumpur");
const perkesoKL = nav.getCourt("PERKESO Kuala Lumpur");
const perkesoHQ = nav.getCourt("PERKESO Headquarters");
const courtMap = maps.generateCourtMapLinks("Industrial Court Kuala Lumpur", "Petaling Jaya");

const report = {
  phase: "10L-COURT-REGISTRY-FIX",
  timestamp: new Date().toISOString(),
  tests: {
    industrialCourtExists: !!industrial,
    perkesoKLExists: !!perkesoKL,
    perkesoHQExists: !!perkesoHQ,
    courtMapGenerated: courtMap.ok === true,
    googleMapGenerated: courtMap.ok === true && courtMap.googleMaps.includes("google.com/maps"),
    wazeGenerated: courtMap.ok === true && courtMap.waze.includes("waze.com")
  },
  courtsCount: courts.length,
  courtMap,
  status: (
    !!industrial &&
    !!perkesoKL &&
    !!perkesoHQ &&
    courtMap.ok === true &&
    courtMap.googleMaps.includes("google.com/maps") &&
    courtMap.waze.includes("waze.com")
  ) ? "PASS" : "FAIL"
};

fs.writeFileSync(path.join(reports, "phase10L-court-registry-fix-report.json"), JSON.stringify(report, null, 2));

console.log([
  "LITIGATION 360 - PHASE 10L COURT REGISTRY FIX REPORT",
  "====================================================",
  "",
  "Timestamp: " + report.timestamp,
  "Status: " + report.status,
  "Industrial Court Exists: " + report.tests.industrialCourtExists,
  "PERKESO KL Exists: " + report.tests.perkesoKLExists,
  "PERKESO HQ Exists: " + report.tests.perkesoHQExists,
  "Court Map Generated: " + report.tests.courtMapGenerated,
  "Google Map Generated: " + report.tests.googleMapGenerated,
  "Waze Generated: " + report.tests.wazeGenerated,
  "Courts Count: " + report.courtsCount
].join("\n"));

if(report.status !== "PASS") process.exit(1);
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

if($exit -eq 0){
  Write-Host "PHASE 10L COURT REGISTRY FIX STATUS: PASS" -ForegroundColor Green
}else{
  Write-Host "PHASE 10L COURT REGISTRY FIX STATUS: FAIL" -ForegroundColor Yellow
}

Read-Host "Press Enter to close"
exit $exit
