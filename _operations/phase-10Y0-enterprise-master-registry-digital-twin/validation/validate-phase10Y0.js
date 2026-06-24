const fs = require("fs");
const path = require("path");

const phase = process.env.L360_PHASE;
const script = process.env.L360_SCRIPT;
const reports = process.env.L360_REPORTS;

const registries = path.join(phase, "registries");
const graphs = path.join(phase, "graphs");
const twins = path.join(phase, "twins");
const impact = path.join(phase, "impact-analysis");
const debt = path.join(phase, "technical-debt");
const docs = path.join(phase, "docs");

fs.mkdirSync(reports, { recursive: true });

const checks = [
  { name: "Generator Script Exists", pass: fs.existsSync(script) },
  { name: "Master Registry Exists", pass: fs.existsSync(path.join(registries, "master-system-registry.json")) },
  { name: "Digital Twin Exists", pass: fs.existsSync(path.join(twins, "litigation360-digital-twin.json")) },
  { name: "Engine Registry Exists", pass: fs.existsSync(path.join(registries, "engines-registry.json")) },
  { name: "Route Registry Exists", pass: fs.existsSync(path.join(registries, "routes-registry.json")) },
  { name: "Endpoint Registry Exists", pass: fs.existsSync(path.join(registries, "endpoints-registry.json")) },
  { name: "Dependency Graph Exists", pass: fs.existsSync(path.join(graphs, "engine-dependencies.json")) },
  { name: "Impact Analysis Exists", pass: fs.existsSync(path.join(impact, "impact-analysis.json")) },
  { name: "Technical Debt Scan Exists", pass: fs.existsSync(path.join(debt, "technical-debt-scan.json")) },
  { name: "Master System Registry Doc Exists", pass: fs.existsSync(path.join(docs, "MASTER-SYSTEM-REGISTRY.md")) },
  { name: "Master Digital Twin Doc Exists", pass: fs.existsSync(path.join(docs, "MASTER-DIGITAL-TWIN.md")) }
];

const passed = checks.filter(c => c.pass).length;
const failed = checks.length - passed;

const report = {
  phase: "10Y.0-VALIDATION",
  timestamp: new Date().toISOString(),
  status: failed === 0 ? "PASS" : "FAIL",
  passed,
  failed,
  checks
};

fs.writeFileSync(path.join(reports, "phase10Y0-validation-report.json"), JSON.stringify(report, null, 2));

console.log([
  "LITIGATION 360 - PHASE 10Y.0 VALIDATION REPORT",
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
