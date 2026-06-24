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
