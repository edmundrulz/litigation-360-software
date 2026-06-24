const fs = require("fs");
const path = require("path");

const projectRoot = path.resolve(__dirname, "..", "..", "..");
const srcRoot = path.join(projectRoot, "backend", "src");
const reportsDir = path.join(projectRoot, "_operations", "phase-10A-handler-registry-finisher", "reports");
fs.mkdirSync(reportsDir, { recursive: true });

const EVENT_TYPES = require(path.join(srcRoot, "automation", "eventTypes"));
const registry = require(path.join(srcRoot, "automation", "handlerRegistry"));

const health = registry.getRegistryHealth();
const indexPath = path.join(srcRoot, "index.js");
const indexText = fs.readFileSync(indexPath, "utf8");

const report = {
  phase: "10A",
  module: "Handler Registry Finisher",
  timestamp: new Date().toISOString(),
  registryHealth: health,
  routeFileExists: fs.existsSync(path.join(srcRoot, "routes", "handlerRoutes.js")),
  registryFileExists: fs.existsSync(path.join(srcRoot, "automation", "handlerRegistry.js")),
  routeMountedInIndex: indexText.includes("handlerRoutes"),
  status: (
    health.status === "HEALTHY" &&
    fs.existsSync(path.join(srcRoot, "routes", "handlerRoutes.js")) &&
    fs.existsSync(path.join(srcRoot, "automation", "handlerRegistry.js")) &&
    indexText.includes("handlerRoutes")
  ) ? "PASS" : "FAIL"
};

fs.writeFileSync(path.join(reportsDir, "phase10A-finisher-report.json"), JSON.stringify(report, null, 2));

const lines = [
  "LITIGATION 360 - PHASE 10A HANDLER REGISTRY FINISHER REPORT",
  "===========================================================",
  "",
  "Timestamp: " + report.timestamp,
  "Status: " + report.status,
  "Registry Health: " + health.status,
  "Expected Handlers: " + health.expectedHandlers,
  "Registered Handlers: " + health.registeredHandlers,
  "Missing Handlers: " + health.missingHandlers,
  "Route File Exists: " + report.routeFileExists,
  "Registry File Exists: " + report.registryFileExists,
  "Route Mounted In index.js: " + report.routeMountedInIndex
];

fs.writeFileSync(path.join(reportsDir, "phase10A-finisher-report.txt"), lines.join("\n"));
console.log(lines.join("\n"));

if (report.status !== "PASS") process.exit(1);
