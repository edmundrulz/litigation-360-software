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
