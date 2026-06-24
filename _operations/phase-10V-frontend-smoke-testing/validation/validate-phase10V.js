const fs = require("fs");
const path = require("path");

const root = process.env.L360_ROOT;
const smoke = process.env.L360_SMOKE_SCRIPT;
const reports = process.env.L360_REPORTS_DIR;

fs.mkdirSync(reports, { recursive: true });

const smokeExists = fs.existsSync(smoke);
let smokeContent = smokeExists ? fs.readFileSync(smoke, "utf8") : "";

const report = {
  phase: "10V",
  timestamp: new Date().toISOString(),
  files: {
    smokeScriptExists: smokeExists
  },
  content: {
    checksDashboard: smokeContent.includes("Enterprise dashboard page exists"),
    checksConnectivity: smokeContent.includes("Connectivity validator page exists"),
    checksIndustrialCourt: smokeContent.includes("Industrial Court"),
    checksPERKESO: smokeContent.includes("PERKESO"),
    checksMapsEndpoint: smokeContent.includes("/api/enterprise/maps/health")
  }
};

report.status = (
  report.files.smokeScriptExists &&
  report.content.checksDashboard &&
  report.content.checksConnectivity &&
  report.content.checksIndustrialCourt &&
  report.content.checksPERKESO &&
  report.content.checksMapsEndpoint
) ? "PASS" : "FAIL";

fs.writeFileSync(path.join(reports, "phase10V-deployment-validation-report.json"), JSON.stringify(report, null, 2));

console.log([
  "LITIGATION 360 - PHASE 10V DEPLOYMENT VALIDATION REPORT",
  "======================================================",
  "",
  "Timestamp: " + report.timestamp,
  "Status: " + report.status,
  "Smoke Script Exists: " + report.files.smokeScriptExists,
  "Checks Dashboard: " + report.content.checksDashboard,
  "Checks Connectivity: " + report.content.checksConnectivity,
  "Checks Industrial Court: " + report.content.checksIndustrialCourt,
  "Checks PERKESO: " + report.content.checksPERKESO,
  "Checks Maps Endpoint: " + report.content.checksMapsEndpoint
].join("\n"));

if (report.status !== "PASS") process.exit(1);
