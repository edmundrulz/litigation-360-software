const fs = require("fs");
const path = require("path");

const smoke = process.env.L360_SMOKE_SCRIPT;
const reports = process.env.L360_REPORTS_DIR;

fs.mkdirSync(reports, { recursive: true });

const text = fs.existsSync(smoke) ? fs.readFileSync(smoke, "utf8") : "";

const report = {
  phase: "10V-V2-FIX",
  timestamp: new Date().toISOString(),
  smokeScriptExists: fs.existsSync(smoke),
  syntaxSafe: text.includes('lines.push((check.pass ? "PASS" : "FAIL") + " - " + check.name);'),
  noBrokenTemplate: !text.includes("...checks.map(c => ${c.pass"),
  status: "FAIL"
};

report.status = report.smokeScriptExists && report.syntaxSafe && report.noBrokenTemplate ? "PASS" : "FAIL";

fs.writeFileSync(path.join(reports, "phase10V-v2-fix-report.json"), JSON.stringify(report, null, 2));

console.log([
  "LITIGATION 360 - PHASE 10V V2 FIX REPORT",
  "========================================",
  "",
  "Timestamp: " + report.timestamp,
  "Status: " + report.status,
  "Smoke Script Exists: " + report.smokeScriptExists,
  "Syntax Safe: " + report.syntaxSafe,
  "Broken Template Removed: " + report.noBrokenTemplate
].join("\n"));

if (report.status !== "PASS") process.exit(1);
