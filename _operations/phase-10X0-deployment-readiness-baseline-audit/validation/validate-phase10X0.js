const fs = require("fs");
const path = require("path");

const root = process.env.L360_ROOT;
const auditScript = process.env.L360_AUDIT_SCRIPT;
const registries = process.env.L360_REGISTRIES;
const reports = process.env.L360_REPORTS;

fs.mkdirSync(reports, { recursive: true });

const expected = [
  "_backend_inventory.json",
  "_frontend_inventory.json",
  "_route_registry.json",
  "_enterprise_registry.json",
  "_database_registry.json",
  "_deployment_registry.json",
  "_master_baseline_registry.json"
];

const checks = [
  { name: "Audit script exists", pass: fs.existsSync(auditScript), path: auditScript },
  ...expected.map(name => ({
    name: name + " exists",
    pass: fs.existsSync(path.join(registries, name)),
    path: path.join(registries, name)
  }))
];

const passed = checks.filter(c => c.pass).length;
const failed = checks.length - passed;

const report = {
  phase: "10X.0-VALIDATION",
  timestamp: new Date().toISOString(),
  status: failed === 0 ? "PASS" : "FAIL",
  passed,
  failed,
  checks
};

fs.writeFileSync(path.join(reports, "phase10X0-validation-report.json"), JSON.stringify(report, null, 2));

console.log([
  "LITIGATION 360 - PHASE 10X.0 VALIDATION REPORT",
  "===============================================",
  "",
  "Timestamp: " + report.timestamp,
  "Status: " + report.status,
  "Passed: " + report.passed,
  "Failed: " + report.failed,
  "",
  ...checks.map(c => (c.pass ? "PASS" : "FAIL") + " - " + c.name)
].join("\n"));

if (report.status !== "PASS") process.exit(1);
