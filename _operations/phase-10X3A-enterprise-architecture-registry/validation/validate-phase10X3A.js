const fs = require("fs");
const path = require("path");

const script = process.env.L360_EAR_SCRIPT;
const registries = process.env.L360_EAR_REGISTRIES;
const docs = process.env.L360_EAR_DOCS;
const reports = process.env.L360_EAR_REPORTS;

fs.mkdirSync(reports, { recursive: true });

const expectedRegistries = [
  "engine-dependency-map.json",
  "route-engine-map.json",
  "endpoint-registry.json",
  "workflow-registry.json",
  "automation-registry.json",
  "frontend-backend-map.json",
  "criticality-registry.json",
  "enterprise-architecture-master-registry.json"
];

const expectedDocs = [
  "MASTER-ENGINE-REGISTRY.md",
  "MASTER-ROUTE-REGISTRY.md",
  "MASTER-ENDPOINT-REGISTRY.md",
  "MASTER-WORKFLOW-REGISTRY.md",
  "MASTER-AUTOMATION-REGISTRY.md",
  "MASTER-CRITICALITY-REGISTRY.md",
  "MASTER-ARCHITECTURE-DIAGRAM.md"
];

const checks = [
  { name: "Registry script exists", pass: fs.existsSync(script) },
  ...expectedRegistries.map(name => ({ name: name + " exists", pass: fs.existsSync(path.join(registries, name)) })),
  ...expectedDocs.map(name => ({ name: name + " exists", pass: fs.existsSync(path.join(docs, name)) }))
];

const passed = checks.filter(c => c.pass).length;
const failed = checks.length - passed;

const report = {
  phase: "10X.3A-VALIDATION",
  timestamp: new Date().toISOString(),
  status: failed === 0 ? "PASS" : "FAIL",
  passed,
  failed,
  checks
};

fs.writeFileSync(path.join(reports, "phase10X3A-validation-report.json"), JSON.stringify(report, null, 2));

console.log([
  "LITIGATION 360 - PHASE 10X.3A VALIDATION REPORT",
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
