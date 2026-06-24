const fs = require("fs");
const path = require("path");

const gov = process.env.L360_GOV;
const script = process.env.L360_SCRIPT;
const reports = process.env.L360_REPORTS;

const docs = path.join(gov, "docs");
const registries = path.join(gov, "registries");
const checklists = path.join(gov, "checklists");

fs.mkdirSync(reports, { recursive: true });

const required = [
  path.join(registries, "MASTER-GOVERNANCE-REGISTRY.json"),
  path.join(docs, "MASTER-OPERATIONS-HANDBOOK.md"),
  path.join(docs, "MASTER-DEPLOYMENT-PROTOCOL.md"),
  path.join(docs, "MASTER-VALIDATION-PROTOCOL.md"),
  path.join(docs, "MASTER-TESTING-PROTOCOL.md"),
  path.join(docs, "MASTER-ROLLBACK-PROTOCOL.md"),
  path.join(docs, "MASTER-RECOVERY-PROTOCOL.md"),
  path.join(checklists, "MASTER-DEPLOYMENT-CHECKLIST.md"),
  path.join(checklists, "MASTER-HANDOVER-CHECKLIST.md")
];

const checks = [
  { name: "Generator script exists", pass: fs.existsSync(script) },
  ...required.map(file => ({ name: path.basename(file) + " exists", pass: fs.existsSync(file) }))
];

const passed = checks.filter(c => c.pass).length;
const failed = checks.length - passed;

const report = {
  phase: "10X.7-VALIDATION",
  timestamp: new Date().toISOString(),
  status: failed === 0 ? "PASS" : "FAIL",
  passed,
  failed,
  checks
};

fs.writeFileSync(path.join(reports, "phase10X7-validation-report.json"), JSON.stringify(report, null, 2));

console.log([
  "LITIGATION 360 - PHASE 10X.7 VALIDATION REPORT",
  "==============================================",
  "",
  "Timestamp: " + report.timestamp,
  "Status: " + report.status,
  "Passed: " + report.passed,
  "Failed: " + report.failed,
  "",
  ...checks.map(c => (c.pass ? "PASS" : "FAIL") + " - " + c.name)
].join("\n"));

if (report.status !== "PASS") process.exit(1);
