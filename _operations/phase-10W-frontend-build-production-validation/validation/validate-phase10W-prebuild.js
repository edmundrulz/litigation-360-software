const fs = require("fs");
const path = require("path");

const frontend = process.env.L360_FRONTEND;
const reports = process.env.L360_REPORTS;
fs.mkdirSync(reports, { recursive: true });

const packagePath = path.join(frontend, "package.json");
const srcPath = path.join(frontend, "src");
const appPath = fs.existsSync(path.join(srcPath, "App.jsx")) ? path.join(srcPath, "App.jsx") : path.join(srcPath, "App.js");

const files = {
  packageJson: packagePath,
  src: srcPath,
  app: appPath,
  dashboard: path.join(srcPath, "enterprise", "pages", "EnterpriseOperationsDashboard.jsx"),
  connectivity: path.join(srcPath, "enterprise", "pages", "FrontendBackendConnectivityValidator.jsx"),
  enterpriseApi: path.join(srcPath, "enterprise", "api", "enterpriseApi.js"),
  connectivityApi: path.join(srcPath, "enterprise", "api", "connectivityValidatorApi.js")
};

function exists(p) { return fs.existsSync(p); }
function read(p) { return exists(p) ? fs.readFileSync(p, "utf8") : ""; }
function has(p, s) { return read(p).includes(s); }

let pkg = {};
try { pkg = JSON.parse(read(packagePath)); } catch {}

const checks = [
  { name: "package.json exists", pass: exists(files.packageJson) },
  { name: "src folder exists", pass: exists(files.src) },
  { name: "App file exists", pass: exists(files.app) },
  { name: "build script exists", pass: !!pkg.scripts && !!pkg.scripts.build },
  { name: "dev script exists", pass: !!pkg.scripts && !!pkg.scripts.dev },
  { name: "Enterprise dashboard exists", pass: exists(files.dashboard) },
  { name: "Connectivity validator exists", pass: exists(files.connectivity) },
  { name: "Enterprise API exists", pass: exists(files.enterpriseApi) },
  { name: "Connectivity API exists", pass: exists(files.connectivityApi) },
  { name: "App imports dashboard", pass: has(files.app, "EnterpriseOperationsDashboard") },
  { name: "App imports connectivity", pass: has(files.app, "FrontendBackendConnectivityValidator") },
  { name: "Monitoring endpoint referenced", pass: has(files.enterpriseApi, "/api/enterprise/monitoring/health") },
  { name: "Maps endpoint referenced", pass: has(files.connectivityApi, "/api/enterprise/maps/health") },
  { name: "Industrial Court visible", pass: has(files.dashboard, "Industrial Court Kuala Lumpur") && has(files.connectivity, "Industrial Court Kuala Lumpur") },
  { name: "PERKESO visible", pass: has(files.dashboard, "PERKESO") && has(files.connectivity, "PERKESO") }
];

const passed = checks.filter(c => c.pass).length;
const failed = checks.length - passed;

const report = {
  phase: "10W-PREBUILD",
  timestamp: new Date().toISOString(),
  status: failed === 0 ? "PASS" : "FAIL",
  passed,
  failed,
  checks,
  packageScripts: pkg.scripts || {}
};

fs.writeFileSync(path.join(reports, "phase10W-prebuild-report.json"), JSON.stringify(report, null, 2));

console.log([
  "LITIGATION 360 - PHASE 10W PREBUILD VALIDATION REPORT",
  "====================================================",
  "",
  "Timestamp: " + report.timestamp,
  "Status: " + report.status,
  "Passed: " + report.passed,
  "Failed: " + report.failed,
  "",
  ...checks.map(c => (c.pass ? "PASS" : "FAIL") + " - " + c.name)
].join("\n"));

if (report.status !== "PASS") process.exit(1);
