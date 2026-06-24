param([ValidateSet("DRYRUN","APPLY")][string]$Mode="DRYRUN")

$ProjectRoot="C:\Users\jep_edmundrulz\litigation-360-workspace\litigation-360-software"
$Src=Join-Path $ProjectRoot "backend\src"
$Automation=Join-Path $Src "automation"
$PhaseDir=Join-Path $ProjectRoot "_operations\phase-10K-court-registry-perkeso-industrial-court-patch"
$Reports=Join-Path $PhaseDir "reports"
$Logs=Join-Path $PhaseDir "logs"
$Backups=Join-Path $PhaseDir "backups"
$Docs=Join-Path $PhaseDir "docs"
$Validation=Join-Path $PhaseDir "validation"
New-Item -ItemType Directory -Force -Path $PhaseDir,$Reports,$Logs,$Backups,$Docs,$Validation | Out-Null

$LogFile=Join-Path $Logs "phase-10K-perkeso-industrial-court-patch-log.txt"
$EnginePath=Join-Path $Automation "courtNavigationEngine.js"

function Log($Text){Add-Content -LiteralPath $LogFile -Value "[$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')] $Text"}
function Backup-IfExists($Path){if(Test-Path -LiteralPath $Path){$n=Split-Path $Path -Leaf;$d=Join-Path $Backups ($n+"."+(Get-Date -Format "yyyyMMdd_HHmmss")+".bak");Copy-Item -LiteralPath $Path -Destination $d -Force;Log "Backup: $Path --> $d"}}

Clear-Host
Write-Host "============================================================"
Write-Host "L360 - PHASE 10K COURT REGISTRY PATCH"
Write-Host "Industrial Court + PERKESO Locations"
Write-Host "============================================================"
Write-Host "Mode: $Mode"
Write-Host "Project root: $ProjectRoot"
Write-Host ""

Log "PATCH START Mode=$Mode"

if(!(Test-Path -LiteralPath $EnginePath)){
  Write-Host "ERROR: courtNavigationEngine.js not found. Complete Phase 10K first." -ForegroundColor Red
  Read-Host "Press Enter to close"
  exit 1
}

$PatchMarkerStart="// PHASE_10K_PERKESO_INDUSTRIAL_COURT_PATCH_START"
$PatchMarkerEnd="// PHASE_10K_PERKESO_INDUSTRIAL_COURT_PATCH_END"

$PatchBlock=@'
  // PHASE_10K_PERKESO_INDUSTRIAL_COURT_PATCH_START
  registerCourt({
    courtName: "Industrial Court of Malaysia Kuala Lumpur",
    address: "Level 14, Wisma PERKESO, No.155, Jalan Tun Razak, 50400 Kuala Lumpur",
    latitude: 3.1649,
    longitude: 101.7156,
    parkingNotes: "Wisma PERKESO / Jalan Tun Razak area. Allow additional time for parking, lift access, court floor registration, and security screening.",
    entryNotes: "Industrial Court KL is at Level 14, Wisma PERKESO. Confirm courtroom/mention room before departure.",
    securityNotes: "Bring IC/passport, firm ID if available, appointment/cause list details, and relevant court papers.",
    defaultTravelMinutes: 60,
    defaultBufferMinutes: 45
  });

  registerCourt({
    courtName: "Mahkamah Perusahaan Malaysia Kuala Lumpur",
    address: "Level 14, Wisma PERKESO, No.155, Jalan Tun Razak, 50400 Kuala Lumpur",
    latitude: 3.1649,
    longitude: 101.7156,
    parkingNotes: "Same location as Industrial Court of Malaysia Kuala Lumpur. Treat as court appearance location.",
    entryNotes: "Use this Malay-name alias so searches for Mahkamah Perusahaan also match.",
    securityNotes: "Confirm proceeding details, e-Mention/physical attendance requirement, and assigned court room.",
    defaultTravelMinutes: 60,
    defaultBufferMinutes: 45
  });

  registerCourt({
    courtName: "PERKESO Wilayah Persekutuan Kuala Lumpur",
    address: "Wisma PERKESO, No.155, Jalan Tun Razak, 50400 Kuala Lumpur",
    latitude: 3.1649,
    longitude: 101.7156,
    parkingNotes: "Allow extra time for Jalan Tun Razak traffic and building parking.",
    entryNotes: "Useful for PERKESO KL office visits, employment/social security matters, and related filings.",
    securityNotes: "Bring appointment details, company/claimant documents, identification, and matter reference.",
    defaultTravelMinutes: 60,
    defaultBufferMinutes: 40
  });

  registerCourt({
    courtName: "PERKESO Headquarters Jalan Ampang",
    address: "Menara PERKESO, 281, Jalan Ampang, 50538 Kuala Lumpur",
    latitude: 3.1595,
    longitude: 101.7470,
    parkingNotes: "Jalan Ampang can be congested. Allow extra time for parking and reception registration.",
    entryNotes: "Use this for PERKESO headquarters / SOCSO head office visits.",
    securityNotes: "Bring appointment details, identification, and relevant supporting documents.",
    defaultTravelMinutes: 65,
    defaultBufferMinutes: 45
  });

  registerCourt({
    courtName: "SOCSO Headquarters Jalan Ampang",
    address: "Menara PERKESO, 281, Jalan Ampang, 50538 Kuala Lumpur",
    latitude: 3.1595,
    longitude: 101.7470,
    parkingNotes: "Same as PERKESO Headquarters Jalan Ampang. SOCSO is the English equivalent reference.",
    entryNotes: "Alias entry so SOCSO searches route to Menara PERKESO.",
    securityNotes: "Bring appointment details, identification, and relevant supporting documents.",
    defaultTravelMinutes: 65,
    defaultBufferMinutes: 45
  });
  // PHASE_10K_PERKESO_INDUSTRIAL_COURT_PATCH_END
'@

if($Mode -eq "APPLY"){
  Backup-IfExists $EnginePath
  $text=Get-Content -LiteralPath $EnginePath -Raw

  if($text -like "*$PatchMarkerStart*"){
    Write-Host "Patch already exists. No duplicate added."
    Log "Patch already exists"
  } else {
    $needle="function seedDefaultCourts() {"
    if($text -notlike "*$needle*"){
      Write-Host "ERROR: seedDefaultCourts function not found." -ForegroundColor Red
      Log "ERROR seedDefaultCourts missing"
      Read-Host "Press Enter"
      exit 1
    }

    $text=$text -replace [regex]::Escape($needle), ($needle+"`r`n"+$PatchBlock)
    Set-Content -LiteralPath $EnginePath -Value $text -Encoding UTF8
    Write-Host "Patch inserted into courtNavigationEngine.js"
    Log "Patch inserted"
  }
}

$ValidationJs=Join-Path $Validation "validate-phase10K-perkeso-industrial-court-patch.js"
@'
const fs = require("fs");
const path = require("path");

const projectRoot = path.resolve(__dirname, "..", "..", "..");
const srcRoot = path.join(projectRoot, "backend", "src");
const reportsDir = path.join(projectRoot, "_operations", "phase-10K-court-registry-perkeso-industrial-court-patch", "reports");
fs.mkdirSync(reportsDir, { recursive: true });

const enginePath = path.join(srcRoot, "automation", "courtNavigationEngine.js");

if (!fs.existsSync(enginePath)) {
  console.log("courtNavigationEngine.js missing.");
  process.exit(1);
}

delete require.cache[require.resolve(enginePath)];
const nav = require(enginePath);
const courts = nav.listCourts();

const required = [
  "Industrial Court of Malaysia Kuala Lumpur",
  "Mahkamah Perusahaan Malaysia Kuala Lumpur",
  "PERKESO Wilayah Persekutuan Kuala Lumpur",
  "PERKESO Headquarters Jalan Ampang",
  "SOCSO Headquarters Jalan Ampang"
];

const found = required.map(name => ({
  courtName: name,
  exists: !!nav.getCourt(name),
  address: nav.getCourt(name)?.address || null
}));

const report = {
  phase: "10K-PATCH",
  module: "Court Registry PERKESO Industrial Court Patch",
  timestamp: new Date().toISOString(),
  totalCourts: courts.length,
  required,
  found,
  status: found.every(item => item.exists) ? "PASS" : "FAIL"
};

fs.writeFileSync(path.join(reportsDir, "phase10K-perkeso-industrial-court-patch-report.json"), JSON.stringify(report, null, 2));

const lines = [
  "L360 - PHASE 10K COURT REGISTRY PATCH REPORT",
  "============================================",
  "",
  "Timestamp: " + report.timestamp,
  "Status: " + report.status,
  "Total Courts: " + report.totalCourts,
  "",
  ...found.map(item => `${item.exists ? "PASS" : "FAIL"} - ${item.courtName} - ${item.address || "MISSING"}`)
];

fs.writeFileSync(path.join(reportsDir, "phase10K-perkeso-industrial-court-patch-report.txt"), lines.join("\n"));
console.log(lines.join("\n"));

if (report.status !== "PASS") process.exit(1);
'@ | Out-File -LiteralPath $ValidationJs -Encoding UTF8

@"
# L360 - PHASE 10K COURT REGISTRY PATCH

## Added Locations
1. Industrial Court of Malaysia Kuala Lumpur
2. Mahkamah Perusahaan Malaysia Kuala Lumpur
3. PERKESO Wilayah Persekutuan Kuala Lumpur
4. PERKESO Headquarters Jalan Ampang
5. SOCSO Headquarters Jalan Ampang

## Source Locations
- Industrial Court / Mahkamah Perusahaan KL:
  Level 14, Wisma PERKESO, No.155, Jalan Tun Razak, 50400 Kuala Lumpur

- PERKESO Wilayah Persekutuan Kuala Lumpur:
  Wisma PERKESO, No.155, Jalan Tun Razak, 50400 Kuala Lumpur

- PERKESO Headquarters / SOCSO HQ:
  Menara PERKESO, 281, Jalan Ampang, 50538 Kuala Lumpur

## Runtime Tests
After restart:
- http://localhost:5000/api/enterprise/navigation/courts
- http://localhost:5000/api/enterprise/navigation/courts/Industrial%20Court%20of%20Malaysia%20Kuala%20Lumpur
- http://localhost:5000/api/enterprise/navigation/courts/PERKESO%20Headquarters%20Jalan%20Ampang

## Rule
This patch only updates deterministic court registry defaults. It does not call Google Maps/Waze yet.
"@ | Out-File -LiteralPath (Join-Path $Docs "PHASE10K-PERKESO-INDUSTRIAL-COURT-PATCH-PROTOCOL.md") -Encoding UTF8

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

if($exit -eq 0){Write-Host "PHASE 10K COURT REGISTRY PATCH STATUS: PASS" -ForegroundColor Green;Log "PASS"}else{Write-Host "PHASE 10K COURT REGISTRY PATCH STATUS: FAIL - CHECK REPORT" -ForegroundColor Yellow;Log "FAIL"}
Read-Host "Press Enter to close"
exit $exit
